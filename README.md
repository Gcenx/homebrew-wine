# homebrew-wine
This repository contains wine related casks/formulas.\
![Downloads count](https://img.shields.io/github/downloads/gcenx/homebrew-wine/total.svg)

## Currently contains;
- `wine-crossover` *(wine-5.0)*
- `wine-crossover@19.0.2` *(wine-4.12.1)*
- `unofficial-wineskin`
- `portingkit`

### Directly install the desired wine-crossover package to be installed,
```
brew install --cask --no-quarantine gcenx/wine/wine-crossover
```
This will install `Wine Crossover` into `/Applications` and function as the official brew cask would (but _doesn't_ require XQuartz)\
The `--no-quarantine` flag is required so brew skips adding the quarantine mark causing gatekeeper prompts this breaks wine packages on macOS Catalina and later.

#### How to manually install;
Download the desired package from [releases](https://github.com/Gcenx/homebrew-wine/releases) unpack, now move the `Wine *` bundle to `/Applications` and use as you would a Winehq release. _*Not recommended*_

## macOS Catalina and later (Intel systems);
32Bit support was removed however, `wine-crossover` was built from [crossover-sources-20.0.2](https://media.codeweavers.com/pub/crossover/source/crossover-sources-20.0.2.tar.gz) & `wine-crossover@19.0.2` was built from [crossover-sources-19.0.2](https://media.codeweavers.com/pub/crossover/source/crossover-sources-19.0.2.tar.gz) *plus additinal patches*, these contains `wine32on64` this allows running 32Bit windows binaries.\
macOS Catalina 10.15.4 or later work, macOS Catalina 10.15.0 to 10.15.3 require SIP to be disabled.

### Apple Silicon (Rosetta2);
While `wine-crossover` does function some older titles like Diablo 2 will need to be ran via cnc-ddraw, glide or force Windowed mode, other games like Total Annihilation will require DxWnd to launch.  Newer titles like Fallout NV/Skyrim LE should run without issue.

## Build environment configuration;
- CodeWeavers custom llvm/clang-8 _(Required for wine32on64)_
- XCode _v11.3.1_
- MacOSX10.14.sdk (Patched in 32Bit support)
- Mingw-w64 _v9.0.0_
- Mingw-gcc _v11.2.0_
- Mingw-binutils _v2.37_
- Build system includes fixes for [Bug 49199](https://bugs.winehq.org/show_bug.cgi?id=49199)

## gecko & mono are included;
`wine-gecko` & `wine-mono` are included within these custom `wine-crossover` packages, usually wine(64/32on64) will download and then install .msi packages into each and every wineprefix increasing prefix size instead the "shared" packages are used to reduce prefix size.

## Don't open issues on Winehq!;
`wine-crossover` & `wine-crossover@19.0.2` are not upstream packages.\
As I’m not too familiar with brew any issues with the provided casks/formulas should be reported.
