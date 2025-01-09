{
  description = "Ben Hunter's NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, rust-overlay, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { # nixos is hostname
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ben = {
            imports = [
              ./home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          };
          # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
        }

        catppuccin.nixosModules.catppuccin

        # ({ pkgs, ... }: let
        #   # Ensure the rust-overlay is applied
        #   pkgsWithRust = pkgs // {
        #     # overlays = [ rust-overlay.overlays.default ];
        #     overlays = rust-overlay.overlays;
        #   };
        #
        #   # Select the latest nightly toolchain
        #   # latestNightly = pkgsWithRust.rust-bin.selectLatestNightly;
        #   latestNightly = pkgsWithRust.rustChannels.nightly.rust-bin.selectLatestNightly;
        # in {
        #   environment.systemPackages = [
        #     latestNightly.default
        #   ];
        # })

        ({ pkgs, ... }: {
          nixpkgs.overlays = [ rust-overlay.overlays.default ];

          # These two work:
          # environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ]; # Works, 1.83
          # environment.systemPackages = [ pkgs.rust-bin.nightly."2025-01-05".default ]; # Works

          # Does not work:
          environment.systemPackages = [ pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default) ]; # Does not work. `toolchain.default` or `toolchain.minimal`
        })
      ];
    };
  };
}
