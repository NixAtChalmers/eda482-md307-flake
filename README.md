# EDA482 MD307 Flake

Nix flake for EDA482 Machine oriented programming course.

Includes simserver, including desktop entry, RISC-V32 toolchain and VSCode extensions and configuration.

## Installation

Add the flake input to your `flake.nix`:

```nix
{
  inputs.md307.url = "github:LinuxAtChalmers/eda482-md307-flake";
}
```

Add the system module to `configuration.nix` which will install the necessary
libraries and toolchains:

```
{ pkgs, inputs, ... }:
{
  imports = [
    inputs.md307.nixosModules.default
  ];
}
```
    

Also add the Home Manager module, this will install the extensions for
Visual Studio Code and set the relevant paths:

```
{ pkgs, inputs, ... }:
{
  home-manager.users.youruser = {
    # import the home manager module
    imports = [
      inputs.md307.homeModules.default
    ];
  };
}
```

Rebuild your system, you can now start Visual Studio Code and everything should
be set up for you.

> [!NOTE]  
> You do not need to run the **MDx07: Install MD307 Development Tools** command
> in VSCode, everything is already installed and linked for you.

