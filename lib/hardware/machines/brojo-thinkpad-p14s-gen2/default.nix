{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen2
  ];

  hardware = {
    enableAllFirmware = true;

    # NVIDIA Quadro T500 (Turing).
    # The upstream nixos-hardware module already imports common/gpu/nvidia/prime.nix
    # and common/gpu/nvidia/turing, which set videoDrivers = [ "modesetting" ] and
    # default prime.offload.enable = true. We do NOT override videoDrivers here.
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;       # nvidia-suspend/resume services preserve VRAM across S3.
        finegrained = true;  # PCIe runtime D3cold when no offloaded client is using the dGPU.
      };
      open = false;          # T500/Turing: proprietary kept for stability.
      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true; # Provides the `nvidia-offload` wrapper.
        };
        # PCI bus IDs from upstream + lspci confirmation.
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true; # Steam/Wine.
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Intel video acceleration for Steam (iGPU path).
  programs.steam.extraPackages = with pkgs; [
    intel-media-driver
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandlePowerKey = "suspend";
  };

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: forcing NVIDIA as the X server driver.
  #   services.xserver.videoDrivers = [ "nvidia" ];
  # Removed because the upstream nixos-hardware p14s-gen2 module sets
  # `[ "modesetting" ]` on purpose — PRIME offload expects Intel as the primary
  # display driver and the dGPU as an opt-in render target. Forcing nvidia here
  # contradicted prime.offload.enable = true and rendered the offload setup moot.
  #
  # Tried: globally exporting PRIME render-offload env vars in the session.
  #   environment.sessionVariables = {
  #     __NV_PRIME_RENDER_OFFLOAD = "1";
  #     __VK_LAYER_NV_optimus = "NVIDIA_only";
  #     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   };
  # Removed because these vars are designed to be set per-process by the
  # `nvidia-offload` wrapper (provided by enableOffloadCmd). Exporting them
  # globally pinned every GL/Vulkan client (compositor included) onto the dGPU,
  # which (a) kept the T500 in runtime state `active` continuously, defeating
  # finegrained PM, and (b) made S3 resume slow because nvidia-resume.service had
  # to restore 4 GiB of VRAM and re-establish a context for every running app.
  # Verified live: `nvidia-smi pmon` showed plasmashell/firefox/ghostty/etc.
  # attached to GPU 0, and /sys/.../power/runtime_status read `active` at idle.
  #
  # Current shape: rely on upstream defaults; the dGPU sits in D3cold and is
  # only woken by `nvidia-offload <cmd>` for apps that actually want it
  # (e.g. games, Blender, OBS NVENC).
  #
  # BIOS note: per the upstream README, suspend-to-RAM requires Config → Power →
  # Sleep State = "Linux S3" in EFI setup. `cat /sys/power/mem_sleep` should
  # report `s2idle [deep]` with `deep` selected.
  #
  # Tried: HandleLidSwtich = "suspend-then-hibernate" (typo).
  # systemd-logind silently ignored the misspelled key, so lid-close fell back
  # to the system default (suspend). Fixed to HandleLidSwitch.
}
