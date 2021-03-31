cask 'wine-crossover@19.0.2' do

  version '19.0.2'
  homepage "https://github.com/Gcenx/homebrew-wine/"
  sha256 "ae0b3054f7787d12323faace5584c4646697e178dd8e160874c316c1632442dc"
  
  url "https://github.com/Gcenx/homebrew-wine/releases/download/#{version}/wine-crossover-#{version}-osx64.tar.xz"
  name 'Wine Crossover'
  
  depends_on formula: 'xz'
  
  depends_on macos: ">= :high_sierra"
  
  conflicts_with formula: 'wine',
                 cask:    [
                            'wine-stable',
                            'wine-devel',
                            'wine-staging',
                            'gcenx-wine-stable',
                            'gcenx-wine-devel',
                            'gcenx-wine-staging',
                            'wine-crossover',
                          ]

  app 'Wine Crossover.app'
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/appdb"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/winehelp"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/msiexec"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/notepad"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/regedit"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/regsvr32"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineboot"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winecfg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineconsole"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winedbg"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winefile"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winemine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/winepath"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineserver"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/start/bin/wine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine32on64"
  
    caveats <<~EOS
        #{token} supports both 32-bit and 64-bit now. It is compatible with your
        existing 32-bit wine prefix, but it will now default to 64-bit when you
        create a new wine prefix. The architecture can be selected using the
          WINEARCH environment variable which can be set to either win32 or
        win64.
      
        To create a new pure 32-bit prefix, you can run:
            $ WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg
        See the Wine FAQ for details: https://wiki.winehq.org/FAQ#Wineprefixes
    EOS

    caveats <<~EOS
        To enable noflicker set the following registry key in your prefix:
        [HKCU\\Software\\Wine\\Mac Driver]
        "ForceOpenGLBackingStore"="y"
    EOS
end
