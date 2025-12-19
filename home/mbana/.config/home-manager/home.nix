{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mbana";
  home.homeDirectory = "/home/mbana";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (pkgs.writeShellScriptBin "ptyxis.sh" ''
      #!/usr/bin/env sh
      /usr/bin/ptyxis --new-window --standalone
    '')

    pkgs.curl
    pkgs.git
    pkgs.wget
    pkgs.tmux
    pkgs.gdb
    pkgs.valgrind
    pkgs.vim
    pkgs.neovim

    pkgs.coreutils
    pkgs.moreutils
    pkgs.tree

    pkgs.rclone
    pkgs.rsync


    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-history-substring-search

    pkgs.starship
    pkgs.atuin

    pkgs.fd
    pkgs.ripgrep

    pkgs.jq

    pkgs.go
    pkgs.nodejs
    # pkgs.rustup

    pkgs.htop
    pkgs.btop
    pkgs.glances

    pkgs.nmap
    pkgs.tcpdump
    pkgs.wireshark
    pkgs.socat
    pkgs.netcat
    pkgs.traceroute

    pkgs.screenfetch
    pkgs.neofetch

    pkgs.zip
    pkgs.unzip
    pkgs.p7zip
    pkgs.xz
    pkgs.lz4
    pkgs.zstd
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
  #  /etc/profiles/per-user/mbana/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # EDITOR = "code --wait --new-window"
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git ={
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Mohamed Bana";
        email = "mohamed.omar.bana@gmail.com";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        color = {
          ui = "true";
          advice = "true";
          status = "always";
        };
        core = {
          ignorecase = "false";
          hideDotFiles = "false";
          # editor = "code --wait --new-window";
        };
        ignores = [
          # Ignore these folders
          ".ignore"
          ".ignore/"
          ".tmp"
          ".tmp/"
        ];
        # Sign all commits using ssh key
        gpg.format = "ssh";
        commit.gpgsign = true;
      };
      commit = {
        verbose = true;
      };
      # Use SSH instead of HTTPS for GitHub and GitLab
      url = {
        "git@github.com:" = {
          insteadOf = [
            "https://github.com/"
          ];
        };
      };
      url = {
        "git@gitlab.com:" = {
          insteadOf = [
            "https://gitlab.com/"
          ];
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      copy = "xclip -selection clipboard";
      paste = "xclip -o -selection clipboard";
      ip = "ip --color";
      fd = "fd --follow --exclude /proc --exclude /sys --exclude $(go env GOPATH)";
      # rg = "rg --follow --glob '!{/proc,/sys,$(go env GOPATH),**/.git/*,**/*.rs}'";
      rg = "rg --follow --glob '!{/proc,/sys,$(go env GOPATH),.git,*.rs}'";
    };
    history = {
      append = true;
      expireDuplicatesFirst = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      saveNoDups = true;

      path = "${config.programs.zsh.dotDir}/.zsh_history";
      save = 1000000000;

      share = false;
      size = 1000000000;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Configuration written to ~/.config/starship.toml
    settings = {
      # "$schema" = "https://starship.rs/config-schema.json";

      #add_newline = true;

      #line_break = {
      #  disabled = true;
      #}

      localip = {
        ssh_only = false;
        format = "@[$localipv4](bold red) ";
        disabled = false;
      };

      username = {
        disabled = false;
        show_always = true;
      };

      hostname = {
        disabled = false;
        ssh_only = false;
      };

      directory = {
        truncate_to_repo = false;
        truncation_length = 0;
      };
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ]; # or --disable-ctrl-r
  };
}
