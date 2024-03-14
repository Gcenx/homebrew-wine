cask "wineskin" do
  version "1.8.4.2"
  sha256 :no_check

  url "https://github.com/Gcenx/WineskinServer/releases/download/V#{version}/Wineskin.Winery.txz"
  name "Wineskin Winery"
  desc "Porting tool, to make Windows programs/games into native apps"
  homepage "https://github.com/Gcenx/WineskinServer/"

  conflicts_with cask: %w[
    wineskin-devel
  ]
  depends_on cask: "gstreamer-runtime"
  depends_on macos: ">= :catalina"

  app "Wineskin Winery.app"

  # Workaround issue until it's fixed in Winery
  # https://github.com/Gcenx/WineskinServer/issues/96
  postflight do
    system "/usr/bin/xattr", "-drs", "com.apple.quarantine", "#{appdir}/Wineskin Winery.app"
    system "/usr/bin/codesign", "--force", "--deep", "-s", "-", "#{appdir}/Wineskin Winery.app"
    system_command "/bin/mkdir", args: ["-p", "/Users/#{ENV.fetch("USER")}/Applications/Wineskin"], sudo: false
  end

  zap trash: [
    "~/Library/Application Support/Wineskin",
    "~/Library/Caches/com.unofficial.wineskin",
    "~/Library/Caches/com.unofficial.wineskinwinery",
  ]

  caveats do
    requires_rosetta
  end
end
