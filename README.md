# homebrew-wine
This repository contains wine related casks/formulas.

<br>

## casks;
- `portingkit`
- `unofficial-wineskin`
- `wine-crossover`     *(wine-7.7 [crossover-sources-22.1.1](https://media.codeweavers.com/pub/crossover/source/crossover-sources-22.1.1.tar.gz))*

## formulas
- `cx-llvm` *(22.1.1)*
- `game-porting-toolkit` *(1.0)*
- `wine-crossover@22` *(22.1.1)*

### To install the `wine-crossover` package;
```
brew install --cask --no-quarantine gcenx/wine/wine-crossover
```
This will install `Wine Crossover` into `/Applications` and function as the official brew cask would.\
The `--no-quarantine` flag is required so brew skips the quarantine flag that causes Gatekeeper to believe `Wine Crossover` is broken.

## Don't open issues on Winehq!;
`wine-crossover` is not an upstream package.
