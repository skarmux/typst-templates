{
  description = "CVMake development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = pkgs.mkShell {
            TYPST_FONT_PATHS = "./fonts";
            buildInputs = with pkgs; [
              git-crypt
              taplo # A TOML toolkit written in Rust
              gum
              typst
              typst-lsp
              zathura
              nixfmt
            ];
          };
        }
      );
}
