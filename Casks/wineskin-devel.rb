cask "wineskin-devel" do
  version "2.0"
  sha256 "a065827ab7d30f84a631d0c26431a3c6f2576471f84501daf6455334c5eb7c79"

  url "https://github.com/The-Wineskin-Project/Winery/releases/download/#{version}/wineskin-winery-v#{version}.tar.xz"
  name "Wineskin Winery"
  desc "Porting tool, to make Windows programs/games into native apps"
  homepage "https://github.com/The-Wineskin-Project/Winery/"

  conflicts_with cask: %w[
    wineskin
  ]
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
