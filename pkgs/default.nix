{...}: {
  imports = [./python];

  perSystem = {pkgs, ...}: {
    packages = {
      openusd = pkgs.python3.pkgs.openusd;
    };
  };
}
