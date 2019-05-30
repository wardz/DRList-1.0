# DRList (Diminishing Returns Database)
Library that contains (hopefully) the most up to date [diminishing returns](https://wow.gamepedia.com/Diminishing_returns) categorization. This is purely the diminishing return data itself with API's to determine if a spellID has a diminishing return, if it diminishes in PvE and the category it diminishes in.

[API Documentation.](https://wardz.github.io/DRList-1.0/)
  
**This addon is a fork/rewrite of [DRData-1.0.](https://www.wowace.com/projects/drdata-1-0) which seems to be abandoned.**  
Some of the main differences between *DRData* and *DRList* are:
- Spell data is updated for Retail patch 8.1.0 and Classic patch 1.13.2.
- Now on Github instead of WoWAce. This should hopefully make contributing easier for people.
- Table structure has slightly changed but if you only use the API functions there should be no conflicts. Upgrading from DRData to DRList is plug and play in most scenarios.  
  If you used to access the tables directly, you'll now need to add the current game version as an extra table property. E.g ```DRData.categoryNames``` to ```DRList.categoryNames.retail``` or ```DRList.categoryNames.classic```.  
  The only exception for this is on the spell list table.

## Install
Installing from source/master is not guaranteed to work. You should download a packaged version here instead:
- [Curseforge Download](https://wow.curseforge.com/projects/drlist-1-0)  
- [Github Download](https://github.com/wardz/drlist/releases) (Choose binary)  
Unzip it into ```WoW/Interface/AddOns/YourAddon/libs``` and add an entry for it in your addon's .toc file. (See Example Usage).
You may also install it as a standalone addon by putting it directly in ```WoW/Interface/AddOns/```. This is recommended when
forking the library or creating addon packs/plugins where multiple addons use the lib.

## Example Usage
See [here](https://wardz.github.io/DRList-1.0/) for API documentation.  
**addon/addon.toc**
```
## Interface: 80100
## Title: addon
libs/DRList-1.0/libs/LibStub/LibStub.lua # Only needed if LibStub is not already included
libs/DRList-1.0/DRList-1.0.xml

addon.lua
```

**addon/addon.lua**
```lua
-- Get lib instance.
local DRList = LibStub("DRList-1.0")

-- Register a combat log event handler
local addon = CreateFrame("Frame")
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:SetScript("OnEvent", function(self, event)
    local _, eventType, _, _, _, _, _, destGUID, _, destFlags, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo()

    -- Check all debuffs found in the combat log
    if auraType == "DEBUFF" then
        -- Get the DR category or exit immediately if spell/debuff doesn't have a DR
        -- This is the unlocalized category name, used for API functions.
        local category = DRList:GetCategoryBySpellID(spellID)
        if not category or category == "knockback" then return end
        -- knockback category is experimental, you can keep it if you want but it is not that accurate.

        -- Check if unit that got Crowd Control aura is a player
        -- You might also want to check if it's hostile or not depending on your needs
        -- https://wow.gamepedia.com/UnitFlag
        local isPlayer = bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
        if not isPlayer then return end

        -- CC aura has faded or refreshed, DR starts
        if eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_REFRESH" then
            -- Store some data relative to destGUID, do your stuff, etc, then make sure to wipe it after 18s (DRList:GetResetTime())
            -- If you want to track target, focus etc you need to also keep track of every guid so that data
            -- is not overwritten or reset on target lost/switched. For static units such as arena123, you
            -- can just reset their guids on PLAYER_ENTERING_WORLD, or GROUP_ROSTER_UPDATE for party members.
            --
            -- You probably also want to track how many times the DR has been triggered for a guid so you can get
            -- the current DR status (immune, half, etc), @see DRLib:GetNextDR()
        end
    end
end)
```

## Usage with Curseforge Packager
You can ignore this section if you don't use the [Curseforge packager](https://authors.curseforge.com/knowledge-base/world-of-warcraft/527-preparing-the-packagemeta-file).
  
**addon/.pkgmeta**
```
externals:
  libs/DRList-1.0:
    url: git://github.com/wardz/DRList
    tag: latest

ignore:
  - libs/DRList-1.0/DRList-1.0.toc
  - libs/DRList-1.0/libs/LibStub # optional if LibStub already exists
```

## Contributing
- [Submit a pull request.](https://gist.github.com/Chaser324/ce0505fbed06b947d962)  
  You may run tests ingame by typing ```/drlist```.  
- [Report bugs, requests or missing spells.](https://github.com/wardz/drlist-1.0/issues)
- [Help translate.](https://wow.curseforge.com/projects/drlist-1-0/localization)

## License
[MIT License](https://opensource.org/licenses/mit-license.php).
