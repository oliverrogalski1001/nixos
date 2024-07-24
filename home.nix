{ config, pkgs, ... }:

{
  home.username = "oliver";
  home.homeDirectory = "/home/oliver";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # spyware enable
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  # fonts
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # applications
    bitwarden-cli
    mysql-workbench
    spotify
    vesktop
    zathura
    mpv

    # command line stuff
    oh-my-zsh
    zsh-powerlevel10k
    nerdfonts
    kitty
    kitty-themes
    lazygit
    ripgrep
    fd
    gcc
    unzip
    ani-cli
    xclip
    neofetch
    cowsay
    btop
    tailscale
    lshw
    rofi-power-menu
    killall
    nixos-generators
    lsd

    # coding
    go
    python39
    nodejs_22
    mysql80
    cargo

    # hyprland
    waybar
    dunst
    libnotify
    swww
    rofi-wayland
    pavucontrol
    playerctl
    blueman
    bluez

    # screenshots
    grim
    slurp
    swappy
    wl-clipboard
    imagemagick

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".p10k.zsh".source = dotfiles/p10k.zsh;
    # ".screenrc".source = ../../p10k.zsh;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".fdignore".text = ''
      /go
    '';
  };
  
  # git setup
  programs.git = {
    enable = true;
    userEmail = "oliverrogalski1001@gmail.com";
    userName = "Oliver Rogalski";
    lfs.enable = true;
    aliases = {
      st = "status";
      cm = "commit -m";
    };
    extraConfig = {
      push = { autoSetupRemote = true; };
    };
  };
  
  # vscode setup
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-python.python
      ms-toolsai.jupyter
      jdinhlife.gruvbox
    ];
  };

  # zsh setup
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source ~/.p10k.zsh
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    shellAliases = {
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/oliver/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # themes
  gtk.enable = true;
  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";
  
  # gtk.theme.package = pkgs.gruvbox-gtk-theme;
  # gtk.theme.name = "Gruvbox-Dark-hdpi-B-MB";

  # gtk.iconTheme.package = pkgs.gruvboxPlus;
  # gtk.iconTheme.name = "gruvboxPlus";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
