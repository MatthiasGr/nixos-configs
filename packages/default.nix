self: super: {
  zsh-prompt-matthias = self.callPackage ./zsh-prompt-matthias { };
  desert-sands-wallpaper = self.callPackage ./desert-sands-wallpaper.nix { };
  polonium = self.callPackage ./polonium.nix { };
  kwin-script-dynamic-desktops = self.callPackage ./kwin-script-dynamic-desktops.nix { };
  applet-window-buttons = self.callPackage ./applet-window-buttons.nix { };
}
