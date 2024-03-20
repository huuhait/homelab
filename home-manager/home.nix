{ config, inputs, pkgs, username, ... }:
let
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./git.nix
    ./lf.nix
    ./neofetch.nix
    ./neovim.nix
    ./packages.nix
    ./sh.nix
    ./starship.nix
    ./input.nix
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  news.display = "show";

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  home = {
    inherit username homeDirectory;

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${homeDirectory}/.local/share/go";
      GOMODCACHE="${homeDirectory}/.cache/go/pkg/mod";
      GOBIN = "${homeDirectory}/.local/share/go/bin";
      PATH = "$PATH:$GOBIN";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
  services = {
    vscode-server = {
      enable = true;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
