{
  description = "Haskell cimplot bindings";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hs-bindgen.url = "github:well-typed/hs-bindgen";
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      hs-bindgen,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ hs-bindgen.overlays.default ];
          };
          hpkgs = pkgs.haskellPackages;
          hlib = pkgs.haskell.lib.compose;
          imgui = pkgs.callPackage ./nix/imgui.nix { };
          cimgui = pkgs.callPackage ./nix/cimgui.nix { };
          cimplot = pkgs.callPackage ./nix/cimplot.nix { inherit cimgui; };
          hs-cimplot = hlib.generateBindings ./generate-bindings (
            hpkgs.callCabal2nix "hs-cimplot" ./. { inherit cimplot; }
          );
        in
        {
          packages = {
            inherit imgui cimgui cimplot;
            inherit hs-cimplot;
            inherit (pkgs) hs-bindgen-cli;
            default = hs-cimplot;
          };

          devShells = {
            default = hpkgs.shellFor {
              packages = _: [ hs-cimplot ];
              nativeBuildInputs = [
                # Haskell toolchain.
                hpkgs.cabal-install
                hpkgs.ghc
                hpkgs.haskell-language-server

                # `hs-bindgen` client.
                pkgs.hs-bindgen-cli

                # Connect `hs-bindgen` to the Clang toolchain and `libpcap`.
                pkgs.hsBindgenHook
              ];
            };
            boot = pkgs.mkShell {
              nativeBuildInputs = [
                # Haskell toolchain.
                hpkgs.cabal-install
                hpkgs.ghc
                hpkgs.haskell-language-server
              ];
            };
          };
        };
    };
}
