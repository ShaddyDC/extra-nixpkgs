{
  description = "Some stuff I need packaged";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
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
        };
        devShells.default = pkgs.mkShell {
          name = "dev";
          packages = with self'.packages; [
            (python3.withPackages (ps: with python3.pkgs; [Open3D]))
          ];
        };

        formatter = pkgs.alejandra;
      };
    };
}
