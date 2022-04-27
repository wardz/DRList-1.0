# DRList (Diminishing Returns Database)

World of Warcraft library for providing diminishing returns categorization.

## Contents

- [About](#about)
- [Install Manually](#manual-install)
- [Install With BigWigsMods Packager](#usage-with-bigwigmods-packager)
- [Upgrading From DRData to DRList](#upgrading-from-drdata-to-drlist)
- [Example usage for Retail/TBC](https://github.com/wardz/DRList-1.0/wiki/Example-Usage-Retail)
- [Example usage for Classic](https://github.com/wardz/DRList-1.0/wiki/Example-Usage-Classic)
- [API Documentation](https://wardz.github.io/DRList-1.0/)
- [List of DR categories](https://github.com/wardz/DRList-1.0/wiki/DR-Categories)

### About

Library that contains (hopefully) the most up to date [diminishing returns](https://wow.gamepedia.com/Diminishing_returns) categorization. This is purely the diminishing return data itself with API's to determine if a spell has a diminishing return, if it diminishes in PvE and the category it diminishes in.

**This addon is a rewrite of [DRData-1.0](https://www.wowace.com/projects/drdata-1-0) which is no longer maintained.**
DRList is updated to seamlessly support all World of Warcraft live clients. (Classic, TBC, Mainline, eventually Wotlk)

### Manual Install

Requires [LibStub](https://www.curseforge.com/wow/addons/libstub).

- [Curseforge Downloads](https://wow.curseforge.com/projects/drlist-1-0)
- [Github Downloads](https://github.com/wardz/DRList-1.0/releases)

1. Unzip file into `WoW/Interface/AddOns/YourAddon/Libs/`.
2. Add an entry for `Libs/DRList-1.0/DRList-1.0.xml` into your addon's [TOC](https://wowpedia.fandom.com/wiki/TOC_format) file.

### Usage with BigWigsMods Packager

Requires [LibStub](https://www.curseforge.com/wow/addons/libstub).

1. Add an entry for `Libs/DRList-1.0/DRList-1.0.xml` into your addon's [TOC](https://wowpedia.fandom.com/wiki/TOC_format) file.
2. Add this repository to the packager's externals list, preferably with the latest tag.

**/YourAddonProject/.pkgmeta:**

```yaml
externals:
  Libs/DRList-1.0:
    url: https://github.com/wardz/DRList-1.0
    tag: latest
```

### Upgrading from DRData to DRList

- Any occurances of `DRData` must be renamed to `DRList`.
- There's a few new DR categories added. Depending on how your addon is coded you might need to account for this. ([Category list](https://github.com/wardz/DRList-1.0/wiki/DR-Categories))
- For accessing data tables **directly** you will now need to add the current expansion as an extra table property.
  E.g `DRData.categoryNames` to `DRList.categoryNames.retail` or `DRList.categoryNames.classic`. The only exception for this is
  the spell list table.
- Calls to `IterateProviders` must be replaced with [IterateSpellsByCategory](https://github.com/wardz/DRList-1.0/blob/620a36fc1ccbfb399ead1b874b9a0fc648113b9c/DRList-1.0/DRList-1.0.lua#L347-L356).

### Contributing

- [Submit a pull request.](https://github.com/wardz/DRList-1.0/pulls)
  I recommend creating a symlink between your WoW addons folder and DRList-1.0 when forking.
  You should preferably load the addon using the toc file instead of xml so everything gets loaded for testing.
- [Report bugs or missing spells.](https://github.com/wardz/drlist-1.0/issues)
- [Help translate.](https://www.curseforge.com/wow/addons/drlist-1-0/localization)

### License

Copyright (C) 2022 Wardz | [MIT License](https://opensource.org/licenses/mit-license.php).
