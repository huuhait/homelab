{ config, pkgs, inputs, username, hostname, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./locale.nix
  ];

  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # zsh
  programs.zsh.enable = true;

  # ld
  programs.nix-ld.enable = true;

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    v4l-utils
    git
    wget
    libsecret
    pciutils

    # Languages
    go
    gopls
    go-tools
    golangci-lint
    gotests
    gomodifytags
    delve

    fnm
    bun
    gcc

    # Tools
    gnumake
  ];

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # user
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    extraGroups = [
      "nixosvmtest"
      "networkmanager"
      "wheel"
      "libvirtd"
      "adbusers"
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;

  users.extraGroups.docker.members = [
    "${username}"
  ];

  # network
  networking = {
    hostName = hostname;
    networkmanager.enable = true;

    firewall = {
      enable = false;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = [
        username
      ];
    };
  };

  # bootloader
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 5;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
    };
  };

  system.stateVersion = "23.11";
}
