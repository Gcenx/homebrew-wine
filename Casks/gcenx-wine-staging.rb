cask 'gcenx-wine-staging' do
  version '6.12'
  sha256 "1dc95fe1db6269dff7b55380075ec7516c3b495889639d7083e150e94d2e3f5d"
  
  url "https://github.com/Gcenx/macOS_Wine_builds/releases/download/#{version}/wine-staging-#{version}-osx64.tar.xz"
  
  name 'Wine-staging'
  homepage 'https://github.com/Gcenx/macOS_Wine_builds'
  
  depends_on formula: 'xz'
  
  conflicts_with formula: 'wine',
                 cask:    [
                            'wine-stable',
                            'wine-devel',
                            'wine-staging',
                            'wine-crossover',
                            'gcenx-wine-stable',
                            'gcenx-wine-devel',
                          ]

  app "Wine Staging.app"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/start/bin/appdb"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/start/bin/winehelp"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/msiexec"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/notepad"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/regedit"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/regsvr32"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wine"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wineboot"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winecfg"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wineconsole"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winedbg"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winefile"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winemine"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/winepath"
  binary "#{appdir}/Wine Staging.app/Contents/Resources/wine/bin/wineserver"

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
