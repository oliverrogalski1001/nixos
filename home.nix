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
    upscayl
    xfce.thunar
    ungoogled-chromium

    # command line stuff
    oh-my-zsh
    zsh-powerlevel10k
    zsh-fzf-history-search
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
    bat

    # coding
    go
    python39
    nodejs_22
    mysql80
    cargo

    # latex
    texlive.combined.scheme-full

    # wayland
    waybar
    dunst
    libnotify
    swww
    rofi-wayland
    pavucontrol
    playerctl
    blueman
    bluez
    nwg-look

    # screenshots
    grim
    slurp
    swappy
    wl-clipboard
    imagemagick

    # networking
    openconnect
    networkmanagerapplet

    # webcam
    v4l-utils

    # games
    extremetuxracer
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = toHomeFiles ./dotfiles;
  home.file =
        with pkgs; let
        listFilesRecursive = dir: acc: lib.flatten (lib.mapAttrsToList
          (k: v: if v == "regular" then ["${acc}${k}"] else listFilesRecursive dir "${acc}${k}/")
          (builtins.readDir "${dir}/${acc}"));

        toHomeFiles = dir:
          builtins.listToAttrs
            (map (x: { name = x; value = { source = "${dir}/${x}"; }; }) (listFilesRecursive dir ""));
      in toHomeFiles ./dotfiles;
  
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
      init.defaultBranch = "main";
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # zsh setup
  programs.zsh = {
    enable = true;
    enableCompletion = true;
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
      {
        name = "zsh-fzf-history-search";
        src = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    shellAliases = {
      lt="lsd --tree --depth 2";
      ls="lsd";
      lsa="lsd -a";
      ll="lsd -la";
      sd="cd ~ && cd $(fd -t d | fzf)";
      sv="source venv/bin/activate";
      cat="bat";
      hs="home-manager switch --flake ~/nixos && hyprctl reload";
      speaker="bluetoothctl connect 95:66:04:F6:8D:BC";
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
    FZF_DEFAULT_COMMAND = "fd";
  };

  # themes
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-gtk-theme;
      name = "Gruvbox-Dark-hdpi-B-MB";
    };
  };
  # gtk.cursorTheme.package = pkgs.bibata-cursors;
  # gtk.cursorTheme.name = "Bibata-Modern-Ice";
  
  # gtk.theme.package = pkgs.gruvbox-gtk-theme;
  # gtk.theme.name = "Gruvbox-Dark-hdpi-B-MB";

  # gtk.iconTheme.package = pkgs.gruvboxPlus;
  # gtk.iconTheme.name = "gruvboxPlus";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
