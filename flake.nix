{
  description = "Skarmux Typst-Templates";

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};

      script = pkgs.writeShellScriptBin "generate" (builtins.readFile ./run.sh)
        .overrideAttrs(old: {
          buildCommand ="${old.buildCommand}\n patchShebangs $out";
        });
    in
    {
      packages.default = pkgs.symlinkJoin {
        name = "typst-templates";
        paths = [
          script
          pkgs.typst
          pkgs.gum
          pkgs.evince
          pkgs.jq
        ];
        THEME_PATH = "${inputs.catppuccin-base16}/base16";
        FONT_PATH = "${(pkgs.nerdfonts.override { fonts = [ "ProFont" ]; })}";
        SRC = "${self}";
        buildInputs = [
          pkgs.makeWrapper
        ];
        postBuild = ''
          wrapProgram $out/bin/typst-templates --prefix PATH : $out/bin
        '';
      };
      
      apps.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/typst-templates";
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.typst
          pkgs.gum
          pkgs.evince
          pkgs.jq
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
