# NOTE: When updating Wine, please make sure to match Wine-Gecko and Wine-Mono
# versions:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
# with `GECKO_VERSION` and `MONO_VERSION`, as in:
#  https://gitlab.winehq.org/wine/wine/-/blob/wine-8.0/dlls/appwiz.cpl/addons.c
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Window"
  homepage "https://www.winehq.org/"
  license "GPL-2.0-or-later"
  head "https://gitlab.winehq.org/wine/wine.git", branch: "master"

  stable do
    url "https://dl.winehq.org/wine/source/8.0/wine-8.0.tar.xz"
    sha256 "0272c20938f8721ae4510afaa8b36037457dd57661e4d664231079b9e91c792e"

    resource "gecko-x86" do
      url "https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86.tar.xz"
      sha256 "08d318f3dd6440a8a777cf044ccab039b0d9c8809991d2180eb3c9f903135db3"
    end

    resource "gecko-x86_64" do
      url "https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86_64.tar.xz"
      sha256 "0beac419c20ee2e68a1227b6e3fa8d59fec0274ed5e82d0da38613184716ef75"
    end

    resource "mono" do
      url "https://dl.winehq.org/wine/wine-mono/7.4.0/wine-mono-7.4.0-x86.tar.xz"
      sha256 "9249ece664bcf2fecb1308ea1d2542c72923df9fe3df891986f137b2266a9ba3"
    end
  end

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/wine-7.0.1"
    sha256 big_sur: "5ba6061a6c5c122ad6c71a732b13e4c5451ee3856b64944a91ca6b72a0167005"
  end

  depends_on "bison" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "gphoto2"
  depends_on "gst-libav"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "krb5"
  depends_on "molten-vk" if MacOS.version >= :catalina
  depends_on "sdl2"

  uses_from_macos "flex" => :build

  def install
    # configure doesn't find gphoto2 includes
    ENV.append "C_INCLUDE_PATH", Formula["libgphoto2"].opt_include

    # moltenvk.dylib won't be found when not installed into /usr/local
    if MacOS.version >= :catalina?
      ENV["ac_cv_lib_soname_MoltenVK"] = "#{Formula["molten-vk"].opt_lib}/libMoltenVK.dylib"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-archs=i386,x86_64",
                          "--enable-win64",
                          "--without-alsa",
                          "--without-capi",
                          "--with-coreaudio",
                          "--with-cups",
                          "--without-dbus",
                          "--without-fontconfig",
                          "--with-freetype",
                          "--with-gettext",
                          "--without-gettextpo",
                          "--with-gphoto",
                          "--with-gnutls",
                          "--with-gssapi",
                          "--with-gstreamer",
                          "--without-inotify",
                          "--with-krb5",
                          "--with-mingw",
                          "--without-netapi",
                          "--with-opencl",
                          "--with-opengl",
                          "--without-oss",
                          "--with-pcap",
                          "--with-pthread",
                          "--without-pulse",
                          "--without-sane",
                          "--with-sdl",
                          "--without-udev",
                          "--with-unwind",
                          "--with-usb",
                          "--without-v4l2",
                          "--without-x"

    # Avoid homebrew shims on macOS 10.13+ as preloader requires -no_new_main but Xcode10+
    # only allows this option for 10.7 deployment target, homebrew shims force 10.9
    # ld: dynamic main executables must link with libSystem.dylib for architecture
    # https://source.winehq.org/git/wine.git/commit/0185ee5d99e8dca2c69d61ba0c0e00256beaf1b5
    if MacOS.version >= 10.13
      system "make", "install", "CC=/usr/bin/clang", "CXX=/usr/bin/clang++", "LD=/usr/bin/ld"
    else
      system "make", "install"
    end
  end

  if build.stable?
    def post_install
      (pkgshare/"gecko"/"wine-gecko-2.47.3-x86").install resource("gecko-x86")
      (pkgshare/"gecko"/"wine-gecko-2.47.3-x86_64").install resource("gecko-x86_64")
      (pkgshare/"mono"/"wine-mono-7.4.0").install resource("mono")
    end
  end

  test do
    system bin/"wine64", "--version"
  end
end
