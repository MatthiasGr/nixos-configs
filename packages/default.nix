self: super: {
  zsh-prompt-matthias = self.callPackage ./zsh-prompt-matthias { };
  desert-sands-wallpaper = self.callPackage ./desert-sands-wallpaper.nix { };
  polonium = self.callPackage ./polonium.nix { };
  kwin-script-dynamic-desktops = self.callPackage ./kwin-script-dynamic-desktops.nix { };
  applet-window-buttons = self.callPackage ./applet-window-buttons.nix { };
  applet-window-title = self.callPackage ./applet-window-title.nix { };
  proton-ge-custom = self.callPackage ./proton-ge-custom.nix { };
  krohnkite = self.callPackage ./krohnkite { };
  forest-cascades-wallpaper = self.callPackage ./forest-cascades-wallpaper { };
  plasma-gamemode = self.callPackage ./plasma-gamemode.nix { };
}
