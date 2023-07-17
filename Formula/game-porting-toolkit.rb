# The 22.1.1 tarball contains an empty sources/freetype directory, which confuses the default CurlDownloadStrategy.
# A custom strategy also allows us to restrict extraction to just wine.
class TarballDownloadStrategy < CurlDownloadStrategy
  def stage
    ohai "Staging #{cached_location} in #{pwd}"
    system "tar", "-xf", cached_location, "--include=sources/wine/*", "--strip-components=2"
    yield
  end
end

class GamePortingToolkit < Formula
  desc "Apple Game Porting Toolkit"
  homepage "https://developer.apple.com/"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-22.1.1.tar.gz", using: TarballDownloadStrategy
  version "1.0.2"
  sha256 "cdfe282ce33788bd4f969c8bfb1d3e2de060eb6c296fa1c3cdf4e4690b8b1831"
  revision 1

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/game-porting-toolkit-1.0.2_1"
    sha256 monterey: "661148370c0cf408c2b4eea54784db9f8becc09ee797990e688bb31a531beecc"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cctools" => :build
  depends_on "cx-llvm" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "sdl2"

  uses_from_macos "flex" => :build

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.tar.xz"
    sha256 "8fab46ea2110b2b0beed414e3ebb4e038a3da04900e7a28492ca3c3ccf9fea94"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.tar.xz"
    sha256 "b4476706a4c3f23461da98bed34f355ff623c5d2bb2da1e2fa0c6a310bc33014"
  end

  # Getting patchs from my winecx mirror
  # game-porting-toolkit 1.0
  patch do
    url "https://github.com/Gcenx/winecx/commit/a039ed8aece88886307a690a30aa143ba8796474.patch?full_index=1"
    sha256 "1a19348aa24f6308d323b972c3c689b4301d9a0d7d7faa0b8391d3c932185248"
  end

  # game-porting-toolkit 1.0.2
  patch do
    url "https://github.com/Gcenx/winecx/commit/bc0f70f1bb68d02e8d6e67093d1f9e52014021f3.patch?full_index=1"
    sha256 "659fc28ac1ab81bb0783310a59e874ea5c8285d7b14ba325edf55f084e662d76"
  end

  def install
    # Bypass the Homebrew shims to build native binaries with the dedicated compiler.
    # (PE binaries will be built with mingw32-gcc.)
    compiler = Formula["cx-llvm"]
    linker = Formula["cctools"]
    compiler_options = ["CC=#{compiler.bin}/clang",
                        "CXX=#{compiler.bin}/clang++",
                        "AS=#{linker.bin}/as",
                        "LD=#{linker.bin}/ld"]

    # We also need to tell the linker to add Homebrew to the rpath stack.
    ENV.append "LDFLAGS", "-lSystem"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    ENV.append "LDFLAGS", "-Wl,-rpath,@executable_path/../lib/external"

    # Common compiler flags for both Mach-O and PE binaries.
    ENV.append_to_cflags "-O3 -Wno-deprecated-declarations -Wno-incompatible-pointer-types"
    # Use an older deployment target to avoid new dyld behaviors.
    # The custom compiler is too old to accept "13.0", so we use "10.14".
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.14"

    wine_configure_options = ["--prefix=#{prefix}",
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
                              "--without-inotify",
                              "--without-krb5",
                              "--with-mingw",
                              "--without-netapi",
                              "--without-openal",
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

    wine64_configure_options = ["--enable-win64"]

    wine32_configure_options = ["--enable-win32on64",
                                "--with-wine64=../wine64-build"]

    # We don't need wineloader
    wine32_configure_options += ["--disable-loader"]

    # Build 64-bit Wine first.
    mkdir buildpath/"wine64-build" do
      system buildpath/"configure", *wine_configure_options, *wine64_configure_options, *compiler_options
      system "make"
    end

    # Now build 32-on-64 Wine.
    mkdir buildpath/"wine32-build" do
      system buildpath/"configure", *wine_configure_options, *wine32_configure_options, *compiler_options
      system "make"
    end

    # Install both builds.
    cd "wine64-build" do
      system "make", "install-lib"
    end

    cd "wine32-build" do
      system "make", "install-lib"
    end
  end

  def post_install
    # Homebrew replaces wine's rpath names with absolute paths, we need to change them back to @rpath relative paths
    # Wine relies on @rpath names to cause dlopen to always return the first dylib with that name loaded into
    # the process rather than the actual dylib found using rpath lookup.
    Dir["#{lib}/wine/{x86_64-unix,x86_32on64-unix}/*.so"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib)
      chmod 0444, dylib
    end

    # Install wine-gecko into place
    (share/"wine"/"gecko"/"wine-gecko-2.47.2-x86").install resource("gecko-x86")
    (share/"wine"/"gecko"/"wine-gecko-2.47.2-x86_64").install resource("gecko-x86_64")
  end

  def caveats
    return unless latest_version_installed?

    "Please follow the instructions in the Game Porting Toolkit README to complete installation."
  end

  test do
    system bin/"wine64", "--version"
  end
end
