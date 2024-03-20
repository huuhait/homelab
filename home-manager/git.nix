let
  email = "huuhadz2k@gmail.com";
  name = "huuhait";
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
    };
    userEmail = email;
    userName = name;

    includes = [ { path = "~/.gitconfig.local"; } ];
  };
}
