cask 'wine-crossover20.0.2' do

  version '20.0.2'
  homepage "https://github.com/Gcenx/homebrew-wine/"
  sha256 :no_check
  
  url "https://github.com/Gcenx/homebrew-wine/releases/download/#{version}/wine-crossover-#{version}-osx64.tar.7z"
  name 'Wine Crossover'
  
  depends_on formula: 'p7zip'
  
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
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wine32on64"
  binary "#{appdir}/Wine Crossover.app/Contents/Resources/wine/bin/wineserver"

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
end
