{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  packages,
  ...
}: let
  isMacOS = true;
in {
  imports = [
    outputs.homeManagerModules.zsh
    outputs.homeManagerModules.git
    outputs.homeManagerModules.helix
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.topgrade
    outputs.homeManagerModules.packages
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      # Wallahi, forgive me RMS...
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      # Let the system use fucked up programs
      allowBroken = true;
    };
  };

  # This is required information for home-manager to do its job
  home = {
    stateVersion = "23.11";
    username = "sakhib";
    homeDirectory = "/Users/sakhib";

    # Tell it to map everything in the `config` directory in this
    # repository to the `.config` in my home-manager directory
    file.".config" = {
      source = ../config;
      recursive = true;
    };
  };

  # Install macOS related package base
  packages.isMacOS = isMacOS;

  # Use MacOS configured git configs
  git.isMacOS = isMacOS;

  # This is to ensure programs are using ~/.config rather than
  # /Users/sakhib/Library/whatever
  xdg.enable = true;

  # Let's enable home-manager
  programs.home-manager.enable = true;
}
