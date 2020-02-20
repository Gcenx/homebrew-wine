cask 'portingkit' do

  version :latest # always get the latest stable version from the provided links
  homepage "http://portingkit.com/"
  if MacOS.version <= :mountain_lion
      sha256 :no_check
      url "http://portingkit.com/kit/Porting%20Kit%20Legacy.zip"
      name 'Porting Kit Legacy'
      app 'Porting Kit Legacy.app'
   else
      sha256 :no_check
      url "http://portingkit.com/kit/Porting%20Kit.zip"
      name 'Porting Kit'
      app 'Porting kit.app'
   end

    caveats <<~EOS
        With #{token}, you can install Windows games and apps on macOS easily
        using Wineskin technology!
    EOS
end
