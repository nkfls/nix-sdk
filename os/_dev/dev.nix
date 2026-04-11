input@{ config, inputs, lib, pkgs, developer, machine, ... }:
let
  keymap = {
    prefix = "SUPER";
    nav = "SUPER";
    move = "SHIFT_SUPER";
    resize = "CTRL_SHIFT_SUPER";
    slide = "ALT_SUPER";
    teleport = "SHIFT_ALT_SUPER";
  };
in
{
  home = {
    stateVersion = "25.11";
    username = developer.name;
    homeDirectory = "/home/${developer.name}";

    packages = with pkgs; [
      wget
      curl
      zip
      unzip
      fd
      xdg-utils
      hyprpaper
      wl-clipboard
      grimblast
      playerctl
      pavucontrol
      wev
      nerd-fonts.jetbrains-mono
    ];

    file.".config/nvim" = {
      source = ./config;
      recursive = true;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    font = {
      package = pkgs.roboto;
      name = "Roboto";
      size = 10;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 1000000;
      shellAliases = {
        bluetooth = "bluetui";
        audio = "pulsemixer";
        k = "kubectl";
        kga = "kubectl get all";
        kgaa = "kubectl get all --all-namespaces";
        kgn = "kubectl get nodes";
        kgp = "kubectl get pods";
        kgpa = "kubectl get pods --all-namespaces";
        kdp = "kubectl describe pod";
        kgd = "kubectl get deployments";
        kgs = "kubectl get services";
        d = "docker";
        dgc = "docker ps";
        dgca = "docker ps -a";
      };
      loginExtra = ''
        if [ -z "$TMUX" ]; then
          tmux attach || tmux new-session -s main
        fi
      '';
    };

    git = {
      enable = true;
      userName = developer.name;
      userEmail = "${developer.name}@nkfls.dev";
      extraConfig.init.defaultBranch = "main";
    };

    ssh = {
      enable = true;
      serverAliveInterval = 30;
      serverAliveCountMax = 5;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.age.secrets."ssh/nkfls-ed25519-primary".path;
        };
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        warn_timeout = 0;
        hide_env_diff = true;
      };
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      prefix = "F12";
      baseIndex = 1;
      historyLimit = 100000;
      escapeTime = 0;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '0'
          '';
        }
        { plugin = tmux-fzf; }
        { plugin = yank; }
      ];
      extraConfig = ''
        set -g mouse on
        set-option -g allow-rename "off"
        set-option -g automatic-rename "off"
        set-option -g display-time 1000
        set-option -g status-interval 1
        set-option -g renumber-windows "on"
        unbind s
        bind-key F12 choose-tree -Zs
        setw -g mode-keys vi
        bind-key v copy-mode
        unbind-key [
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi Escape if-shell -F "#{?selection_present,1,0}" "send-keys -X clear-selection" "send-keys -X cancel"
        bind-key -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
        unbind -n M-Space
        unbind-key -T prefix Space
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n 'M-Up' if-shell "$is_vim" 'send-keys M-Up' { if -F '#{pane_at_top}' \'\' 'select-pane -U' }
        bind-key -n 'M-Right' if-shell "$is_vim" 'send-keys M-Right' { if -F '#{pane_at_right}' \'\' 'select-pane -R' }
        bind-key -n 'M-Down' if-shell "$is_vim" 'send-keys M-Down' { if -F '#{pane_at_bottom}' \'\' 'select-pane -D' }
        bind-key -n 'M-Left' if-shell "$is_vim" 'send-keys M-Left' { if -F '#{pane_at_left}' \'\' 'select-pane -L' }
      '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    lazygit = {
      enable = true;
      settings = {
        disableStartupPopups = true;
        confirmOnQuit = true;
        promptToReturnFromSubprocess = false;
        gui = {
          showPanelJump = false;
          showBottomLine = false;
          showRandomTip = false;
          nerdFontsVersion = "3";
          skipStashWarning = true;
          skipDiscardChangeWarning = true;
          skipRewordInEditorWarning = true;
        };
        refresher.refreshInterval = 1;
        keybinding.universal = {
          quit = "q";
          quit-alt1 = "";
          quitWithoutChangingDirectory = "";
          undo = "u";
          redo = "U";
        };
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;
    bat.enable = true;
    btop.enable = true;
    htop.enable = true;
    jq.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        nix_shell = {
          format = "via [$symbol]($style)";
          symbol = "󱄅 ";
        };
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = with pkgs; {
      "exec-once" = [
        "${hyprpaper}/bin/hyprpaper &"
        "${alacritty}/bin/alacritty --title \"MAIN_TERMINAL_1\" --command tmux attach &"
      ];

      general = {
        layout = "master";
        border_size = 0;
        "col.inactive_border" = "0xff3d59a1 0xff394b70 45deg";
        "col.active_border" = "0xffbb9af7 0xff9d7cd8 45deg";
        gaps_in = 5;
        gaps_out = 5;
        resize_on_border = true;
        no_focus_fallback = true;
      };

      master = {
        orientation = "center";
        new_on_top = false;
      };

      input = {
        repeat_delay = "200";
        repeat_rate = "65";
        follow_mouse = 2;
        mouse_refocus = false;
      };

      decoration = {
        rounding = 7;
        active_opacity = 1.00;
        inactive_opacity = 0.95;
        fullscreen_opacity = 1.00;
        blur.popups = true;
      };

      bezier = [
        "easeOutQuint,0.22,1,0.36,1"
        "easeInOutQuint,0.83,0,0.17,1"
      ];

      animation = [
        "workspaces,1,2,easeInOutQuint,slide"
        "windows,1,2,easeOutQuint,popin"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 1;
      };

      bind = with keymap; [
        "${prefix},q,killactive"
        "${prefix},return,exec,${alacritty}/bin/alacritty"
        "${prefix},s,exec,${grimblast}/bin/grimblast copy area"
        "ALT_${prefix},s,exec,${grimblast}/bin/grimblast copy screen"
        "${prefix},f,togglefloating"
        "${prefix},t,pin"
        "${prefix},c,centerwindow"
        "${prefix},p,togglespecialworkspace,p"

        "${nav},up,movefocus,u"
        "${nav},right,movefocus,r"
        "${nav},down,movefocus,d"
        "${nav},left,movefocus,l"

        "${move},up,movewindow,u"
        "${move},right,movewindow,r"
        "${move},down,movewindow,d"
        "${move},left,movewindow,l"

        "${resize},f,fullscreen,0"

        "${slide},right,workspace,e+1"
        "${slide},left,workspace,e-1"
        "${slide},mouse_up,workspace,e+1"
        "${slide},mouse_down,workspace,e-1"

        "${teleport},right,movetoworkspacesilent,e+1"
        "${teleport},left,movetoworkspacesilent,e-1"
        "${teleport},p,movetoworkspacesilent,special:p"

        ",XF86AudioPlay,exec,${playerctl}/bin/playerctl play-pause"
        ",XF86AudioNext,exec,${playerctl}/bin/playerctl next"
        ",XF86AudioPrev,exec,${playerctl}/bin/playerctl previous"
      ];

      binde = with keymap; [
        "${resize},up,resizeactive,0 -20"
        "${resize},right,resizeactive,20 0"
        "${resize},down,resizeactive,0 20"
        "${resize},left,resizeactive,-20 0"
      ];

      bindm = with keymap; [
        "${move},mouse:272,movewindow"
        "${resize},mouse:272,resizewindow"
      ];
    };
  };
}
