cask "portingkit" do
  version :latest # always get the latest stable version from the provided links
  sha256 :no_check

  url "https://www.portingkit.com/pub/portingkit/download_latest.php?format=dmg"
  name "Porting Kit"
  desc "Porting tool, to make Windows programs/games into native apps"
  homepage "http://portingkit.com/"

  app "Porting kit.app"

  postflight do
    system "xattr", "-drs", "com.apple.quarantine", "#{appdir}/Porting kit.app"
  end

  caveats <<~EOS
    With #{token}, you can install Windows games and apps on macOS easily
    using Wineskin technology!
  EOS
  caveats do
    requires_rosetta
  end
end
