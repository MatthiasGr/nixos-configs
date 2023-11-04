self: super: {
  zsh-prompt-matthias = self.callPackage ./zsh-prompt-matthias { };
  desert-sands-wallpaper = self.callPackage ./desert-sands-wallpaper.nix { };
  polonium = self.callPackage ./polonium.nix { };
}
