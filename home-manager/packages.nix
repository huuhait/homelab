{ pkgs, config, ... }:
{
  xdg.desktopEntries = {
    "lf" = {
      name = "lf";
      noDisplay = true;
    };
  };

  home.packages = with pkgs; with gnome; [
    # tools
    bat
    eza
    fd
    ripgrep
    fzf
    socat
    jq
    acpi
    inotify-tools
    libnotify
    killall
    zip
    unzip
    glib
    htop
    btop
    tmate
    openssh
    gh
    grim
    remmina
    electron
    appimagekit
    virtualenv
    kubectl
    kustomize
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
    ansible
    terraform
    vault
    consul
    postgresql
    corepack
    obsidian
    glibc
    pkgs.nodePackages."eas-cli"
  ];
}
