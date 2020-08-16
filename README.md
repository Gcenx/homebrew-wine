# homebrew-wine

## Currently contains;
- `gcenx-wine-stable`
- `gcenx-wine-devel`
- `gcenx-wine-staging`
- `wine-crossover` 
- `unofficial-wineskin`
- `portingkit`

### gcenx-wine-stable/devel/staging?;
Currently Winehq is not providing newer wine packages for macOS starting from Wine-5.8, unless there are bugs I usually compile close to release for [Unofficial Wineskin](https://github.com/Gcenx/WineskinServer), it takes a couple extra steps to also package the builds into Winehq like .app bundles.

### Requirments;
The provded gcenx-wine- packages don't have have additinal requirments unless the X11 display drver is required, otherwise all required dependencies are already included within the bundle.

### macOS Catalan;
32Bit support was removed from macOS Catalina however `wine-crossover` was built from crossover-wine-19.0.1, this contains `wine32on64` and allows running 32Bit windows bininaries however it has additinal requirments unless your system is running 10.15.4 or greater.

### How to install using brew;
First add my tap
```
brew tap gcenx/wine
```

##### Next select the desired wine package to be installed, for an example I'll select `wine-crossover`
```
brew cask install --no-quarantine wine-crossover
```
This will install `Wine Crossover` into `/Applications` and function as the official brew cask would (but _doesn't_ require XQuartz)

#### How to manually install;
Download the desired package from [releases](https://github.com/Gcenx/macOS_Wine_builds/releases) unpack, now move the `Wine *` bundle to `/Applications` and use as you would a Winehq release.

## Build environment configuration;
- CodeWeavers custom llvm/clang-8
- MacOSX10.13.sdk (with QuickTime.framework from MacOSX10.11.sdk)
- Mingw-w64-9.3.0
- Mingw-w64-binutils with [Proton patches](https://github.com/GloriousEggroll/proton-ge-custom/tree/proton-ge-5-MF/mingw-w64-patches)
- Dependencies are build using macports with [macports-wine](https://github.com/Gcenx/macports-wine)
- XQuartz-2.7.7 was used for X11
- Build system includes fixes for [Bug 49199](https://bugs.winehq.org/show_bug.cgi?id=49199)

## Configure Options used;
```
--disable-option-checking \
--disable-tests \
--without-alsa \
--without-capi \
--with-cms \
--with-coreaudio \
--with-cups \
--with-curses \
--without-dbus \
--with-faudio \
--without-fontconfig \
--with-freetype \
--with-gcrypt \
--without-gettext \
--without-gettextpo \
--without-gphoto \
--with-glu \
--with-gnutls \
--without-gsm \
--without-gssapi \
--with-gstreamer \
--without-gtk3 \
--without-hal \
--without-inotify \
--with-jpeg \
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
--without-va  \
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
`wine-gecko` & `wine-mono` are included within these custom `Wine-*` packages, usually wine(64) will download and then install .msi packages into each and every wineprefix increasing prefix size instead the "shared" packages were used to help reduce prefix size

## Don't open issues for wine issues!
Any wine bugs or regressions report those to [Winehq Bugzilla](https://bugs.winehq.org/), for package related issues related to missing dylib or a dylib refusing to load on OS X 10.9 then open an issue so it can be resolved.

### Found this helpful?
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/gcenx?locale.x=en_US)
