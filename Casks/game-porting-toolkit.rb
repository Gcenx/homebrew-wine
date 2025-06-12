cask "game-porting-toolkit" do
  on_sonoma :or_older do
    version "2.1"
    sha256 "6a70069a977d59d8c4b7f9f29eee03c7ba75434cf22c016d342502ef7096a13b"

    livecheck do
      skip "Legacy version"
    end
  end
  on_sequoia :or_newer do
    version "3.0-beta1"
    sha256 "2ed533de71b8f5a244e93e80e6ec6ca4c496482ba9adcbe5df15466afa792ea9"

    livecheck do
      url :url
      strategy :github_releases
    end
  end

  url "https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-#{version}/game-porting-toolkit-#{version}.tar.xz",
      verified: "github.com/Gcenx/game-porting-toolkit/"
  name "Game Porting Toolkit"
  desc "Use to eliminate months of up-front work and evaluate how well your game runs"
  homepage "https://developer.apple.com/games"

  conflicts_with cask: %w[
    wine-crossover
    wine@devel
    wine-stable
    wine@staging
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
