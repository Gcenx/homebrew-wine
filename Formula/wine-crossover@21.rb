class WineCrossoverAT21 < Formula
  desc "Run Windows applications without a copy of Microsoft Window"
  homepage "https://www.winehq.org/"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-21.2.0.tar.gz"
  sha256 "138ee0d3c2232b6ef28d50a3efd43c2565e3b813838c6a4e32c8c5c024b5d17f"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/wine-crossover@21-21.2.0"
    sha256 big_sur: "d9cbd9643c2f062d9d41b5c8c8cf469c22bd84426704f3c893ce68e082e7b583"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cx-llvm" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "faudio"
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "molten-vk" if MacOS.version >= :catalina
  depends_on "mpg123"
  depends_on "sdl2"

  uses_from_macos "flex" => :build

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.tar.xz"
    sha256 "b4476706a4c3f23461da98bed34f355ff623c5d2bb2da1e2fa0c6a310bc33014"
  end

  patch :DATA

  def install
    ENV["CFLAGS"] = "-g -O2"
    ENV["CROSSCFLAGS"] = "-g -O2"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.14"

    cd "wine" do
      mkdir "wine-64-build" do
        system "../configure", "--prefix=#{prefix}",
                               "--enable-win64",
                               "--disable-winedbg",
                               "--disable-tests",
                               "--without-alsa",
                               "--without-capi",
                               "--without-cms",
                               "--with-coreaudio",
                               "--with-cups",
                               "--without-dbus",
                               "--with-faudio",
                               "--without-fontconfig",
                               "--with-freetype",
                               "--with-gettext",
                               "--without-gettextpo",
                               "--without-gphoto",
                               "--with-gnutls",
                               "--without-gsm",
                               "--without-gssapi",
                               "--without-gstreamer",
                               "--without-inotify",
                               "--without-krb5",
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
                               "--without-quicktime",
                               "--without-sane",
                               "--with-sdl",
                               "--without-udev",
                               "--with-unwind",
                               "--without-usb",
                               "--without-v4l2",
                               "--without-vkd3d",
                               "--with-vulkan",
                               "--without-x",
                               "CC=#{Formula["cx-llvm"].opt_bin/"clang"}",
                               "CXX=#{Formula["cx-llvm"].opt_bin/"clang++"}",
                               "LD=/usr/bin/ld"
        system "make", "install-lib"
      end

      mkdir "wine-32-build" do
        system "../configure", "--prefix=#{prefix}",
                               "--enable-win32on64",
                               "--with-wine64=../wine-64-build",
                               "--disable-winedbg",
                               "--disable-tests",
                               "--without-alsa",
                               "--without-capi",
                               "--without-cms",
                               "--with-coreaudio",
                               "--with-cups",
                               "--without-dbus",
                               "--with-faudio",
                               "--without-fontconfig",
                               "--with-freetype",
                               "--with-gettext",
                               "--without-gettextpo",
                               "--without-gphoto",
                               "--with-gnutls",
                               "--without-gsm",
                               "--without-gssapi",
                               "--without-gstreamer",
                               "--without-inotify",
                               "--without-krb5",
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
                               "--without-quicktime",
                               "--without-sane",
                               "--with-sdl",
                               "--without-udev",
                               "--with-unwind",
                               "--without-usb",
                               "--without-v4l2",
                               "--without-vkd3d",
                               "--without-vulkan",
                               "--without-x",
                               "CC=#{Formula["cx-llvm"].opt_bin/"clang"}",
                               "CXX=#{Formula["cx-llvm"].opt_bin/"clang++"}",
                               "LD=/usr/bin/ld"
        system "make", "install-lib"
      end
    end
  end

  def post_install
    (share/"wine"/"gecko"/"wine-gecko-2.47.2-x86_64").install resource("gecko-x86_64")
  end

  test do
    system bin/"wine64", "--version"
  end
end

__END__
diff --git a/wine/include/distversion.h b/wine/include/distversion.h
new file mode 100644
index 00000000..4a76c3f5
--- /dev/null
+++ b/wine/include/distversion.h
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
