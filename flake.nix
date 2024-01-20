{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    configuration-empty-nixos = {pkgs, ...}: {
      boot.loader.grub.devices = ["/nonexistent"];
      fileSystems."/" = {
        device = "none";
        fsType = "tmpfs";
        options = ["size=10G" "mode=755"];
      };
      system.stateVersion = "23.11";
    };
    configuration-hydra-service = {...}: {
      # services.hydra.enable = true;
      services.hydra.hydraURL = "http://nonexistent/";
      services.hydra.notificationSender = "hydra@localhost";
    };
  in {
    nixosConfigurations.test-system = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        configuration-empty-nixos
        configuration-hydra-service
      ];
    };
  };
}
