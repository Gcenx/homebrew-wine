# homebrew-wine

Currently contains a single cask `wine-crossover` built from CrossOver19.0.1 source.
Wine-Crossover is within an app bundle like Winehq releases, this doesn't require XQuartz.


### Prerequisites;
Remove `winetricks` if installed as this includes a patched version of winetricks.
Install the following `cabextract` `p7zip` & `unrar`

### macOS Catalan additional requirement;
wine32on64 requires SIP to be disabled or you will receive the following error
```
wine: failed to initialize: failed to set the LDT entry for 32-bit code segment

```
