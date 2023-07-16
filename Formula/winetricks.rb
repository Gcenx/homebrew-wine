class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/The-Wineskin-Project/winetricks/archive/20230707.tar.gz"
  sha256 "a36acfb24dc3acd6c8f83cd730188db210fb72cada3ec36a8c850cdb6100c6fc"
  license "LGPL-2.1-or-later"
  head "https://github.com/The-Wineskin-Project/winetricks.git", branch: "macOS"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/winetricks-20230707"
    sha256 cellar: :any_skip_relocation, monterey: "5ca7e369f50588c21b993c7bfc823018a7ebc777eff4f578aee123ee8762613a"
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
