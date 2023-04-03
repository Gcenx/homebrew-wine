class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/The-Wineskin-Project/winetricks/archive/20230331.tar.gz"
  sha256 "b11c052461b019ee7eba6555a606c4e744227fe74d2bb484f14cf2b984d1e599"
  license "LGPL-2.1-or-later"
  head "https://github.com/The-Wineskin-Project/winetricks.git", branch: "macOS"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/winetricks-20230331"
    sha256 cellar: :any_skip_relocation, monterey: "33a2020feacd1dd64618ba2490a48c1e2e515351b2bd4c75dbfadcc7ee854da5"
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
