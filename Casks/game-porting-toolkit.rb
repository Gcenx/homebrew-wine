cask "game-porting-toolkit" do
  version "3.0-3"
  sha256 "d377683937340f914823dbb2e1252b329cbf834ff58907d0293db8cebf0e392e"

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
