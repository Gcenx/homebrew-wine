cask "kegworks" do
  version "2.0.3"
  sha256 "bc30236554c7333f35fbff78b7eb849854b5c9521a917007cc9b4944421c5b6a"

  url "https://github.com/Kegworks-App/Winery/releases/download/v#{version}/winery-v#{version}.tar.xz"
  name "Winery"
  desc "Porting tool, to make Windows programs/games into native apps"
  homepage "https://github.com/Kegworks-App"

  depends_on macos: ">= :catalina"

  app "Winery.app", target: "Kegworks Winery.app"

  postflight do
    system "/usr/bin/xattr", "-drs", "com.apple.quarantine", "#{appdir}/Kegworks Winery.app"
    system "/usr/bin/codesign", "--force", "--deep", "-s", "-", "#{appdir}/Kegworks Winery.app"
  end

  zap trash: [
    "~/Library/Application Support/Kegworks",
    "~/Library/Caches/com.unofficial.winery",
    "~/Library/Caches/com.unofficial.wineskin",
  ]

  caveats do
    requires_rosetta
  end
end
