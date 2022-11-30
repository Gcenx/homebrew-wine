class WineCrossoverAT19 < Formula
  desc "Run Windows applications without a copy of Microsoft Window"
  homepage "https://www.winehq.org/"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-19.0.2.tar.gz"
  sha256 "4647594cf21fe926e619001f49e38e9da149b0c89b0b948a0a4abce2a94dbaac"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cx-llvm" => :build
  depends_on "mingw-w64" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "faudio"
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "molten-vk" if MacOS.version >= :catalina
  depends_on "mpg123"
  depends_on "sdl2"

  uses_from_macos "flex" => :build

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi"
    sha256 "3b8a361f5d63952d21caafd74e849a774994822fb96c5922b01d554f1677643a"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi"
    sha256 "c565ea25e50ea953937d4ab01299e4306da4a556946327d253ea9b28357e4a7d"
  end

  patch :DATA

  def install
    ENV["CFLAGS"] = "-g -O2 -Wno-deprecated-declarations -Wno-format"
    ENV["CROSSCFLAGS"] = "-g -O2 -fcommon -fno-builtin-{sin,cos}{,f}"
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
                               "--with-gstreamer",
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
        system "make", "install"
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
                               "--disable-vulkan_1",
                               "--disable-winevulkan",
                               "--without-x",
                               "CC=#{Formula["cx-llvm"].opt_bin/"clang"}",
                               "CXX=#{Formula["cx-llvm"].opt_bin/"clang++"}",
                               "LD=/usr/bin/ld"
        system "make", "install"
      end
      (pkgshare/"gecko").install resource("gecko-x86")
      (pkgshare/"gecko").install resource("gecko-x86_64")
    end
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
