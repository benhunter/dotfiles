{ config, pkgs, lib, ... }:

let 
  hyprland = import ./hyprland.nix { inherit pkgs; inherit lib; };
  nvChad = import ./nvchad.nix { inherit pkgs; };
  leetup = import ./leetup.nix { inherit pkgs; };
in
{
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  imports = [
    config/waybar.nix
  ];

  wayland.windowManager = hyprland;
  gtk.enable = true;
  # gtk.catppuccin.enable = true; # TODO had to disable after 23.11 was deprecated - 2024-07-10 project archived https://github.com/catppuccin/gtk/issues/262

  # catppuccin.enable = true; # TODO Modifies the default waybar, not sure why
  # catppuccin.starship.enable = true; # Example from catppuccin/nix docs
  # catppuccin.flavor = "mocha";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.sessionVariables.GTK_THEME = "Tokyonight-Dark-B"; # TODO
  home.sessionVariables.NIX_SHELL_PRESERVE_PROMPT = 1;

  # Place the nvchad configuration in the right directory
  home.file.".config/nvim" = {
    source = "${nvChad}/nvchad";
    recursive = true;  # copy files recursively
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 36;
    "Xft.dpi" = 120;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    bash
    wofi # wofi crashes on mouseover https://github.com/hyprwm/Hyprland/issues/3729

    # archives
    zip
    xz
    unzip
    # p7zip

    # utils
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    fastfetch
    moar
    # nnn # terminal file manager
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    # yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd
    bc

    # networking tools
    # mtr # A network diagnostic tool
    # iperf3
    dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    # nmap # A utility for network discovery and security auditing
    # ipcalc  # it is a calculator for the IPv4/v6 addresses

    kubectl

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    tmux
    obsidian
    # hugo # static site generator
    glow # markdown previewer in terminal

    signal-desktop
    bitwarden-desktop

    bottom # btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    powertop
    hyprlock

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # Dev
    gcc
    gnumake
    httpie
    python3
    just
    leetup
    go
    nodejs_22

    # Hardware related
    brightnessctl # backlight
    arandr

    # Security
    nmap
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Ben Hunter";
    userEmail = "code@benhunter.me";
    extraConfig = {
      credential = {helper="store";};
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.atuin.enable = true;
  programs.thefuck.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autocd = true;
    shellAliases = {
      k = "kubectl";
      gs = "git status";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      obsidian = "OBSIDIAN_USE_WAYLAND=1 obsidian --ozone-platform-hint=auto"; # Fix for resolution issue in Wayland. https://forum.obsidian.md/t/extremely-low-resolution-in-obsidian-1-4-x-on-linux-with-wayland/66441
      ls = "exa";
      l = "exa -la";
      ll = "l";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git"
                  "thefuck"
      ];
    };

    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      test -f "$HOME/projects/dotfiles/mac/.p10k.zsh" && source "$HOME/projects/dotfiles/mac/.p10k.zsh"
      eval $(thefuck --alias "f")
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 250000;
    plugins = [
      pkgs.tmuxPlugins.sensible
      # pkgs.tmuxPlugins.catppuccin
    ];
    extraConfig = ''
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # New pane gets current path
      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # 2024-04-13 Navigate panes with Vim keybinds
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # 2024-05-27 Use clipboard in Wayland
      set-option -g update-environment "DISPLAY WAYLAND_DISPLAY SSH_AUTH_SOCK"
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
      size = 10;
    };
    # theme = "Catppuccin-Mocha";
    settings = { background_opacity = "0.8"; };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = [
      pkgs.rust-analyzer
      pkgs.vimPlugins.copilot-lua
      ];
    # package = neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
  #   }))
  # ];

  programs.firefox = {
      enable = true;
      profiles.default = {
         # name = "Default";
         settings = {
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org"; # TODO not setting dark theme correctly!
         };
      };
   };

  # TODO hyprpaper config

  # starship - an customizable prompt for any shell
  programs.starship = {
    #enable = true;
    # custom settings
    #settings = {
      #add_newline = false;
      #aws.disabled = true;
      #gcloud.disabled = true;
      #line_break.disabled = true;
    #};
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd -L 2>/dev/null";
    changeDirWidgetCommand = "fd -L -t d 2>/dev/null";
    fileWidgetCommand = "fd -L -t f -t l 2>/dev/null";
  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';
}
