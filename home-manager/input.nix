{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      fcitx5-unikey
      fcitx5-material-color
    ];
  };

  home.file = {
    ".config/fcitx5/config".text = ''
    [Hotkey/TriggerKeys]
    0=Control+Shift+Shift_L
    '';

    ".config/fcitx5/profile".text = ''
    [Groups/0]
    # Group Name
    Name=Default
    # Layout
    Default Layout=us
    # Default Input Method
    DefaultIM=unikey

    [Groups/0/Items/0]
    # Name
    Name=keyboard-us
    # Layout
    Layout=

    [Groups/0/Items/1]
    # Name
    Name=unikey
    # Layout
    Layout=

    [GroupOrder]
    0=Default
    '';

    ".config/fcitx5/conf/unikey.conf".text = ''
    # Input Method
    InputMethod=Telex
    # Output Charset
    OutputCharset=Unicode
    # Enable spell check
    SpellCheck=False
    # Enable Macro
    Macro=True
    # Process W at word begin
    ProcessWAtBegin=True
    # Auto restore keys with invalid words
    AutoNonVnRestore=False
    # Use oà, _uý (instead of òa, úy)
    ModernStyle=False
    # Allow type with more freedom
    FreeMarking=True
    # Restore typing state from surrounding text
    SurroundingText=True
    # Allow to modify surrounding text (experimental)
    ModifySurroundingText=False
    # Underline the preedit text
    DisplayUnderline=True
    '';
  };
}
