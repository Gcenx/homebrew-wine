<<<<<<< HEAD
cask "portingkit" do
  version :latest # always get the latest stable version from the provided links
  sha256 :no_check

  url "https://portingkit.com/pub/portingkit/porting-kit.dmg"
  name "Porting Kit"
  desc "Porting tool, to make Windows programs/games into native apps"
  homepage "http://portingkit.com/"

  app "Porting kit.app"

  caveats <<~EOS
    With #{token}, you can install Windows games and apps on macOS easily
    using Wineskin technology!
  EOS
=======
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
>>>>>>> cd3fe3f (cleanup casks)
end
