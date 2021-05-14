# homebrew-wine
This repository contains wine related casks/formulas.

![Downloads count](https://img.shields.io/github/downloads/gcenx/homebrew-wine/total.svg)

## Currently contains;
- `gcenx-wine-stable`
- `gcenx-wine-devel`
- `gcenx-wine-staging`
- `wine-crossover` *(wine-5.0)*
- `wine-crossover@19.0.2` *(wine-4.12.1)*
- `unofficial-wineskin`
- `portingkit`

### gcenx-wine-stable/devel/staging?;
As brew doesn't have the ability to override casks/formulas the names were prepended with gcenx-

### Requirements;
gcenx-wine-* packages don't have additional requirements unless the X11 display driver is required, otherwise all required dependencies are already included.

## macOS Catalan and later (Intel systems);
32Bit support was removed however, `wine-crossover` was built from [crossover-sources-20.0.2](https://media.codeweavers.com/pub/crossover/source/crossover-sources-20.0.2.tar.gz) & `wine-crossover@19.0.2` was built from [crossover-sources-19.0.2](https://media.codeweavers.com/pub/crossover/source/crossover-sources-19.0.2.tar.gz) *plus additinal patches*, these contains `wine32on64` this allows running 32Bit windows binaries.\
macOS Catalina 10.15.4 or later work, macOS Catalina 10.15.0 to 10.15.3 require SIP to be disabled.

### Apple Silicon (Rosetta2);
While `wine-crossover` does function some older titles like Diablo 2 will need to be ran via cnc-ddraw, glide or force Windowed mode, other games like Total Annihilation will require DxWnd to launch.  Newer titles like Fallout NV/Skyrim LE should run without issue.

### How to install using brew;
First add my tap
```
brew tap gcenx/wine
```

##### Next select the desired wine package to be installed, for an example let's select `wine-crossover`
```
brew install --cask --no-quarantine wine-crossover
```
This will install `Wine Crossover` into `/Applications` and function as the official brew cask would (but _doesn't_ require XQuartz)\
The `--no-quarantine` flag is required so brew skips adding the quarantine mark causing gatekeeper prompts this breaks wine packages on macOS Catalina and later.

#### How to manually install;
Download the desired package from [releases](https://github.com/Gcenx/macOS_Wine_builds/releases) unpack, now move the `Wine *` bundle to `/Applications` and use as you would a Winehq release.

## Build environment configuration;
- _CodeWeavers custom llvm/clang-8_ (wine32on64 sources only)
- XCode 11.3.1
- MacOSX10.14.sdk (Patched in 32Bit support)
- Mingw-w64-8.0.2
- Mingw-gcc-11.1.0 (Reverted [gcc-mirror/gcc@`4f48f31`](https://github.com/gcc-mirror/gcc/commit/4f48f31bbfc10697296ff004a92614d9249ca784))
- Mingw-w64-binutils 2.36.1
- Dependencies are build using macports with [macports-wine](https://github.com/Gcenx/macports-wine)
- XQuartz-2.8.1 was used for X11
- Build system includes fixes for [Bug 49199](https://bugs.winehq.org/show_bug.cgi?id=49199)

## Configure Options used;
```
--disable-option-checking \
--disable-tests \
--without-alsa \
--without-capi \
--with-cms \
--with-coreaudio \
--without-cups \
--without-curses \
--without-dbus \
--with-faudio \
--without-fontconfig \
--with-freetype \
--with-gcrypt \
--with-gettext \
--without-gettextpo \
--without-gphoto \
--with-gnutls \
--without-gsm \
--without-gssapi \
--with-gstreamer \
--without-hal \
--without-inotify \
--with-jpeg \
--with-jxrlib \
--without-krb5 \
--with-ldap \
--with-mingw \
--with-mpg123 \
--without-netapi \
--with-openal \
--with-opencl \
--with-opengl  \
--without-oss \
--with-pcap \
--with-png \
--with-pthread \
--without-pulse \
--without-quicktime \
--without-sane \
--with-sdl \
--with-tiff \
--without-udev \
--with-unwind \
--with-usb \
--without-v4l2 \
--without-vkd3d \
--without-xattr \
--with-xml \
--with-xslt \
--with-osmesa \
--with-xcomposite \
--with-xcursor \
--with-xfixes \
--with-xinerama \
--with-xinput \
--with-xinput2 \
--with-xrandr \
--with-xrender \
--with-xshape \
--with-xshm \
--with-xxf86vm \
--with-x \
--x-include=/opt/X11/include \
--x-lib=/opt/X11/lib
```

## gecko & mono are included;
`wine-gecko` & `wine-mono` are included within these custom `Wine-*` packages, usually wine(64/32on64) will download and then install .msi packages into each and every wineprefix increasing prefix size instead the "shared" packages are used to reduce prefix size.

## Don't open wine issues here!;
Wine bugs/regressions need to be reported via [Winehq Bugzilla](https://bugs.winehq.org/)\
This only applies to `gcenx-wine-*` packages and not `wine-crossover` & `wine-crossover@19.0.2`\
Packaging related issues should be opened here.\
As I’m not too familiar with brew any issues with the provided casks/formulas should be reported.
