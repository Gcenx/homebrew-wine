# NOTE: When updating Wine, please make sure to match Wine-Gecko and Wine-Mono
# versions:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
# with `GECKO_VERSION` and `MONO_VERSION`, as in:
#    https://source.winehq.org/git/wine.git/blob/refs/tags/wine-9.0:/dlls/appwiz.cpl/addons.c
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  url "https://dl.winehq.org/wine/source/9.0/wine-9.0.tar.xz"
  sha256 "7cfd090a5395f5b76d95bb5defac8a312c8de4c070c1163b8b58da38330ca6ee"
  head "https://gitlab.winehq.org/wine/wine.git",
    branch: "master"

  depends_on "bison" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on :macos
  depends_on "sdl2"

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  on_macos do
    depends_on "libinotify-kqueue"
    depends_on "molten-vk"
  end

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.tar.xz"
    sha256 "2cfc8d5c948602e21eff8a78613e1826f2d033df9672cace87fed56e8310afb6"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.tar.xz"
    sha256 "fd88fc7e537d058d7a8abf0c1ebc90c574892a466de86706a26d254710a82814"
  end

  def install
    # Bypass the Homebrew shims to build native binaries with the dedicated compiler.
    # (PE binaries will be built with mingw32-gcc.)
    compiler_options = ["CC=clang",
                        "CXX=clang++"]

    # We also need to tell the linker to add Homebrew to the rpath stack.
    ENV.append "LDFLAGS", "-lSystem"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"

    # Common compiler flags for both Mach-O and PE binaries.
    ENV.append_to_cflags "-g -O2 -Wno-deprecated-declarations"
    # Use an older deployment target to avoid new dyld behaviors.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.14"

    wine_configure_options = ["--prefix=#{prefix}",
                              "--disable-tests",
                              "--enable-archs=i386,x86_64",
                              "--enable-win64",
                              "--without-alsa",
                              "--without-capi",
                              "--with-coreaudio",
                              "--with-cups",
                              "--without-dbus",
                              "--with-freetype",
                              "--with-gettext",
                              "--without-gettextpo",
                              "--without-gphoto",
                              "--with-gnutls",
                              "--without-gssapi",
                              "--with-gstreamer",
                              "--with-inotify",
                              "--without-krb5",
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
                              "--without-usb",
                              "--without-v4l2",
                              "--with-vulkan",
                              "--without-x"]

    # Build
    mkdir buildpath/"wine64-build" do
      system buildpath/"configure", *wine_configure_options, *compiler_options
      system "make"
    end

    # Install
    cd "wine64-build" do
      system "make", "install-lib"
    end
  end

  def post_install
    # Homebrew replaces wine's rpath names with absolute paths, we need to change them back to @rpath relative paths
    # Wine relies on @rpath names to cause dlopen to always return the first dylib with that name loaded into
    # the process rather than the actual dylib found using rpath lookup.
    Dir["#{lib}/wine/x86_64-unix/*.so"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib)
      chmod 0444, dylib
    end

    # Install wine-gecko into place
    (share/"wine"/"gecko"/"wine-gecko-2.47.4-x86").install resource("gecko-x86")
    (share/"wine"/"gecko"/"wine-gecko-2.47.4-x86_64").install resource("gecko-x86_64")
  end

  test do
    system bin/"wine", "--version"
  end
end
