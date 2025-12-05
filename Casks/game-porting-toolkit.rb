cask "game-porting-toolkit" do
  version "3.0"
  sha256 "639349d924f9d19261f1013046c62ca14a4e2e0777bc377b82faff42b6a63f4d"

  url "https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-#{version}/game-porting-toolkit-#{version}.tar.xz",
      verified: "github.com/Gcenx/game-porting-toolkit/"
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
  depends_on macos: ">= :sonoma"

  app "Game Porting Toolkit.app"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wine64-preloader"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wineserver"

  postflight do
    system "/usr/bin/xattr", "-drs", "com.apple.quarantine", "#{appdir}/Game Porting Toolkit.app"
    system "/usr/bin/codesign", "--force", "--deep", "-s", "-", "#{appdir}/Game Porting Toolkit.app"
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
