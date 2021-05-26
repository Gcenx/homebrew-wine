cask 'unofficial-wineskin' do

  version '1.8.4.2'
  homepage "https://github.com/Gcenx/WineskinServer/"
  sha256 :no_check
  revision 1
  
  url "https://github.com/Gcenx/WineskinServer/releases/download/V#{version}/Wineskin.Winery.txz"
  
  name 'Wineskin Winery'

  app 'Wineskin Winery.app'

  # Workaround issue until it's fixed in Winery
  # https://github.com/Gcenx/WineskinServer/issues/96
  preflight do
    system_command "/bin/mkdir", args: ["-p", "~/Applications/Wineskin"], sudo: false
  end

end
