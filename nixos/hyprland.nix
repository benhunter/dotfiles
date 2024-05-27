{ pkgs, lib }:

#wayland.windowManager.hyprland = let 
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

        ", Print, exec, grimblast copy area"
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
  # wayland.windowManager.hyprland = lib.recursiveUpdate hyprlandConfig hyprlandThemeDracula;
  hyprland = lib.recursiveUpdate hyprlandConfig hyprlandThemeDracula;
  # hyprlandConfig;
}
