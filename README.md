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

### How are the wine packages built?
wine casks are built on macOS Mojave using [macports](https://www.macports.org), [macports-wine](https://github.com/Gcenx/macports-wine) & MacOSX10.13.sdk to compile the required dependencies.\
Next the wine release is compiled & the needed dependencies are added into the bundle avoiding the need for macports to be installed on the users system.

### Found this helpful?
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/gcenx?locale.x=en_US)
