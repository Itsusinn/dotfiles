{
  description = "NixOS system configuration flake";

  # 声明外部依赖
  inputs = {
    # NixOS 包管理器核心仓库
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    # Home Manager - 用户环境管理工具
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";  # 使用与系统相同版本的 nixpkgs
    };

    # sops-nix - 机密管理工具
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # 系统配置输出
  outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, ... }: {
    # NixOS 系统配置
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  # 系统架构
      modules = [
        # 基础系统配置
        ./configuration.nix

        # sops-nix 模块
        sops-nix.nixosModules.sops

        # Home Manager 配置
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ihsin = import ./home.nix;
            backupFileExtension = "backup";
            # 向 home.nix 传递 flake inputs
            # extraSpecialArgs = inputs;
          };
        }
      ];
    };
  };
}
