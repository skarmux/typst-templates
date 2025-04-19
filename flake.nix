{
  description = "Skarmux Typst-Templates";

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Needed for microsoft true type fonts
      };

      generate = pkgs.writeShellScriptBin "generate-pdf" ''
        #!/usr/bin/env bash
        set -euo pipefail

        # typst compile --input key=value
        # nix run . -- [FILE]
        # FILE -- <name>(.<lang>).typ
        #         lang defaults to `en` if not present
        # FLAVOR -- Catppuccin Flavor: frappe | latte | mocha | macchiato
        # ACCENT -- Catppuccin (Base16) Color: red | blue | peach | green | yellow | etc.
        # ASSETS -- Defaults in current directory ~/.local/share/typst-templates/assets

        FILE=$1

        # NOTE: The typst compiler does follow symlinks, therefore all
        #       .typ files need to be copied to the build location
        #       Same goes for .toml files. But .yaml is fine though!
        # LANGUAGE=$(${pkgs.gum}/bin/gum choose "English" "Deutsch")
        LANGUAGE="de"
        
        # if [[ $LANGUAGE == "English" ]]; then
        #   TEMPLATE=$(${pkgs.gum}/bin/gum choose \
        #     "Curriculum Vitae" \
        #     "Meeting Protocol" \
        #     "Application Letter" \
        #     "Motivational Letter" \
        #     )
        # else
        #   TEMPLATE=$(${pkgs.gum}/bin/gum choose \
        #     "CV / Lebenslauf" \
        #     "Gesprächsprotokoll" \
        #     "Bewerbungsanschreiben" \
        #     "Motivationsschreiben" \
        #     "FBA / Fachbereichsarbeit" \
        #     )
        # fi
        TEMPLATE="cv"

        # create temporary directory that serves as root for the typst compiler
        TYPST_ROOT=$(mktemp -d)
        trap "rm -rf $TYPST_ROOT" EXIT
        cp ${self}/templates/$TEMPLATE.typ "$TYPST_ROOT/$TEMPLATE.typ"
        cp -rv --no-preserve=all ${self}/templates/modules "$TYPST_ROOT/modules"
        ln -s ${self}/templates/assets "$TYPST_ROOT/assets"

        # move the file over into the working directory
        mkdir -v "$TYPST_ROOT/data"
        cp -v $FILE "$TYPST_ROOT/data/$TEMPLATE.toml"
        
        FILENAME=$(basename $FILE .toml)
        if [[ $LANGUAGE == "en" ]]; then
          PDF="$FILENAME.pdf"
        else
          PDF="$FILENAME.$LANGUAGE.pdf"
        fi

        > "$FILENAME.log"

        ${pkgs.typst}/bin/typst watch \
          --input flavor=frappe \
          --input accent=blue \
          --input lang=$LANGUAGE \
          --input label=true \
          --font-path "${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })}:${pkgs.corefonts}" \
          --ignore-system-fonts \
          --open "${pkgs.evince}/bin/evince" \
          "$TYPST_ROOT/$TEMPLATE.typ" \
          $PDF \
          >> "$FILENAME.log" 2>&1 &
        WATCH_PID=$!

        $EDITOR "$TYPST_ROOT/data/$TEMPLATE.toml"
        # FIXME When the session crashes, changes won't make it back
        # to the original file and will be lost. Really lost!
        cp -f "$TYPST_ROOT/data/$TEMPLATE.toml" $FILE

        # let typst watch churn a little longer for the final changes
        # made to the toml. `:wq` is too quick for an exit <3
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
          typst-lsp
          yaml-language-server
          taplo
          nixd
          evince
          (nerdfonts.override { fonts = [ "ProFont" ]; })
        ];
        allowUnfree = true;
        TYPST_FONT_PATHS = "${pkgs.corefonts}:${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })}";
        shellHook = ''
          trap 'kill 0' EXIT
          mkdir -p pdf
          for template in templates/*.typ; do
            name=$(basename $template .typ)
            > $name.log
            # TODO Make sure TYPST_ROOT is where flake.nix is
            # even when calling `nix develop` from subdir
            typst watch \
              --ignore-system-fonts \
              --input lang=de \
              --open evince \
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };
}
