# homebrew-wine
This repository contains wine related casks/formulas.\
![Downloads count](https://img.shields.io/github/downloads/gcenx/homebrew-wine/total.svg)

## Currently contains;
- `wine-stable-legacy` *(wine-7.0 without [bug 52354](https://bugs.winehq.org/show_bug.cgi?id=52354))*
- `wine-crossover`    *(wine-6.0 [crossover-sources-21.0.0](https://media.codeweavers.com/pub/crossover/source/crossover-sources-21.0.0.tar.gz))*
- `wine-crossover-20` *(wine-5.0 [crossover-sources-20.0.2](https://media.codeweavers.com/pub/crossover/source/crossover-sources-20.0.2.tar.gz))*
- `wine-crossover-19` *(wine-4.2.1 [crossover-sources-19.0.2](https://media.codeweavers.com/pub/crossover/source/crossover-sources-19.0.2.tar.gz))*
- `unofficial-wineskin`
- `portingkit`

### Install the desired wine-crossover package;
```
brew install --cask --no-quarantine gcenx/wine/wine-crossover
```
This will install `Wine Crossover` into `/Applications` and function as the official brew cask would.\
The `--no-quarantine` flag is required so brew skips the quarantine flag that causes Gatekeeper to believe `Wine Crossover` is broken.

## Build environment configuration;
- CodeWeavers custom llvm/clang-8 _(Required for wine32on64)_
- XCode _v11.3.1_
- MacOSX10.14.sdk (macOS Mojave sysroot)
- Mingw-w64 _v9.0.0_
- Mingw-gcc _v11.2.0_
- Mingw-binutils _v2.37_
- Build system includes fixes for [Bug 49199](https://bugs.winehq.org/show_bug.cgi?id=49199)

## wine-gecko is included;
`wine-gecko`is included within these custom `wine-crossover` packages, usually wine(64/32on64) will download and then install .msi packages into each and every wineprefix increasing prefix size instead the "shared" packages are used to reduce prefix size.

## Don't open issues on Winehq!;
`wine-crossover`, `wine-crossover-20` `wine-crossover-19` are not upstream packages.\
As I’m not too familiar with brew any issues with the provided casks/formulas should be reported here.
