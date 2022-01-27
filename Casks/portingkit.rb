cask 'portingkit' do
  version :latest # always get the latest stable version from the provided links
  sha256 :no_check
  homepage "http://portingkit.com/"

  url "https://portingkit.com/pub/portingkit/porting-kit.dmg"
  name 'Porting Kit'
  app 'Porting kit.app'

  auto_updates true

    caveats <<~EOS
        With #{token}, you can install Windows games and apps on macOS easily
        using Wineskin technology!
    EOS
end
