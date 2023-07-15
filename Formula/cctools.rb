class Cctools < Formula
  desc "Apple compiler toolchain (tpoechtrager fork)"
  homepage "https://opensource.apple.com/tarballs/cctools"
  url "https://github.com/Gcenx/cctools-port/archive/refs/tags/cctools-973.0.1-ld64-609.tar.gz"
  sha256 "16d10a2c4f529ab42abe4907f688cdcc3d6ab5a7822fabdb3dc2749e119decec"
  license "APSL-2.0"

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/cctools-609"
    sha256 cellar: :any, monterey: "ae05d9395f3ef4d2a2cba8a5f67d439ffc55b9121d40daf3d0e414350f474edc"
  end

  keg_only "provided by Xcode CLT"

  depends_on "cmake" => :build
  depends_on "tapi"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lto-support
    ]

    cd "cctools" do
      mkdir "build" do
        system "../configure", *args
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/ld", "-v"
  end
end
