cask "portingkit" do
  version :latest # always get the latest stable version from the provided links
  sha256 :no_check

  url "https://portingkit.com/pub/portingkit/porting-kit.dmg"
  name "Porting Kit"
  desc "Helps make ports"
  homepage "http://portingkit.com/"

  app "Porting kit.app"

  caveats <<~EOS
    With #{token}, you can install Windows games and apps on macOS easily
    using Wineskin technology!
  EOS
end
