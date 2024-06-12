{ config, pkgs, inputs, username, hostname, nixpkgs-ruby, ... }: {
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

  nixpkgs.overlays = [ nixpkgs-ruby.overlays.default ];

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

    rustup

    python311Packages.pip

    solana-cli

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
    pkgs."ruby-3.0.1"

    # Tools
    gnumake
    direnv
    gmp
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

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  system.stateVersion = "24.05";
}
