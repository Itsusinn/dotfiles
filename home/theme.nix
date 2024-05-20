{ pkgs, inputs, config, catppuccin, ... }:
{
  catppuccin = {
    flavour = "macchiato";
    accent = "pink";
  };
  gtk.catppuccin = {
    enable = true;
    cursor.enable = true;
    size = "compact";
    tweaks = ["rimless"];
  };
  xdg.enable = true;
  gtk = {
    enable = true;
  };
  qt = {
    enable = true;
    platformTheme = "kde";
  };
}
