{
  description = "NixOS system configuration flake";

  # 声明外部依赖
  inputs = {
    # NixOS 包管理器核心仓库
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    # Home Manager - 用户环境管理工具
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";  # 使用与系统相同版本的 nixpkgs
    };

    # Lanzaboote - 安全启动管理器
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";  # 减小系统闭包大小
    };
  };

  # 系统配置输出
  outputs = inputs@{ self, nixpkgs, home-manager, lanzaboote, ... }: {
    # NixOS 系统配置
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  # 系统架构
      
      modules = [
        # 基础系统配置
        ./configuration.nix

        # Home Manager 配置
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;      # 使用全局包
            useUserPackages = true;     # 使用用户包
            users.ihsin = import ./home.nix;  # 用户特定配置
            backupFileExtension = "backup";  # 备份文件扩展名
            # 向 home.nix 传递 flake inputs
            # extraSpecialArgs = inputs;
          };
        }

        # 安全启动模块
        lanzaboote.nixosModules.lanzaboote
      ];
    };
  };
}
