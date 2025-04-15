{
  description = "Skarmux Typst-Templates";

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};

      generate = pkgs.writeShellScriptBin "generate-pdf" ''
        #!/usr/bin/env bash
        set -euo pipefail

        TMP_DIR=$(mktemp -d)
        trap "rm -rf $TMP_DIR" EXIT
        # NOTE: The typst compiler does follow symlinks, therefore all
        #       .typ files need to be copied to the build location
        cp -r --no-preserve=all ${self}/templates/modules $TMP_DIR/modules

        ln -s ''${ASSETS_PATH:-${self}/assets} $TMP_DIR/assets

        if [ -z "${"TEMPLATE:-"}" ]; then
          echo "Choose a template:"
          TEMPLATE=$(${pkgs.gum}/bin/gum choose \
            "meeting_protocol" \
            "application_letter" \
            "motivational_letter" \
            "curriculum_vitae" )
        fi
        cp ${self}/templates/$TEMPLATE.typ $TMP_DIR/template.typ

        # offer language selection if there are translations available
        shopt -s nullglob
        FILES=(${self}/translations/$TEMPLATE.*.yaml)
        if (( ''${#FILES[@]} > 0 )); then
          if [ -z "${"LANGUAGE:-"}" ]; then
            echo "Choose the template language:"
            LANGUAGE=$(${pkgs.gum}/bin/gum choose "en" "de")
          fi
          ln -s ${self}/translations/$TEMPLATE.$LANGUAGE.yaml $TMP_DIR/lang.yaml
        fi
        unset FILES

        if [ -z "${"THEME:-"}" ]; then
          echo "Choose a color scheme (light mode: latte):"
          THEME=$(${pkgs.gum}/bin/gum choose \
            "latte" \
            "frappe" \
            "macchiato" \
            "mocha" )
        fi
        ln -s ${inputs.catppuccin-base16}/base16/$THEME.yaml $TMP_DIR/modules/colors.yaml

        # edit data
        DATA=$TEMPLATE.toml
        # use pre-existing user template whenever possible
        # TODO: Again... Symlinking would be nice.
        if [ ! -f "$TEMPLATE.toml" ]; then
          cp --no-preserve=all $TEMPLATE.toml $TMP_DIR/data.toml
        else
          cp --no-preserve=all ${self}/data/$TEMPLATE.toml $TMP_DIR/data.toml
        fi

        echo "Edit with live preview? (Launches evince pdf viewer)"
        if ${pkgs.gum}/bin/gum confirm; then
          ${pkgs.typst}/bin/typst watch \
            --root $TMP_DIR \
            --font-path ${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })} \
            $TMP_DIR/template.typ \
            $TMP_DIR/$TEMPLATE.pdf > /dev/null &
          WATCH_PID=$!

          while [ ! -f "$TMP_DIR/$TEMPLATE.pdf" ]; do
            sleep 0.5
          done
          ${pkgs.evince}/bin/evince $TMP_DIR/$TEMPLATE.pdf &
          EVINCE_PID=$!

          $EDITOR $TMP_DIR/data.toml

          kill $WATCH_PID

          # user might have manually exited the window
          if kill -0 "$EVINCE_PID" 2> /dev/null; then
            kill $EVINCE_PID
          fi

          # (Optional) backup to execution location
          # TODO: Getting a symlink to work would be perfect...
          cp -i $TMP_DIR/$TEMPLATE.pdf ./$TEMPLATE.pdf
        else
          $EDITOR $TMP_DIR/data.toml
          cp -i $TMP_DIR/data.toml ./$TEMPLATE.toml
          ${pkgs.typst}/bin/typst compile \
            --root $TMP_DIR \
            --font-path ${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })} \
            $TMP_DIR/template.typ \
            $TEMPLATE.pdf
        fi
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
