# NOTE: When updating Wine, please make sure to match Wine-Gecko and Wine-Mono
# versions:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
# with `GECKO_VERSION` and `MONO_VERSION`, as in:
#  https://gitlab.winehq.org/wine/wine/-/blob/wine-7.0.1/dlls/appwiz.cpl/addons.c
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Window"
  homepage "https://www.winehq.org/"
  license "GPL-2.0-or-later"
  head "https://gitlab.winehq.org/wine/wine.git", branch: "master"

  stable do
    url "https://dl.winehq.org/wine/source/7.0/wine-7.0.1.tar.xz"
    sha256 "807caa78121b16250f240d2828a07ca4e3c609739e5524ef0f4cf89ae49a816c"

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
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/wine-7.0_2"
    sha256 big_sur: "06a5377e0fba1b055f7dca6c9ba265f45de3d83866f241220ecb9677a55ab54e"
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
                          "--with-mingw",
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
      (pkgshare/"gecko"/"wine-gecko-2.47.2-x86_64").install resource("gecko-x86_64")
      (pkgshare/"mono"/"wine-mono-7.0.0").install resource("mono")
    end
  end

  test do
    system bin/"wine64", "--version"
  end
end
