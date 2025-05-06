# DRList-1.0 (Diminishing Returns Database)

World of Warcraft library for providing player diminishing returns categorization.

## Contents

- [About](#about)
- [Install Manually](#manual-install)
- [Install With BigWigsMods Packager](#usage-with-bigwigsmods-packager)
- [Upgrading From DRData to DRList](#upgrading-from-drdata-to-drlist)
- [Example usage](https://github.com/wardz/DRList-1.0/wiki/Example-Usage)
- [API Documentation](https://wardz.github.io/DRList-1.0/)

### About

Library that contains (hopefully) the most up to date [diminishing returns](https://warcraft.wiki.gg/wiki/Diminishing_returns) categorization. This is purely the diminishing return data itself with API's to determine if a spellID has a diminishing return, if it diminishes in PvE and the category it diminishes in. You will have to keep track of actual DR timers yourself.

**This addon is a rewrite of [DRData-1.0](https://www.wowace.com/projects/drdata-1-0) by Adirelle which is no longer maintained.**
DRList is updated to seamlessly support all World of Warcraft clients. (Classic, TBC, Wotlk, Cataclysm, MoP, Retail)

___

### Manual Install

Requires [LibStub](https://www.curseforge.com/wow/addons/libstub).

- [Curseforge Downloads](https://wow.curseforge.com/projects/drlist-1-0)
- [Github Downloads](https://github.com/wardz/DRList-1.0/releases)

1. Unzip file into `WoW/Interface/AddOns/YourAddon/Libs/`.
2. Add an entry for `Libs/DRList-1.0/DRList-1.0.xml` into your addon's [TOC](https://warcraft.wiki.gg/wiki/TOC_format) file.

### Usage with BigWigsMods Packager

Requires [LibStub](https://www.curseforge.com/wow/addons/libstub).

1. Add an entry for `Libs/DRList-1.0/DRList-1.0.xml` into your addon's [TOC](https://warcraft.wiki.gg/wiki/TOC_format) file.
2. Add this repository to the packager's externals list:

_**.pkgmeta file:**_

```yaml
externals:
  Libs/DRList-1.0: https://github.com/wardz/DRList-1.0
```

### Upgrading from DRData to DRList

- Any references to `DRData` must be changed to `DRList`. Easiest is to just change the LibStub call so your local DRData variable points to DRList.
- When referencing data tables **directly**, you must now include the current expansion as an additional table property.
  E.g `DRData.categoryNames` to `DRList.categoryNames.retail`. The only exception for this is the spell list table.
- Calls to `Lib:IterateProviders()` must be replaced with [Lib:IterateSpellsByCategory()](https://wardz.github.io/DRList-1.0/#Lib:IterateSpellsByCategory) as providers are now obsolete.
- `Lib:GetSpellCategory()` now has an optional [second return value](https://wardz.github.io/DRList-1.0/#Lib:GetCategoryBySpellID) for spells with shared DRs.
  - `Lib.spellList[spellID]` now returns a `table` for spells with shared DRs instead of a `string`.

### Contributing

- [Submit a pull request.](https://github.com/wardz/DRList-1.0/pulls)
- [Report bugs or missing spells.](https://github.com/wardz/drlist-1.0/issues)
- [Help translate.](https://www.curseforge.com/wow/addons/drlist-1-0/localization)

### License

Copyright (C) 2025 Wardz | [MIT License](https://opensource.org/licenses/mit-license.php).
