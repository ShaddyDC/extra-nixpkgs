{
  description = "Some stuff I need packaged";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      imports = [
        ./pkgs
      ];

      perSystem = {
        config,
        self',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.pythonOverlay
          ];
        };
        devShells.default = pkgs.mkShell {
          name = "dev";
          packages = with pkgs; [
            (python3.withPackages (ps:
              with python3.pkgs; [
                # pymeshlab
              ]))
          ];
          # pymeshlab = pkgs.python3.pkgs.pymeshlab;
        };

        formatter = pkgs.alejandra;
      };
    };
}
