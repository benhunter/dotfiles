{
  config,
  pkgs,
  lib,
  ...
}:
{

  programs.waybar = {
    enable = true;
    style = ''
      
    '';
  };

  # programs.waybar.settings = {
  #   mainBar = {
  #     layer = "top";
  #     position = "top";
  #     output = [
  #       "eDP-1"
  #       "HDMI-A-1"
  #     ];
      # modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
      # modules-center = [ "sway/window" "custom/hello-from-waybar" ];
      # modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

      # "sway/workspaces" = {
        # disable-scroll = true;
        # all-outputs = true;
      # };
      # "custom/hello-from-waybar" = {
      #   format = "hello {}";
      #   max-length = 40;
      #   interval = "once";
      #   exec = pkgs.writeShellScript "hello-from-waybar" ''
      #     echo "from within waybar"
      #   '';
      # };
    # };
  # }; # end programs.waybar.settings

}
