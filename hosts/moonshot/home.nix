{ pkgs, ... }:
let
  display1 = {
    name = "HDMI-2";
    fp = "00ffffffffffff0030aef26100000000171e010380462778eae5a5ae4f43ab260c5054a10800d100d1c0b30081c081809500a9c081004dd000a0f0703e8030203500b9882100001e000000fd00174c1ea03c000a202020202020000000fc004c454e20543332702d32300a20000000ff00564e413457484c470a2020202001cd020332f14e61605f101f051404131211030201830100006b030c001000303c2000200167d85dc401788003e20f0323097f07a36600a0f0701f8030203500b9882100001a565e00a0a0a0295030203500b9882100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000006e";
  };
  display2 = {
    name = "HDMI-0";
    fp = "00ffffffffffff0030aef26100000000171e010380462778eae5a5ae4f43ab260c5054a10800d100d1c0b30081c081809500a9c081004dd000a0f0703e8030203500b9882100001e000000fd00174c1ea03c000a202020202020000000fc004c454e20543332702d32300a20000000ff00564e4134574b33300a2020202001fa020332f14e61605f101f051404131211030201830100006b030c001000303c2000200167d85dc401788003e20f0323097f07a36600a0f0701f8030203500b9882100001a565e00a0a0a0295030203500b9882100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000006e";
  };
  fingerprint = {
    "${display1.name}" = "${display1.fp}";
    "${display2.name}" = "${display2.fp}";
  };
  base_profile = {
    inherit fingerprint;
    config = {
      "${display1.name}" = {
        enable = true;
        mode = "3840x2160";
        primary = true;
        position = "0x0";
        rate = "60.00";
        crtc = 1;
      };
      "${display2.name}" = {
        enable = true;
        mode = "3840x2160";
        position = "1920x320";
        rate = "60.00";
        crtc = 0;
      };
    };
  };
in
{
  programs.autorandr = {
    enable = true;
    profiles = {
      both = base_profile;
    };
  };
  xresources.properties = {
    "Xft.dpi" = 192;
  };
  xsession = {
    pointerCursor = {
      package = pkgs.apple-cursor;
      name = "macOSMonterey";
      size = 40;
    };
  };
  home.sessionVariables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SET_FACTOR = "0";
    QT_SCALE_FACTOR = "2";
    QT_FONT_DPI = "96";
  };
}
