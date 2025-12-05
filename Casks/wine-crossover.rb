cask "wine-crossover" do
  version "23.7.1-1"
  sha256 "e24ba084737c8823e8439f7cb75d436a917fd92fc34b832bcaa0c0037eb33d03"

  url "https://github.com/Gcenx/winecx/releases/download/crossover-wine-#{version}/wine-crossover-#{version}-osx64.tar.xz"
  name "Wine Crossover"
  desc "Compatibility layer to run Windows applications"
  homepage "https://github.com/Gcenx/winecx/"

  livecheck do
    url :stable
    strategy :github_releases
  end

  conflicts_with cask: [
    "game-porting-toolkit",
    "wine-stable",
    "wine@devel",
    "wine@staging",
  ]
  depends_on macos: ">= :catalina"

  app "Wine Crossover.app"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/appdb"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/winehelp"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/msiexec"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/notepad"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/regedit"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/regsvr32"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine-preloader"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine64-preloader"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineboot"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winecfg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineconsole"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winefile"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winemine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winepath"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineserver"

  postflight do
    system "/usr/bin/xattr", "-drs", "com.apple.quarantine", "#{appdir}/Wine Crossover.app"
    system "/usr/bin/codesign", "--force", "--deep", "-s", "-", "#{appdir}/Wine Crossover.app"
  end

  caveats <<~EOS
    #{token} supports running 32-bit & 64-bit windows binaries.

    #{token} does not support creating a 32-bit wine prefix.
  EOS
  caveats <<~EOS
    To enable noflicker set the following registry key in your prefix:
    [HKCU\\Software\\Wine\\Mac Driver]
    "ForceOpenGLBackingStore"="y"
  EOS
  caveats do
    requires_rosetta
  end
end
