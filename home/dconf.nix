{ lib, ... }: with lib.hm.gvariant; {
  dconf.settings = {
    "system/locale" = {
      region = "zh_CN.UTF-8";
    };
  };
}