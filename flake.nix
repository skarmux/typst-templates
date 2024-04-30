{
  description = "Skarmux Typst Templates";

  # https://ertt.ca/nix/shell-scripts/
  # https://ryantm.github.io/nixpkgs/builders/trivial-builders/
  # https://ryantm.github.io/nixpkgs/stdenv/stdenv/

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
      source = pkgs.stdenv.mkDerivation {
        pname = "stytemp-source";
        version = "0.1.0";
        src = pkgs.lib.cleanSource ./.;
        buildPhase = ''
          mkdir -p $out/fonts
          mkdir -p $out/typst
          cp -r fonts/* $out/fonts
          cp -r typst/* $out/typst
        '';
      };
      sttemp = (pkgs.writeScriptBin "stytemp" (builtins.readFile ./compile.sh))
      .overrideAttrs(old: {
        buildCommand ="${old.buildCommand}\n patchShebangs $out";
      });
    in
    {
      packages.default = pkgs.symlinkJoin {
        name = "stytemp";
        paths = [
          sttemp
          source
          pkgs.typst
        ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/stytemp --prefix PATH : $out/bin
        '';
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [ typst git-crypt ];
      };
    }
  );
}
