{ pkgs, config, ... }:
let
  hm = pkgs.writeShellScript "hm" ''
    ${../symlink.nu} -r
    home-manager switch --flake ~/Projects/dotfiles/. --impure
    ${../symlink.nu} -a
  '';
  vault = pkgs.writeShellScript "vault" ''
    cd ~/Vault
    git add .
    gc -m 'sync $(date '+%Y-%m-%d %H:%M')'
    git push
  '';
  shellAliases = {
    "db" = "distrobox";
    "arch" = "distrobox-enter Arch -- zsh";
    "fedora" = "distrobox-enter Fedora -- zsh";
    "eza" = "eza -l --sort type --no-permissions --no-user --no-time --header --icons --no-filesize --group-directories-first";
    "tree" = "eza --tree";
    "ll" = "eza";
    "éé" = "eza";
    "és" = "eza";
    "l" = "eza";
    "nvim" = "nv";
    ":q" = "exit";
    "q" = "exit";
    "gs" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
    "f" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
    "del" = "gio trash";
    "hm" = "${hm}";
    "vault" = "${vault}";
    "k" = "kubectl";
    "kaf" = "kubectl apply -f";
    "kdf" = "kubectl delete -f";
    "keti" = "kubectl exec -it";
    "kl" = "kubectl logs";
  };
in
{
  programs = {
    thefuck.enable = true;

    zsh = {
      inherit shellAliases;
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh
        export GITHUB_TOKEN="$(gh auth token)"
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        git config --file ~/.gitconfig.local url."https://$(gh auth token):x-oauth-basic@github.com/".insteadOf "https://github.com/"
        GOPRIVATE=github.com/zsmartex,github.com/safetrade-exchange
        eval "$(direnv hook zsh)"
      '';
    };

    bash = {
      inherit shellAliases;
      enable = true;
      initExtra = ''
        SHELL=${pkgs.bash}
        eval "$(direnv hook bash)"
      '';
    };

    nushell = {
      inherit shellAliases;
      enable = true;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "\"  \"";
        PROMPT_INDICATOR_VI_NORMAL = "\"∙ \"";
        PROMPT_COMMAND = ''""'';
        PROMPT_COMMAND_RIGHT = ''""'';
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
      };
      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";
          shell_integration = true;

          ls.clickable_links = true;
          rm.always_trash = true;

          table = {
            mode = "compact"; # compact thin rounded
            index_mode = "always"; # alway never auto
            header_on_separator = false;
          };

          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          menus = [({
            name =  "completion_menu";
            only_buffer_difference = false;
            marker = "? ";
            type = {
              layout = "columnar"; # list, description
              columns = 4;
              col_padding = 2;
            };
            style = {
              text = "magenta";
              selected_text = "blue_reverse";
              description_text = "yellow";
            };
          })];
        };
        completion = name: ''
          source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
        '';
        completions = names: builtins.foldl'
          (prev: str: "${prev}\n${str}") ""
          (map (name: completion name) names);
      in ''
        $env.config = ${conf};
        ${completions ["cargo" "git" "nix" "npm"]}
      '';
    };
  };
}
