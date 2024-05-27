{ config, pkgs, lib, ... }:

  # NvChad from my GitHub
let 
  nvChad = import ./nvchad.nix { inherit pkgs; };
in
{
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # Place the nvchad configuration in the right directory
  home.file.".config/nvim" = {
    source = "${nvChad}/nvchad";
    recursive = true;  # copy files recursively
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

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };


  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    fastfetch
    # nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    # p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    # yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    # mtr # A network diagnostic tool
    # iperf3
    dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    # nmap # A utility for network discovery and security auditing
    # ipcalc  # it is a calculator for the IPv4/v6 addresses

    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
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

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    powertop

    # Dev
    gcc
    # TODO vscode-fhs
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Ben Hunter";
    userEmail = "code@benhunter.me";
  };

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

  programs.bash = {
    #enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      general = {
        gaps_in = 3;
        gaps_out = 5;
      };
      bind = [
        "$mod, Q, killactive"
        "$mod, Return, exec, kitty"
        "$mod, F, exec, firefox"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );

      misc = {
        disable_hyprland_logo = true;
      };
      exec-once = "waybar";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    shellAliases = {
      k = "kubectl";
      gs = "git status";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git"
                  "thefuck"
      ];
      custom = "$HOME/projects/dotfiles/mac/.p10k.zsh";
    };

    initExtra = ''
      eval $(thefuck --alias "f")
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 250000;
    plugins = [
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.catppuccin
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
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
    };
    theme = "Catppuccin-Mocha";
    settings = { background_opacity = "0.8"; };
  };

  programs.atuin = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vscode.enable = true;

  # TODO waybar config
  programs.waybar.enable = true;
  programs.thefuck.enable = true;

  # TODO hyprpaper config
}
