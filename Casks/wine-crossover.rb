cask 'wine-crossover' do

  version '19.0.1'
  homepage "https://github.com/Gcenx/homebrew-wine/"
  sha256 :no_check
  
  url "https://github.com/Gcenx/homebrew-wine/releases/download/#{version}/Wine.Crossover.zip"
  name 'Wine Crossover'
  conflicts_with formula: 'winetricks',
                 cask:    [
                            'wine-stable',
                            'wine-devel',
                            'wine-staging',
                          ]
  depends_on macos: '>= :mavericks'
  depends_on formula: 'cabextract'
  depends_on formula: 'p7zip'
  depends_on formula: 'unrar'

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
      #{token} supports both 32-bit and 64-bit now. It is compatible with your
      existing 32-bit wine prefix, but it will now default to 64-bit when you
      create a new wine prefix. The architecture can be selected using the
        WINEARCH environment variable which can be set to either win32 or
      win64.
    
      To create a new pure 32-bit prefix, you can run:
          $ WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg
      See the Wine FAQ for details: https://wiki.winehq.org/FAQ#Wineprefixes
      #{token} Requires SIP to be disabled! Use wine32on64 instead of wine.
      #{token} bundles a patched version of winetricks
    EOS
  else
    caveats <<~EOS
        #{token} supports both 32-bit and 64-bit now. It is compatible with your
        existing 32-bit wine prefix, but it will now default to 64-bit when you
        create a new wine prefix. The architecture can be selected using the
          WINEARCH environment variable which can be set to either win32 or
        win64.
      
        To create a new pure 32-bit prefix, you can run:
            $ WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg
        See the Wine FAQ for details: https://wiki.winehq.org/FAQ#Wineprefixes
        #{token} bundles a patched version of winetricks
    EOS
  end
end
