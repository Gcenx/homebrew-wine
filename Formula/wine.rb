# NOTE: When updating Wine, please make sure to match Wine-Gecko and Wine-Mono
# versions:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
# with `GECKO_VERSION` and `MONO_VERSION`, as in:
#  https://source.winehq.org/git/wine.git/blob/refs/tags/wine-7.0:/dlls/appwiz.cpl/addons.c
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Window"
  homepage "https://www.winehq.org/"
  license "GPL-2.0-or-later"
  head "https://source.winehq.org/git/wine.git", branch: "master"

  stable do
    url "https://dl.winehq.org/wine/source/7.0/wine-7.0.tar.xz"
    sha256 "5b43e27d5c085cb18f97394e46180310d5eef7c1d91c6895432a3889b2de086b"

    resource "gecko-x86_64" do
      url "https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.tar.xz"
      sha256 "b4476706a4c3f23461da98bed34f355ff623c5d2bb2da1e2fa0c6a310bc33014"
    end

    resource "mono" do
      url "https://dl.winehq.org/wine/wine-mono/7.0.0/wine-mono-7.0.0-x86.tar.xz"
      sha256 "2a047893f047b4f0f5b480f1947b7dda546cee3fec080beb105bf5759c563cd3"
    end
  end

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/wine-7.0"
    sha256 big_sur:  "63707b2552cad5f68080a91c559153c55965f67187a489af566fabc34456a076"
    sha256 catalina: "a617290120db9415898c07c7e5f47d854eba0bc7a477585b33ea614f78d20b42"
  end

  depends_on "bison" => :build
  depends_on "gcenx/wine/mingw-w64@9" => :build if Hardware::CPU.intel?
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "gphoto2"
  depends_on "gst-plugins-base"
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

    extra_args = []
    extra_args << "--with-mingw" if Hardware::CPU.intel? || build.head?
    extra_args << "--with-vulkan" if MacOS.version >= :catalina

    system "./configure", "--prefix=#{prefix}",
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
                          "--with-ldap",
                          "--without-netapi",
                          "--with-openal",
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
                          "--without-vkd3d",
                          "--without-x",
                          *extra_args

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
      (pkgshare/"gecko"/"wine-gecko-2.47.2-x86_64").install resource("gecko-x86_64")
      (pkgshare/"mono"/"wine-mono-7.0.0").install resource("mono")
    end
  end

  test do
    system bin/"wine64", "--version"
  end
end
