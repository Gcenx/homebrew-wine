cask "wine-crossover" do
  version "21.0.0"
  sha256 "f5fcbe98977cc42ba39813140bcde45e10b9e0bd24da435a6a7227bb62fd0100"

  url "https://github.com/Gcenx/homebrew-wine/releases/download/#{version}/wine-crossover-#{version}-osx64.tar.xz"
  name "Wine Crossover"
  desc "Compatibility layer to run Windows applications"
  homepage "https://github.com/Gcenx/homebrew-wine"

  conflicts_with cask: [
    "wine-stable",
    "wine-devel",
    "wine-staging",
    "wine-crossover-19",
    "wine-crossover-20",
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
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineboot"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winecfg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineconsole"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winedbg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winefile"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winemine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winepath"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineserver"

  caveats <<~EOS
    #{token} supports both 32-bit and 64-bit. It is compatible with an existing
    32-bit wine prefix, but it will now default to 64-bit when you create a new
    wine prefix. The architecture can be selected using the WINEARCH environment
    variable which can be set to either win32 or win64.

    To create a new pure 32-bit prefix, you can run:
      $ WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg

    See the Wine FAQ for details: https://wiki.winehq.org/FAQ#Wineprefixes
  EOS
end
