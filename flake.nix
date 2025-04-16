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
        
        TMP_DIR=$(mktemp -d)

        # prepare data file for editing
        if [[ ''${1+x} ]] && [[ -f "$1" ]]; then
          CONFIG_JSON=$(sed -n '1s/^# //p' $1)

          TEMPLATE=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".template")
          LANGUAGE=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".lang")
          THEME=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".theme")
          ASSETS=$(echo $CONFIG_JSON | ${pkgs.jq}/bin/jq -r ".assets")
          FILENAME=$(basename $1 .toml)

          cp $1 $TMP_DIR/data.toml
        else
          TEMPLATE=$(basename $(${pkgs.gum}/bin/gum file ${self}/templates/) .typ)
          LANGUAGE=$(${pkgs.gum}/bin/gum choose "en" "de")
          THEME=$(${pkgs.gum}/bin/gum choose "latte" "frappe" "macchiato" "mocha" )
          ASSETS=${self}/assets
          FILENAME=$(basename $TEMPLATE .typ)

          echo -n "# { \"template\": \"$TEMPLATE\"," > $TMP_DIR/data.toml
          echo -n "\"lang\": \"$LANGUAGE\"," >> $TMP_DIR/data.toml
          echo -n "\"theme\": \"$THEME\"," >> $TMP_DIR/data.toml
          echo "\"assets\": \"$ASSETS\" }" >> $TMP_DIR/data.toml
          echo "" >> $TMP_DIR/data.toml
          cat ${self}/data/$TEMPLATE.toml >> $TMP_DIR/data.toml
        fi

        cp ${self}/templates/$TEMPLATE.typ $TMP_DIR/template.typ
        if [ -f "${self}/translations/$TEMPLATE.$LANGUAGE.yaml" ]; then
          ln -s "${self}/translations/$TEMPLATE.$LANGUAGE.yaml" $TMP_DIR/lang.yaml
        fi
        ln -s $ASSETS $TMP_DIR/assets
        cp -r --no-preserve=all ${self}/templates/modules $TMP_DIR/modules
        ln -s "${inputs.catppuccin-base16}/base16/$THEME.yaml" $TMP_DIR/modules/colors.yaml

        ${pkgs.typst}/bin/typst watch \
          --root $TMP_DIR \
          --font-path ${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })} \
          "$TMP_DIR/template.typ" \
          "$TMP_DIR/$FILENAME.pdf" \
          &> typst.log &
        WATCH_PID=$!

        while [ ! -f "$TMP_DIR/$TEMPLATE.pdf" ]; do
          sleep 0.5
        done
        ${pkgs.evince}/bin/evince "$TMP_DIR/$FILENAME.pdf" &> evince.log &
        EVINCE_PID=$!

        $EDITOR $TMP_DIR/data.toml

        kill $WATCH_PID
        kill $EVINCE_PID

        # no harm in overriding generated pdf as long as the toml exists
        cp -vf "$TMP_DIR/$FILENAME.pdf" ./$FILENAME.pdf
        cp -vf $TMP_DIR/data.toml $FILENAME.toml

        rm -rf $TMP_DIR

        # cleanup
        rm typst.log evince.log
      '';
    in
    {
      apps.default = { type = "app"; program = "${generate}/bin/generate-pdf"; };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.typst
          pkgs.typst-lsp
          pkgs.taplo
          pkgs.nixd
        ];
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
