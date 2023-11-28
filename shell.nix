{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    python311Packages.mkdocs-material
    python311Packages.mkdocs-material-extensions
  ];
  shellHook = ''
    alias serve='mkdocs serve';
  '';
}
