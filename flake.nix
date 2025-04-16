{
  description = "Skarmux Typst-Templates";

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};

      generate = pkgs.writeShellScriptBin "generate-pdf" ''
        #!/usr/bin/env bash
        set -euo pipefail

        # NOTE: The typst compiler does follow symlinks, therefore all
        #       .typ files need to be copied to the build location
        #       Same goes for .toml files. But .yaml is fine though!
        
        TMP_DIR=$(mktemp -d)
        trap "rm -rf $TMP_DIR" EXIT

        # DATA
        
        mkdir -p $TMP_DIR/data
        if [[ ''${1+x} ]] && [[ -f "$1" ]]; then
          CONFIG_JSON=$(sed -n '1s/^# //p' $1)
          TEMPLATE=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".template")
          THEME=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".theme")
          ASSETS=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".assets")
          FILENAME=$(basename $1 .toml)
          cp $1 "$TMP_DIR/data/$TEMPLATE.toml"
        else
          TEMPLATE=$(basename $(${pkgs.gum}/bin/gum choose \
            "curriculum_vitae" \
            "meeting_protocol" \
            "application_letter" \
            "motivational_letter" \
            ) .typ)
          THEME=$(${pkgs.gum}/bin/gum choose "latte" "frappe" "macchiato" "mocha" )
          ASSETS=${self}/templates/assets
          FILENAME=$(basename $TEMPLATE .typ)
          if [ ! -f "$FILENAME.toml" ]; then
            # file exists and user probably didn't select it as input parameter
            # FIXME bold assumption. accidents might happen. confusion and such
            echo -n "# { \"template\": \"$TEMPLATE\"," > $FILENAME.toml
            echo -n "\"theme\": \"$THEME\"," >> $FILENAME.toml
            echo "\"assets\": \"$ASSETS\" }" >> $FILENAME.toml
            echo "" >> $FILENAME.toml
            cat ${self}/templates/data/$TEMPLATE.toml >> $FILENAME.toml
          fi
          cp $FILENAME.toml "$TMP_DIR/data/$TEMPLATE.toml"
        fi

        # TYPST
        
        cp ${self}/templates/$TEMPLATE.typ "$TMP_DIR/$TEMPLATE.typ"
        cp -r --no-preserve=all ${self}/templates/modules $TMP_DIR/modules
        ln -s $ASSETS $TMP_DIR/assets
        ln -s ${self}/templates/i18n $TMP_DIR/i18n
        ln -s "${inputs.catppuccin-base16}/base16/$THEME.yaml" $TMP_DIR/modules/colors.yaml

        # COMPILE
        
        ${pkgs.typst}/bin/typst watch --root $TMP_DIR \
          --font-path ${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })} \
          "$TMP_DIR/$TEMPLATE.typ" $FILENAME.pdf > typst.log 2>&1 &
        WATCH_PID=$!

        while [ ! -f "$FILENAME.pdf" ]; do sleep 0.5; done
        ${pkgs.evince}/bin/evince $FILENAME.pdf > /dev/null 2>&1 &

        $EDITOR "$TMP_DIR/data/$TEMPLATE.toml"
        cp -f "$TMP_DIR/data/$TEMPLATE.toml" $FILENAME.toml

        # let typst watch churn a little longer for the final changes
        # made to the toml
        sleep 0.5
        kill -15 $WATCH_PID
      '';
    in
    {
      apps.default = {
        type = "app";
        program = "${generate}/bin/generate-pdf";
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          typst
          typst-lsp
          taplo
          nixd
        ];
        TYPST_FONT_PATHS = "${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })}";
        THEME = "frappe";
        shellHook = ''
          ln -fs ${inputs.catppuccin-base16}/base16/$THEME.yaml ./templates/modules/colors.yaml

          WATCH_PIDS=()
          typst watch templates/curriculum_vitae.typ curriculum_vitae.pdf > typst.log 2>&1 &
          WATCH_PIDS+=$!
          typst watch templates/application_letter.typ application_letter.pdf > typst.log 2>&1 &
          WATCH_PIDS+=$!
          typst watch templates/motivational_letter.typ motivational_letter.pdf > typst.log 2>&1 &
          WATCH_PIDS+=$!
          typst watch templates/meeting_protocol.typ meeting_protocol.pdf > typst.log 2>&1 &
          WATCH_PIDS+=$!

          trap "for pid in "''${WATCH_PIDS[@]}"; do kill $pid; done" EXIT
        '';
      };
    }
  );

  inputs = {
    catppuccin-base16.flake = false;
    catppuccin-base16.url = "github:catppuccin/base16?shallow=1";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };
}
