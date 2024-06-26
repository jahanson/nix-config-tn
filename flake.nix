{
  description = "My NixOS homelab";

  inputs = {
    # Nixpkgs and unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # impermanence
    # https://github.com/nix-community/impermanence
    impermanence.url = "github:nix-community/impermanence";

    # nur
    nur.url = "github:nix-community/NUR";

    # nix-community hardware quirks
    # https://github.com/nix-community
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # home-manager - unstable
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix - secrets with mozilla sops
    # https://github.com/Mic92/sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode community extensions
    # https://github.com/nix-community/nix-vscode-extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index database
    # https://github.com/nix-community/nix-index-database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-inspect - inspect nix derivations usingn a TUI interface
    # https://github.com/bluskript/nix-inspect
    nix-inspect = {
      url = "github:bluskript/nix-inspect";
    };
  };

  outputs =
    { self
    , nixpkgs
    , sops-nix
    , home-manager
    , nix-vscode-extensions
    , impermanence
    , ...
    } @ inputs:

    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    rec {
      # Use nixpkgs-fmt for 'nix fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

      # setup devshells against shell.nix
      # devShells = forAllSystems (pkgs: import ./shell.nix { inherit pkgs; });

      # extend lib with my custom functions
      lib = nixpkgs.lib.extend (
        final: prev: {
          inherit inputs;
          myLib = import ./nixos/lib { inherit inputs; lib = final; };
        }
      );

      nixosConfigurations =
        let
          inherit inputs outputs;
          # Import overlays for building nixosconfig with them.
          overlays = import ./nixos/overlays { inherit inputs; };
          # generate a base nixos configuration with the
          # specified overlays, hardware modules, and any extraModules applied
          mkNixosConfig =
            { hostname
            , system ? "x86_64-linux"
            , nixpkgs ? inputs.nixpkgs
            , hardwareModules ? [ ]
              # basemodules is the base of the entire machine building
              # here we import all the modules and setup home-manager
            , baseModules ? [
                sops-nix.nixosModules.sops
                home-manager.nixosModules.home-manager
                impermanence.nixosModules.impermanence
                ./nixos/profiles/global.nix # all machines get a global profile
                ./nixos/modules/nixos # all machines get nixos modules
                ./nixos/hosts/${hostname}   # load this host's config folder for machine-specific config
                {
                  home-manager = {
                    useUserPackages = true;
                    useGlobalPkgs = true;
                    extraSpecialArgs = {
                      inherit inputs hostname system;
                    };
                  };
                }
              ]
            , profileModules ? [ ]
            }:
            nixpkgs.lib.nixosSystem {
              inherit system lib;
              modules = baseModules ++ hardwareModules ++ profileModules;
              specialArgs = { inherit self inputs nixpkgs; };
              # Add our overlays
              pkgs = import nixpkgs {
                inherit system;
                overlays = builtins.attrValues overlays;
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = _: true;
                };
              };
            };
        in
        {
          "durincore" = mkNixosConfig {
            # T470 Thinkpad
            # Nix dev laptop
            hostname = "durincore";
            system = "x86_64-linux";
            hardwareModules = [
              ./nixos/profiles/hw-thinkpad-t470.nix
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
            ];
            profileModules = [
              ./nixos/profiles/role-workstation.nix
              ./nixos/profiles/role-dev.nix
              { home-manager.users.jahanson = ./nixos/home/jahanson/workstation.nix; }
            ];
          };
          "varda" = mkNixosConfig {
            # Arm64 cax21 @ Hetzner
            # forgejo server
            hostname = "varda";
            system = "aarch64-linux";
            hardwareModules = [
              ./nixos/profiles/hw-hetzner-cax.nix
            ];
            profileModules = [
              ./nixos/profiles/role-server.nix
              { home-manager.users.jahanson = ./nixos/home/jahanson/server.nix; }
            ];
          };
        };

      # Convenience output that aggregates the outputs for home, nixos.
      # Also used in ci to build targets generally.
      top =
        let
          nixtop = nixpkgs.lib.genAttrs
            (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
        in
        nixtop;
    };
}
