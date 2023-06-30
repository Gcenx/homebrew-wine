# The 22.1.1 tarball contains an empty sources/freetype directory, which confuses the default CurlDownloadStrategy.
# A custom strategy also allows us to restrict extraction to just wine.
class TarballDownloadStrategy < CurlDownloadStrategy
  def stage
    ohai "Staging #{cached_location} in #{pwd}"
    system "tar", "-xf", cached_location, "--include=sources/wine/*", "--strip-components=2"
    yield
  end
end

class WineCrossoverAT22 < Formula
  desc "Run Windows applications without a copy of Microsoft Window"
  homepage "https://www.winehq.org/"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-22.1.1.tar.gz", using: TarballDownloadStrategy
  sha256 "cdfe282ce33788bd4f969c8bfb1d3e2de060eb6c296fa1c3cdf4e4690b8b1831"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cx-llvm" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "molten-vk"
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

  patch :DATA

  def install
    # Bypass the Homebrew shims to build native binaries with the dedicated compiler.
    # (PE binaries will be built with mingw32-gcc.)
    compiler = Formula["cx-llvm"]
    compiler_options = ["CC=#{compiler.bin}/clang",
                        "CXX=#{compiler.bin}/clang++"]

    # We also need to tell the linker to add Homebrew to the rpath stack.
    ENV.append "LDFLAGS", "-lSystem"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"

    # Common compiler flags for both Mach-O and PE binaries.
    ENV.append_to_cflags "-O2 -Wno-deprecated-declarations -Wno-incompatible-pointer-types"
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
                              "--with-vulkan",
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
    (share/"wine"/"gecko"/"wine-gecko-2.47.2-x86").install resource("gecko-x86")
    (share/"wine"/"gecko"/"wine-gecko-2.47.2-x86_64").install resource("gecko-x86_64")
  end

  test do
    system bin/"wine64", "--version"
  end
end

__END__
diff --git a/include/distversion.h b/wine/include/distversion.h
new file mode 100644
index 00000000..4a76c3f5
--- /dev/null
+++ b/include/distversion.h
@@ -0,0 +1,12 @@
+/* ---------------------------------------------------------------
+ *   distversion.c
+ *
+ * Copyright 2013, CodeWeavers, Inc.
+ *
+ * Information from DISTVERSION which needs to find
+ * its way into the wine tree.
+ * --------------------------------------------------------------- */
+
+#define WINDEBUG_WHAT_HAPPENED_MESSAGE "This can be caused by a problem in the program or a deficiency in Wine. You may want to check <a href=\"http://www.codeweavers.com/compatibility/\">http://www.codeweavers.com/compatibility/</a> for tips about running this application."
+
+#define WINDEBUG_USER_SUGGESTION_MESSAGE "If this problem is not present under Windows and has not been reported yet, you can save the detailed information to a file using the \"Save As\" button, then <a href=\"http://www.codeweavers.com/support/tickets/enter/\">file a bug report</a> and attach that file to the report."
