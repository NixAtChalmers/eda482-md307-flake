{
  description = "Development flake for EDA482 Machine oriented programming course";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    inherit (pkgs) lib stdenv;

    mdx07-binaries = pkgs.callPackage ./packages/mdx07-binaries.nix {};
    riscv32-gcc = pkgs.callPackage ./packages/riscv32-gcc.nix {};
  in {
    packages.${system} = {
      inherit mdx07-binaries riscv32-gcc;
    };

    nixosModules.default = {
      environment.systemPackages = with pkgs; [
        gcc-arm-embedded
        gnumake
        stdenv.cc.cc.lib
        openocd
        mdx07-binaries
        riscv32-gcc
      ];
    };

    homeModules.default = {
      programs.vscode = {
        enable = true;

        # Override vscode package to add LD_LIBRARY_PATH
        package = pkgs.vscode.overrideAttrs (old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ [
              pkgs.makeWrapper
            ];

          postInstall =
            (old.postInstall or "")
            + ''
              wrapProgram $out/bin/code \
                --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [stdenv.cc.cc.lib]}
            '';
        });

        mutableExtensionsDir = false;
        profiles.default = {
          userSettings = {
            "mdx07-templates.autoConfigEnabled" = false;
            "mdx07-templates.armToolchainPath" = "${pkgs.gcc-arm-embedded}/bin/";
            "mdx07-templates.makePath" = "${pkgs.gnumake}/bin/";
            "mdx07-templates.openocdPath" = "${pkgs.openocd}/bin/";
            "mdx07-templates.riscvToolchainPath" = "${riscv32-gcc}/bin/";
            "mdx07-templates.simserverPath" = "${mdx07-binaries}/bin/simserver";
          };

          extensions = with pkgs.vscode-extensions;
            [
              marus25.cortex-debug
              usernamehw.errorlens
              ms-vscode.cpptools
              zhwu95.riscv
            ]
            ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "mdx07-templates";
                publisher = "BeanArch";
                version = "0.1.2";
                sha256 = "sha256-KOPtTp/+P80y0cFhmYfs8fSWuBm9jRrh0TEBVVGyPEI=";
              }
              {
                name = "arm";
                publisher = "dan-c-underwood";
                version = "1.7.4";
                sha256 = "sha256-gZBM980AoD+0wnfHXJK9sqCuuLtRY08JnO3Qdq/TRfc=";
              }
              {
                name = "debug";
                publisher = "webfreak";
                version = "0.27.0";
                sha256 = "sha256-p/k5UcXldXKFKbPbnW603Jsut53n01azeDhWMDSd4nw=";
              }
              {
                name = "vscode-serial-monitor";
                publisher = "ms-vscode";
                version = "0.13.1";
                sha256 = "sha256-qZKCNG5EdMwzE9y3WVxaPMdTP9Y0xbe8kozjU7v44OI=";
              }
              {
                name = "peripheral-inspector";
                publisher = "eclipse-cdt";
                version = "1.8.1";
                sha256 = "sha256-sk4F1UXNFq7bNYrWLAW7DxbXMUQGQUZh61UjIa+lfA4=";
              }
              {
                name = "debug-tracker-vscode";
                publisher = "mcu-debug";
                version = "0.0.15";
                sha256 = "sha256-2u4Moixrf94vDLBQzz57dToLbqzz7OenQL6G9BMCn3I=";
              }
              {
                name = "rtos-views";
                publisher = "mcu-debug";
                version = "0.0.13";
                sha256 = "sha256-eTEdZkHbAGSDXP9A06YL6jDBfO8rU1kC9RysxOUxI1U=";
              }
              {
                name = "memory-view";
                publisher = "mcu-debug";
                version = "0.0.28";
                sha256 = "sha256-mQr/uLulKoPVXz0GaMMEHZ/ZSmSAEfO9UpFzy4MfcW4=";
              }
              {
                name = "peripheral-viewer";
                publisher = "mcu-debug";
                version = "1.6.0";
                sha256 = "sha256-nKK8HRzeqDixpdKmgacjhNzanJaTsAnYLC6nCbmWXuU=";
              }
            ]);
        };
      };
    };
  };
}
