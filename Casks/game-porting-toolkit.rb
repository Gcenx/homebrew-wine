cask "game-porting-toolkit" do
  version "2.0-beta1"
  sha256 "20baa41ef487c56ad1c333e2fbcd03adc851902d89b9d22fa66d9c6072a846dc"

  url "https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-#{version}/game-porting-toolkit-#{version}.tar.xz",
      verified: "github.com/Gcenx/game-porting-toolkit/"
  name "Game Porting Toolkit"
  desc "Use to eliminate months of up-front work and evaluate how well your game runs"
  homepage "https://developer.apple.com/games"

  livecheck do
    url :url
    strategy :github_releases
  end

  conflicts_with cask: %w[
    wine-crossover
    wine@devel
    wine-stable
    wine@staging
  ]
  depends_on cask: "gstreamer-runtime"
  depends_on macos: ">= :sonoma"

  app "Game Porting Toolkit.app"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wine"
  binary "#{appdir}/Game Porting Toolkit.app/Contents/Resources/wine/bin/wine-preloader"
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
