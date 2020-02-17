cask 'wine-crossover' do

  version :latest
  sha256 :no_check
  url "https://github.com/Gcenx/homebrew-wine/releases/download/19.0.1/Wine.Crossover.zip"

  name 'Wine Crossover'
  conflicts_with formula: 'wine',
                 cask:    [
                            'wine-stable',
                            'wine-devel',
                            'wine-staging',
                          ]

  app 'Wine Crossover.app'
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/appdb"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/winehelp"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/msiexec"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/notepad"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/regedit"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/regsvr32"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine32on64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineboot"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winecfg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineconsole"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winedbg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winefile"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winemine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winepath"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineserver"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/explorer"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winetricks"

  if MacOS.version >= :catalina
    caveats <<~EOS
      #{token} installs support for running 32 Bit on 64 bit applications in Wine, which is considered experimental.
      #{token} Requires SIP to be disabled! Use wine32on64 instead of wine.
      #{token} bundles a patched version of winetricks
      Install the following packages, cabextract, p7zip & unrar
    EOS
  else
  
  caveats <<~EOS
    #{token} installs support for running 64 bit applications in Wine, which is considered experimental.
    If you do not want 64 bit support, you should download and install the #{token} package manually.
    #{token} Requires SIP to be disabled! Use wine32on64 instead of wine.
    #{token} bundles a patched version of winetricks
    Install the following packages, cabextract, p7zip & unrar
  EOS
  end
end
