cask "wineskin" do
  version "1.8.4.2"
  sha256 :no_check

  url "https://github.com/Gcenx/WineskinServer/releases/download/V#{version}/Wineskin.Winery.txz"
  name "Wineskin Winery"
  desc "Porting tool, to make Windows programs/games into native apps"
  homepage "https://github.com/Gcenx/WineskinServer/"

  depends_on cask: "gcenx/wine/gstreamer"

  app "Wineskin Winery.app"

  # Workaround issue until it's fixed in Winery
  # https://github.com/Gcenx/WineskinServer/issues/96
  preflight do
    system_command "/bin/mkdir", args: ["-p", "/Users/#{ENV.fetch("USER")}/Applications/Wineskin"], sudo: false
  end
end
