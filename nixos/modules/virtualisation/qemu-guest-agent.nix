{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.qemuGuest;
in {

  options.services.qemuGuest = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the qemu guest agent.";
      };
  };

  config = mkIf cfg.enable (
      mkMerge [
    {

      services.udev.extraRules = ''
        SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0", TAG+="systemd" ENV{SYSTEMD_WANTS}="qemu-guest-agent.service"
      '';

      systemd.services.qemu-guest-agent = {
        description = "Run the QEMU Guest Agent";
        serviceConfig = {
          ExecStart = "${pkgs.qemu.ga}/bin/qemu-ga";
          Restart = "always";
          RestartSec = 0;
        };
      };
    }
  ]
  );
}
