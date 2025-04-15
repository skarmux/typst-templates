{
  description = "Skarmux Typst-Templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};

      generate = pkgs.writeShellScriptBin "generate-pdf" ''
        set -euo pipefail

        SELECT=$1
        ROOT=${self}

        TOML="$ROOT/templates/$SELECT.toml"
        TYP="$ROOT/typst/$SELECT.typ"

        # Give the user an editable document
        USER_TOML=$(basename $TOML)
        if [ ! -f $USER_TOML ]; then
          cp $TOML $USER_TOML
          chmod +w $USER_TOML
        fi
        $EDITOR $USER_TOML

        # Temporary Typ with absolute path to USER_TOML
        TMP_TYP=$(mktemp)
        trap "rm $TMP_TYP" EXIT
        echo '#let data = toml("'$(realpath $USER_TOML)'")' > $TMP_TYP

        # Omit first line and write typst code into TMP_TYP
        # Replace relative with absolute paths
        sed -e '1d' \
            -e 's:"\./:"'$ROOT'/typst/:' \
            $TYP >> $TMP_TYP

        ${pkgs.typst}/bin/typst compile \
          --root / \
          --font-path ${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })} \
          $TMP_TYP \
          $(basename $TOML .toml).pdf
      '';

      meet = pkgs.writeShellScriptBin "gen-meet" ''
        ${generate}/bin/generate-pdf meeting_protocol
      '';

      cv = pkgs.writeShellScriptBin "gen-cv" ''
        ${generate}/bin/generate-pdf curriculum_vitae
      '';

      application = pkgs.writeShellScriptBin "gen-application" ''
        ${generate}/bin/generate-pdf application_letter
      '';

      motivation = pkgs.writeShellScriptBin "gen-motivation" ''
        ${generate}/bin/generate-pdf motivational_letter
      '';
    in
    {
      apps = {
        meet = { type = "app"; program = "${meet}/bin/gen-meet"; };
        cv = { type = "app"; program = "${cv}/bin/gen-cv"; };
        application = { type = "app"; program = "${application}/bin/gen-application"; };
        motivation = { type = "app"; program = "${motivation}/bin/gen-motivation"; };
      };

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
}
