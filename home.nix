{ config, pkgs, ... }:

{
  home.username = "andrei";
  home.homeDirectory = "/home/andrei";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vscode
    discord
    prismlauncher
    # emacs
    # neovim
    vim
    git
    ripgrep
    fd
    p7zip
  ];
}
