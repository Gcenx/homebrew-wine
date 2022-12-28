class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/The-Wineskin-Project/winetricks/archive/20221108.tar.gz"
  sha256 "e2e9a9ed15306c5e80a9d2961069f278a82bebd7a4b89ffedbba86f7fa475c42"
  license "LGPL-2.1-or-later"
  head "https://github.com/The-Wineskin-Project/winetricks.git", branch: "macOS"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/winetricks-20221108"
    sha256 cellar: :any_skip_relocation, big_sur: "44a6a7589e039f94ec4d6d45e328eb18bc342e1688be6c834eb53abda931323c"
  end

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
