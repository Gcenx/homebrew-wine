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
  sha256 "cdfe282ce33788bd4f969c8bfb1d3e2de060eb6c296fa1c3cdf4e4690b8b1831"
  head "https://source.winehq.org/git/wine.git"

  depends_on "bison" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "sdl2"

  uses_from_macos "flex" => :build

  on_macos do
    depends_on "libinotify-kqueue"
    depends_on "molten-vk"
  end

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.tar.xz"
    sha256 "8fab46ea2110b2b0beed414e3ebb4e038a3da04900e7a28492ca3c3ccf9fea94"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.tar.xz"
    sha256 "b4476706a4c3f23461da98bed34f355ff623c5d2bb2da1e2fa0c6a310bc33014"
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
                              "--enable-win64",
                              "--arch=i386,x86_64",
                              "--disable-tests",
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
                              "--without-vulkan",
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
