class LibinotifyKqueue < Formula
  desc "BSD port of Linux's inotify"
  homepage "https://github.com/libinotify-kqueue/libinotify-kqueue"
  url "https://github.com/libinotify-kqueue/libinotify-kqueue.git",
    tag:      "20211018",
    revision: "ea7835fcafc3cee2a0d6c0e3c8034962c48f6afe"
  license "MIT"
  revision 1
  head "https://github.com/libinotify-kqueue/libinotify-kqueue.git",
    branch: "master"

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/libinotify-kqueue-20211018"
    sha256 cellar: :any, monterey: "c57f064ad92d084d4c3b0f92d5714d1d0942c944a5f334379ce5fdac801627d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" => :build
  depends_on "libtool" => :build

  def install
    # Autoconf
    system "autoreconf", "-fiv"
    # Configure
    system "./configure"
    # Build
    system "make"
    # Copy
    system "make", "install", "DESTDIR=#{buildpath}"
    # Move
    lib.install Dir["#{buildpath}/usr/local/lib/*"]
    include.install Dir["#{buildpath}/usr/local/include/*"]
    man.install Dir["#{buildpath}/usr/local/share/man/*"]
  end

  test do
    # Check if the library is installed
    (testpath/"test.cpp").write <<~EOS
      #include <sys/inotify.h>
      int main() {
        inotify_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-linotify", "-o", "test"
    system "./test"
  end
end
