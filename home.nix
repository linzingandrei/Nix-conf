{ config, pkgs, ... }:

{
  home.username = "andrei";
  home.homeDirectory = "/home/andrei";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    vscode-fhs
    discord
    prismlauncher
    # emacs
    # neovim
    fd
    p7zip
    ntfs3g
    libreoffice-qt6-fresh
    usbutils
    obsidian
    poppler-utils
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.kde.okular.desktop";
      "image/png" = "org.kde.okular.desktop";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.8";
      background_blur = 5;
      extraConfig = ''
        tab_bar_style powerline
        cursor_trail 200
        cursor_trail_decay 0.1 0.4
        cursor_trail_start_threshold 2
      '';
    };
  };

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.path = "$HOME/.zsh_history";

    sessionVariables = {
      DOOM = "doom";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" ];
      theme = "flazz";
    };
  };
}
