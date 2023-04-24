# homebrew-wine
This repository contains wine related casks/formulas.

<br>

## casks;
- `portingkit`
- `unofficial-wineskin`
- `wine-crossover`     *(wine-7.7 [crossover-sources-22.1.0](https://media.codeweavers.com/pub/crossover/source/crossover-sources-22.1.0.tar.gz))*

### To install the `wine-crossover` package;
```
brew install --cask --no-quarantine gcenx/wine/wine-crossover
```
This will install `Wine Crossover` into `/Applications` and function as the official brew cask would.\
The `--no-quarantine` flag is required so brew skips the quarantine flag that causes Gatekeeper to believe `Wine Crossover` is broken.

## wine-gecko is included;
`wine-gecko`is included within these custom `wine-crossover` package(s), usually wine(64/32on64) will download and then install .msi packages into each and every wineprefix increasing prefix size instead the "shared" packages are used to reduce prefix size.

## Don't open issues on Winehq!;
`wine-crossover` is not an upstream package.\
As I’m not too familiar with brew any issues with the provided casks/formulas should be reported here.
