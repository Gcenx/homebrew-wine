cask "game-porting-toolkit" do
  version "3.0-2"
  sha256 "c16b3b40b9a34853fc1f4546d13d20d28bc06e0f2edcfcf425df2ef7f2ec4ba4"

  url "https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-#{version}/game-porting-toolkit-#{version}.tar.xz"
  name "Game Porting Toolkit"
  desc "Use to eliminate months of up-front work and evaluate how well your game runs"
  homepage "https://developer.apple.com/games"

  livecheck do
    url :url
    strategy :github_releases
  end

  conflicts_with cask: [
    "wine-crossover",
    "wine-stable",
    "wine@devel",
    "wine@staging",
  ]
  depends_on macos: :sonoma

  app "Game Porting Toolkit.app"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wine64-preloader"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wineserver"

  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-drs", "com.apple.quarantine", "{{appdir}}/Game Porting Toolkit.app"]

    # The tarball ships the same unix ntdll.so twice, in x86_64-unix and in
    # x86_32on64-unix. The two files are the same build (they differ only in
    # LC_UUID, a few load-command bytes and the code signature; no __TEXT byte
    # differs), but dyld keys images by path, so a 32-bit process loads both and
    # gets two independent copies of ntdll's statics. virtual_init() only runs in
    # one of them, leaving the other with pages_vprot == NULL and
    # pages_vprot_size == 0. winecoreaudio.so links @rpath/ntdll.so with an
    # @loader_path rpath, so it binds to the uninitialised copy and every
    # allocation made on a CoreAudio callback thread aborts in alloc_pages_vprot.
    # That is why 32-bit games die during audio initialisation.
    # Replacing the duplicate with a symlink makes dyld reuse the single
    # already-initialised image.
    run "/bin/ln",
        args: ["-sfh", "../x86_64-unix/ntdll.so",
               "{{appdir}}/Game Porting Toolkit.app/Contents/Resources/wine/lib/wine/x86_32on64-unix/ntdll.so"]

    run "/usr/bin/codesign",
        args: ["--force", "--deep", "-s", "-", "{{appdir}}/Game Porting Toolkit.app"]
  end

  zap trash: [
        "~/.local/share/applications/wine*",
        "~/.local/share/icons/hicolor/**/application-x-wine*",
        "~/.local/share/mime/application/x-wine*",
        "~/.local/share/mime/packages/x-wine*",
        "~/.wine",
        "~/.wine32",
        "~/Library/Saved Application State/org.winehq.wine-devel.wine.savedState",
      ],
      rmdir: [
        "~/.local/share/applications",
        "~/.local/share/icons",
        "~/.local/share/mime",
      ]

  caveats <<~EOS
    Please follow the instructions in the Game Porting Toolkit README to complete installation.
  EOS
  caveats do
    requires_rosetta
  end
end
