cask 'unofficial-wineskin' do

  version '1.8.4.2'
  homepage "https://github.com/Gcenx/WineskinServer/"
  sha256 :no_check
  
  url "https://github.com/Gcenx/WineskinServer/releases/download/V#{version}/Wineskin.Winery.txz"
  
  name 'Wineskin Winery'

  #depends_on macos: '>= :mavericks'
  
  app 'Wineskin Winery'

  if MacOS.version >= :catalina
    caveats <<~EOS
      #{token} Requires SIP to be disabled!
    EOS
  end
end
