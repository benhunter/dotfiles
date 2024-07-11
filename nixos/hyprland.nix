# Configure Hyprland with HomeManager by setting:
# wayland.windowManager.hyprland

{ pkgs, lib }:

let
  hyprlandConfig = {
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

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod SHIFT, left, resizeactive, -10 0"
        "$mod SHIFT, down, resizeactive, 0 10"
        "$mod SHIFT, up, resizeactive, 0 -10"
        "$mod SHIFT, right, resizeactive, 10 0"

        ", Print, exec, grimblast copy area"
        "$mod, D, exec, wofi --show run --normal-window"
      ] ++ (
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
        ) 10)
      );
      misc = {
        disable_hyprland_logo = true;
      };
      exec-once = "waybar";
      # env = "GTK_THEME,Orchis-Dark-Compact"; # TODO
     # env = "GTK_THEME,Tokyonight-Dark-B";
    };
  }; # end hyprlandConfig

  hyprlandThemeDracula = {
  # https://github.com/dracula/hyprland/blob/main/hyprland.conf
    settings = {
      general = {
        "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
        "col.inactive_border" = "rgba(44475aaa)";
        "col.nogroup_border" = "rgba(282a36dd)";
        "col.nogroup_border_active" = "rgb(bd93f9) rgb(44475a) 90deg";
        no_border_on_floating = false;
        border_size = 2;
      };
      decoration = {
        "col.shadow" = "rgba(1E202966)";
      };
      group = {
        groupbar = {
          "col.active" = "rgb(bd93f9) rgb(44475a) 90deg";
          "col.inactive" = "rgba(282a36dd)";
        };
      };
    };
  }; # end hyprlandThemeDracula

in
{
  hyprland = lib.recursiveUpdate hyprlandConfig hyprlandThemeDracula;
}
