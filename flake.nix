{
  description = "musicomp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      flake.nixosModules = let
        musicomp = import ./nixos/musicomp self;
      in {
        inherit musicomp;
        default = musicomp;
      };

      perSystem = {
        pkgs,
        inputs',
        lib,
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            pkgs.python3
            pkgs.python3Packages.hatchling
          ];
        };

        packages = let
          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./packages;
          };
        in packages // {
          default = packages.musicomp;
        };
      };
    };
}
