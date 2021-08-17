{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [

    libsForQt5.appstream-qt
    libsForQt5.extra-cmake-modules
    libsForQt5.kconfig
    libsForQt5.kdeplasma-addons
    libsForQt5.ki18n
    libsForQt5.kwindowsystem
    libsForQt5.kxmlgui
    libsForQt5.plasma-framework
    libsForQt5.plasma-sdk # plasmoidviewer
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qtx11extras

  ];
}
