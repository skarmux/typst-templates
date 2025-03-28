{
  description = "Skarmux Typst-Templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
      source = pkgs.stdenv.mkDerivation {
        pname = "stt-source";
        version = "0.1.0";
        src = pkgs.lib.cleanSource ./.;
        buildPhase = ''
          mkdir -p $out/bin/typst && cp -r typst/* $out/bin/typst
          mkdir -p $out/bin/fonts && cp -r fonts/* $out/bin/fonts
          mkdir -p $out/bin/templates && cp -r templates/* $out/bin/templates
        '';
      };
      stt = pkgs.writeScriptBin "stt" /* bash */ ''
        ROOT=$(dirname $(realpath "$0") )

        SELECT=$(${pkgs.gum}/bin/gum choose \
          "Meeting Protocol" \
          "Curriculum Vitae" \
          "Application Letter" \
          "Motivational Letter" \
        );

        case $SELECT in
          "Meeting Protocol")
            TOML="meeting_protocol.toml"
            ;;
          "Curriculum Vitae")
            TOML="curriculum_vitae.toml"
            ;;
          "Application Letter")
            TOML="application_letter.toml"
            ;;
          "Motivational Letter")
            TOML="motivational_letter.toml"
            ;;
        esac

        if [ ! -f $TOML ]; then
          cp $ROOT/templates/$TOML ./$TOML
          chmod +w $TOML
        fi

        $EDITOR $TOML

        # Extract corresponding typst document from first line comment
        TYP=$ROOT/typst/$(sed -n '1s/# //p' $TOML)

        TMP_TYP=$(mktemp)
        trap "rm $TMP_TYP" EXIT

        echo '#let data = toml("'$(realpath $TOML)'")' > $TMP_TYP

        # Omit first line and write typst code into TMP_TYP
        # Replace relative with absolute paths
        sed -e '1d' \
            -e 's:"\./:"'$ROOT'/typst/:' \
            $TYP >> $TMP_TYP

        typst compile --root / --font-path $ROOT/fonts $TMP_TYP $(basename $TOML .toml).pdf
      '';
    in
    {
      packages.default = pkgs.symlinkJoin {
        name = "stt";
        paths = [
          stt
          source
          pkgs.typst
          pkgs.nerd-fonts.profont
        ];
        buildInputs = with pkgs; [
          makeWrapper
        ];
        postBuild = ''
          wrapProgram $out/bin/stt --prefix PATH : $out/bin
        '';
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [ typst typst-lsp bash-language-server ];
      };
    }
  );
}
