# https://github.com/kirillfx/rp2040-project-template-nix/blob/6d8356ef31d5a845a652b0bc31c20faffd55f53f/flake.nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    flake-utils,
    naersk,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk {};
      in rec {
        # For `nix build` & `nix run`:
        defaultPackage = naersk'.buildPackage {
          src = ./.;
          CARGO_BUILD_TARGET = "thumbv6m-none-eabi";
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rustup
            rustc
            cargo
            clippy
            rust-analyzer
            flip-link
            probe-rs
            elf2uf2-rs
          ];
        };
      }
    );
}
