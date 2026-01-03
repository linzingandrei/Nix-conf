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
    vim
    git
    ripgrep
    fd
    p7zip
    ntfs3g
    libreoffice-qt6-fresh
    usbutils
    obsidian
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.kde.okular.desktop";
      "image/png" = "org.kde.okular.desktop";
    };
  };
}
