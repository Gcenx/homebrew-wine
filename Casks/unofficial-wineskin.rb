cask 'unofficial-wineskin' do

  version '1.8.4'
  homepage "https://github.com/Gcenx/WineskinServer/"
  sha256 :no_check
  
  url "https://github.com/Gcenx/WineskinServer/releases/download/V#{version}/Unofficial.Wineskin.Winery.-.No.compression.zip"
  
  name 'Unofficial Wineskin Winery'

  depends_on macos: '>= :mavericks'
  
  app 'Unofficial Wineskin Winery - No compression.app'

  if MacOS.version >= :catalina
    caveats <<~EOS
      #{token} Requires SIP to be disabled!
    EOS
  end
end
