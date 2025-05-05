{
  description = "Skarmux Typst-Templates";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = import nixpkgs { inherit system; };

      generate = pkgs.writeShellScriptBin "generate-pdf" ''
        #!/usr/bin/env bash
        set -euo pipefail

        # nix run [FLAKE] -- [FILE]
        # FILE -- <name>.<lang>.<template>.typ

        if [ -z "$1" ]; then
          echo "<filename>.<lang>.<template>.toml"
          read -p "Enter filename: " FILENAME
          echo "$FILENAME.<lang>.<template>.toml"
          LANG=$(${pkgs.gum}/bin/gum choose "en" "de")
          echo "$FILENAME.$LANG.<template>.toml"
          TEMPLATE=$(${pkgs.gum}/bin/gum choose \
            "cv" \
            "meeting" \
            "application" \
            "motivation" )
          echo "$FILENAME.$LANG.$TEMPLATE.toml"
          FILE="$FILENAME.$LANG.$TEMPLATE.toml"
          # Copy blank toml into current directory
          cp "${self}/templates/data/blank/$TEMPLATE.toml" $FILE
        else
          FILE=$1
          if [[ "$FILE" =~ ^([^.]+)\.([^.]+)\.([^.]+)\.toml$ ]]; then
            FILENAME="''${BASH_REMATCH[1]}"     # default to 'en' if lang is not present
            LANG="''${BASH_REMATCH[2]}"     # default to 'en' if lang is not present
            TEMPLATE="''${BASH_REMATCH[3]}"
          else
            echo "invalid filename format! expected: <name>.<lang>.<template>.toml"
            exit 1
          fi
        fi

        # create temporary directory that serves as root for the typst compiler
        echo "preparing working dir for compilation"
        TYPST_ROOT=$(mktemp -d)
        trap "rm -rf $TYPST_ROOT" EXIT
        cp ${self}/templates/$TEMPLATE.typ "$TYPST_ROOT/$TEMPLATE.typ"
        cp -rv --no-preserve=all ${self}/templates/modules "$TYPST_ROOT/modules"
        # copy/symlink image assets to root
        echo "done"

        grep '^image *= *"' "$FILE" | sed -E 's/^image *= *"(.*)"/\1/' | while IFS= read -r filepath; do
            if [[ -f "$filepath" ]]; then
                base=$(dirname $FILE);
                mkdir -p "$TYPST_ROOT/$(dirname "$filepath")"
                cp "$base/$filepath" "$TYPST_ROOT/$filepath"
            else
                echo "Warning: $filepath does not exist."
            fi
        done

        echo "setting up assets path"
        ASSETS=''${ASSETS:-assets}
        if [ ! -d $ASSETS ]; then
          echo "could not find assets directory at current location."
          echo "checked at `pwd`/assets"
          echo "please set the correct path in ASSETS=<path>."
          echo "falling back to sample assets instead"
          ASSETS=${self}/templates/assets
        fi
        ln -s $ASSETS "$TYPST_ROOT/assets"
        echo "done"

        # move the file over into the working directory
        mkdir -v "$TYPST_ROOT/data"
        cp -v $FILE "$TYPST_ROOT/data/$TEMPLATE.toml"
        
        PDF="$FILENAME.$LANG.$TEMPLATE.pdf"

        > "typst.log"

        # NOTE: `Symbols-Only` glyphs do not align well horizontally
        #       with all the other Font glyphs. Using ProFont instead.
        TYPST_FONT_PATHS="${pkgs.nerd-fonts.fira-code}"
        TYPST_FONT_PATHS="$TYPST_FONT_PATHS:${pkgs.noto-fonts-color-emoji}"

        ${pkgs.typst}/bin/typst watch \
          --input lang=$LANG \
          --input flavor=''${FLAVOR:-frappe} \
          --input accent=''${ACCENT:-blue} \
          --input label=''${LABEL:-false} \
          --input assets=''${ASSETS:-assets} \
          --font-path $TYPST_FONT_PATHS \
          --ignore-system-fonts \
          "$TYPST_ROOT/$TEMPLATE.typ" \
          $PDF \
          >> "typst.log" 2>&1 &
        WATCH_PID=$!

        $EDITOR "$TYPST_ROOT/data/$TEMPLATE.toml"
        # FIXME When the session crashes, changes won't make it back
        # to the original file and will be lost. Really lost!
        cp -f "$TYPST_ROOT/data/$TEMPLATE.toml" $FILE

        # let typst watch churn a little longer for the final changes
        # made to the toml. `:wq` is too quick of an exit <3
        sleep 0.5
        kill -15 $WATCH_PID # -15: SIGTERM (nicer than kill)
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
          tinymist
          taplo
          evince
          # preview images
          imagemagick
          ghostscript
        ];
        TYPST_FONT_PATHS = "${pkgs.nerd-fonts.fira-code}:${pkgs.noto-fonts-color-emoji}";
        shellHook = ''
          trap 'kill 0' EXIT
          mkdir -p pdf
          for template in templates/*.typ; do
            name=$(basename $template .typ)
            > $name.log
            typst watch \
              --ignore-system-fonts \
              --input lang=de \
              --input assets=${self}/assets \
              $template \
              pdf/$name.pdf \
              >> pdf/$name.log 2>&1 &
          done
        '';
      };
    }
  );

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # Using unstable channel to match the available typst glyphs more closely
    # to those from the cheat sheet: https://www.nerdfonts.com/cheat-sheet
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
