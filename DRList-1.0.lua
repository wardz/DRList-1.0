--[[
Name: DRList-1.0
Description: Diminishing returns database. Fork of DRData-1.0.
Website: https://wow.curseforge.com/projects/drlist-1-0
Documentation: https://wardz.github.io/DRList-1.0/
Version: @project-version@
Dependencies: LibStub
License: MIT
]]

--- DRList-1.0
-- @module DRList-1.0
local MAJOR, MINOR = "DRList-1.0", 2
local Lib = assert(LibStub, MAJOR .. " requires LibStub."):NewLibrary(MAJOR, MINOR)
if not Lib then return end -- already loaded

-------------------------------------------------------------------------------
-- *** LOCALIZATIONS ARE AUTOMATICALLY GENERATED ***
-- Please see Curseforge localization page if you'd like to help translate.
-- https://wow.curseforge.com/projects/drlist-1-0/localization
local L = {}
Lib.L = L
L["DISARMS"] = "Disarms"
L["DISORIENTS"] = "Disorients"
L["FEARS"] = "Fears"
L["HORRORS"] = "Horrors"
L["INCAPACITATES"] = "Incapacitates"
L["KNOCKBACKS"] = "Knockbacks"
L["SHORT_ROOTS"] = "Roots (short)"
L["SHORT_STUNS"] = "Stuns (short)"
L["ROOTS"] = "Roots"
L["SILENCES"] = "Silences"
L["STUNS"] = "Stuns"
L["TAUNTS"] = "Taunts"
L["OPENER_STUN"] = "Opener stun" -- Cheap Shot & Pounce
L["MIND_CONTROL"] = GetSpellInfo(605) -- TODO: mock these for unit testing
L["HIBERNATE"] =  GetSpellInfo(2637)
L["CHARGE"] = GetSpellInfo(100)
L["ENTRAPMENT"] = GetSpellInfo(19184) or GetSpellInfo(19387)
L["SCATTER_SHOT"] = GetSpellInfo(19503) or GetSpellInfo(213691)
L["FROST_SHOCK"] = GetSpellInfo(8056) or GetSpellInfo(196840)

-- luacheck: push ignore 542
local locale = GetLocale()
if locale == "deDE" then
    --@localization(locale="deDE", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "frFR" then
    --@localization(locale="frFR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "itIT" then
    --@localization(locale="itIT", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "koKR" then
    --@localization(locale="koKR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ptBR" then
    --@localization(locale="ptBR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ruRU" then
    --@localization(locale="ruRU", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esES" or locale == "esMX" then
    --@localization(locale="esES", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhCN" or locale == "zhTW" then
    --@localization(locale="zhCN", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
end
-- luacheck: pop
-------------------------------------------------------------------------------

-- Whether we're running Classic or Retail WoW
Lib.gameExpansion = select(4, GetBuildInfo()) < 80000 and "classic" or "retail"

-- How long it takes for a DR to expire
Lib.resetTimes = {
    retail = {
        ["default"] = 18.4, -- Always 18s after patch 6.1. (We add extra 0.4s to account for any latency)
        ["knockback"] = 10.4, -- Knockbacks are immediately immune and only DRs for 10s
    },

    classic = {
        ["default"] = 19.0, -- In classic this is between 15s and 20s, (first server batch tick after 15s have passed)
    },
}

-- List of DR categories, english -> localized
-- Note: unlocalized categories used for the API are always singular,
-- and localized user facing categories are always plural.
Lib.categoryNames = {
    retail = {
        ["disorient"] = L.DISORIENTS,
        ["incapacitate"] = L.INCAPACITATES,
        ["silence"] = L.SILENCES,
        ["stun"] = L.STUNS,
        ["root"] = L.ROOTS,
        ["disarm"] = L.DISARMS,
        ["taunt"] = L.TAUNTS,
        ["knockback"] = L.KNOCKBACKS,
    },

    classic = {
        -- placeholders
        ["incapacitate"] = L.INCAPACITATES,
        ["silence"] = L.SILENCES,
        ["stun"] = L.STUNS, -- controlled stun
        ["root"] = L.ROOTS, -- controlled root
        ["disarm"] = L.DISARMS,
        ["opener_stun"] = L.OPENER_STUN, -- Cheap Shot & Pounce
        ["short_stun"] = L.SHORT_STUNS, -- random proc stun, usually short
        ["short_root"] = L.SHORT_ROOTS,
        ["fear"] = L.FEARS,
        ["horror"] = L.HORRORS, -- short fears
        ["mind_control"] = L.MIND_CONTROL,
        ["scatter_shot"] = L.SCATTER_SHOT,
        ["hibernate"] = L.HIBERNATE,
        ["frost_shock"] = L.FROST_SHOCK,
        ["entrapment"] = L.ENTRAPMENT,
        ["charge"] = L.CHARGE,
    },
}

-- Categories that have DR against mobs
-- Note that only elites usually have root/taunt DR.
Lib.categoriesPvE = {
    retail = {
        ["taunt"] = L.TAUNTS,
        ["stun"] = L.STUNS,
        ["root"] = L.ROOTS,
--      ["cyclone"] = L.CYCLONE, -- TODO: verify
--      ["banish"] = L.BANISH, -- TODO: verify
    },

    classic = {
        ["stun"] = L.STUNS, -- TODO: verify, might be opener_stun aswell
    },
}

-- Successives diminished durations
Lib.diminishedDurations = {
    retail = {
        -- Decreases by 50%, immune at the 4th application
        ["default"] = { 0.50, 0.25 },
        -- Decreases by 35%, immune at the 5th application
        ["taunt"] = { 0.65, 0.42, 0.27 },
        -- Immediately immune
        ["knockback"] = {},
    },

    classic = {
        ["default"] = { 0.50, 0.25 },
    },
}

-- List of spellIDs that cause DR
-- Spells tagged "Item" are from consumables or equipment and can't be used in rated pvp. (retail)
if Lib.gameExpansion == "retail" then
    Lib.spellList = {
        -------------------------------------------------------------------------------
        -- Disorients
        -------------------------------------------------------------------------------
        [207167]  = "disorient",       -- Blinding Sleet
        [207685]  = "disorient",       -- Sigil of Misery
        [2637]    = "disorient",       -- Hibernate
        [33786]   = "disorient",       -- Cyclone
        [209753]  = "disorient",       -- Cyclone (Honor talent)
        [31661]   = "disorient",       -- Dragon's Breath
        [198909]  = "disorient",       -- Song of Chi-ji
        [202274]  = "disorient",       -- Incendiary Brew
        [105421]  = "disorient",       -- Blinding Light
        [605]     = "disorient",       -- Mind Control
        [8122]    = "disorient",       -- Psychic Scream
        [226943]  = "disorient",       -- Mind Bomb
        [2094]    = "disorient",       -- Blind
        [118699]  = "disorient",       -- Fear
        [261589]  = "disorient",       -- Seduction (Grimoire of Sacrifice)
        [6358]    = "disorient",       -- Seduction (Succubus)
        [5246]    = "disorient",       -- Intimidating Shout
        [35474]   = "disorient",       -- Drums of Panic (Item)
        [269186]  = "disorient",       -- Holographic Horror Projector (Item)
        [280062]  = "disorient",       -- Unluckydo (Item)
        [267026]  = "disorient",       -- Giant Flower (Item)
        [243576]  = "disorient",       -- Sticky Starfish (Item)

        -------------------------------------------------------------------------------
        -- Incapacitates
        -------------------------------------------------------------------------------
        [217832]  = "incapacitate",    -- Imprison
        [221527]  = "incapacitate",    -- Imprison (Honor talent)
        [99]      = "incapacitate",    -- Incapacitating Roar
        [3355]    = "incapacitate",    -- Freezing Trap
        [203337]  = "incapacitate",    -- Freezing Trap (Honor talent)
        [213691]  = "incapacitate",    -- Scatter Shot
        [118]     = "incapacitate",    -- Polymorph
        [28271]   = "incapacitate",    -- Polymorph (Turtle)
        [28272]   = "incapacitate",    -- Polymorph (Pig)
        [61025]   = "incapacitate",    -- Polymorph (Snake)
        [61305]   = "incapacitate",    -- Polymorph (Black Cat)
        [61780]   = "incapacitate",    -- Polymorph (Turkey)
        [61721]   = "incapacitate",    -- Polymorph (Rabbit)
        [126819]  = "incapacitate",    -- Polymorph (Porcupine)
        [161353]  = "incapacitate",    -- Polymorph (Polar Bear Cub)
        [161354]  = "incapacitate",    -- Polymorph (Monkey)
        [161355]  = "incapacitate",    -- Polymorph (Penguin)
        [161372]  = "incapacitate",    -- Polymorph (Peacock)
        [277787]  = "incapacitate",    -- Polymorph (Baby Direhorn)
        [277792]  = "incapacitate",    -- Polymorph (Bumblebee)
        [82691]   = "incapacitate",    -- Ring of Frost
        [115078]  = "incapacitate",    -- Paralysis
        [20066]   = "incapacitate",    -- Repentance
        [9484]    = "incapacitate",    -- Shackle Undead
        [200196]  = "incapacitate",    -- Holy Word: Chastise
        [1776]    = "incapacitate",    -- Gouge
        [6770]    = "incapacitate",    -- Sap
        [51514]   = "incapacitate",    -- Hex
        [196942]  = "incapacitate",    -- Hex (Voodoo Totem)
        [210873]  = "incapacitate",    -- Hex (Raptor)
        [211004]  = "incapacitate",    -- Hex (Spider)
        [211010]  = "incapacitate",    -- Hex (Snake)
        [211015]  = "incapacitate",    -- Hex (Cockroach)
        [269352]  = "incapacitate",    -- Hex (Skeletal Hatchling)
        [277778]  = "incapacitate",    -- Hex (Zandalari Tendonripper)
        [277784]  = "incapacitate",    -- Hex (Wicker Mongrel)
        [197214]  = "incapacitate",    -- Sundering
        [710]     = "incapacitate",    -- Banish (PvE)
        [6789]    = "incapacitate",    -- Mortal Coil
        [107079]  = "incapacitate",    -- Quaking Palm (Pandaren racial)
        [89637]   = "incapacitate",    -- Big Daddy (Item)
        [255228]  = "incapacitate",    -- Polymorphed (Organic Discombobulation Grenade) (Item)
        [71988]   = "incapacitate",    -- Vile Fumes (Item)

        -------------------------------------------------------------------------------
        -- Silences
        -------------------------------------------------------------------------------
        [47476]   = "silence",         -- Strangulate
        [204490]  = "silence",         -- Sigil of Silence
--      [78675]   = "silence",         -- Solar Beam (doesn't seem to DR)
        [202933]  = "silence",         -- Spider Sting
        [233022]  = "silence",         -- Spider Sting 2 (TODO: incorrect?)
        [217824]  = "silence",         -- Shield of Virtue
        [15487]   = "silence",         -- Silence
        [1330]    = "silence",         -- Garrote
        [43523]   = "silence",         -- Unstable Affliction Silence Effect (TODO: incorrect?)
        [196364]  = "silence",         -- Unstable Affliction Silence Effect 2

        -------------------------------------------------------------------------------
        -- Stuns
        -------------------------------------------------------------------------------
        [210141]  = "stun",            -- Zombie Explosion
        [108194]  = "stun",            -- Asphyxiate (Unholy)
        [221562]  = "stun",            -- Asphyxiate (Blood)
        [91800]   = "stun",            -- Gnaw (Ghoul)
        [91797]   = "stun",            -- Monstrous Blow (Mutated Ghoul)
        [287254]  = "stun",            -- Dead of Winter
        [179057]  = "stun",            -- Chaos Nova
--      [213491]  = "stun",            -- Demonic Trample (Only DRs with itself *once*)
        [205630]  = "stun",            -- Illidan's Grasp (Primary effect)
        [208618]  = "stun",            -- Illidan's Grasp (Secondary effect)
        [211881]  = "stun",            -- Fel Eruption
        [200166]  = "stun",            -- Metamorphosis (PvE stun effect)
        [203123]  = "stun",            -- Maim
        [163505]  = "stun",            -- Rake (Prowl)
        [5211]    = "stun",            -- Mighty Bash
        [202244]  = "stun",            -- Overrun
        [24394]   = "stun",            -- Intimidation
        [119381]  = "stun",            -- Leg Sweep
        [202346]  = "stun",            -- Double Barrel
        [853]     = "stun",            -- Hammer of Justice
        [64044]   = "stun",            -- Psychic Horror
        [200200]  = "stun",            -- Holy Word: Chastise Censure
        [1833]    = "stun",            -- Cheap Shot
        [408]     = "stun",            -- Kidney Shot
        [199804]  = "stun",            -- Between the Eyes
        [118905]  = "stun",            -- Static Charge (Capacitor Totem)
        [118345]  = "stun",            -- Pulverize (Primal Earth Elemental)
        [204437]  = "stun",            -- Lightning Lasso
        [89766]   = "stun",            -- Axe Toss
        [171017]  = "stun",            -- Meteor Strike (Infernal)
        [171018]  = "stun",            -- Meteor Strike (Abyssal)
--      [22703]   = "stun",            -- Infernal Awakening (doesn't seem to DR)
        [30283]   = "stun",            -- Shadowfury
        [46968]   = "stun",            -- Shockwave
        [132168]  = "stun",            -- Shockwave (Protection)
        [145047]  = "stun",            -- Shockwave (Proving Grounds PvE)
        [132169]  = "stun",            -- Storm Bolt
        [199085]  = "stun",            -- Warpath
--      [213688]  = "stun",            -- Fel Cleave (doesn't seem to DR)
        [20549]   = "stun",            -- War Stomp (Tauren)
        [255723]  = "stun",            -- Bull Rush (Highmountain Tauren)
        [287712]  = "stun",            -- Haymaker (Kul Tiran)
        [280061]  = "stun",            -- Brainsmasher Brew (Item)
        [245638]  = "stun",            -- Thick Shell (Item)

        -------------------------------------------------------------------------------
        -- Roots
        -- Note: Short roots (<= 2s) usually have no DR, e.g Thunderstruck (199045).
        -------------------------------------------------------------------------------
        [204085]  = "root",            -- Deathchill (Chains of Ice)
        [233395]  = "root",            -- Deathchill (Remorseless Winter)
        [339]     = "root",            -- Entangling Roots
        [170855]  = "root",            -- Entangling Roots (Nature's Grasp)
--      [45334]   = "root",            -- Immobilized (Wild Charge, doesn't seem to DR)
        [102359]  = "root",            -- Mass Entanglement
        [117526]  = "root",            -- Binding Shot
        [162480]  = "root",            -- Steel Trap
--      [190927]  = "root_harpoon",    -- Harpoon (TODO: check if DRs with itself)
        [212638]  = "root",            -- Tracker's Net
        [201158]  = "root",            -- Super Sticky Tar
        [122]     = "root",            -- Frost Nova
        [33395]   = "root",            -- Freeze
        [198121]  = "root",            -- Frostbite
        [220107]  = "root",            -- Frostbite (Water Elemental? needs testing)
        [233582]  = "root",            -- Entrenched in Flame
        [116706]  = "root",            -- Disable
        [64695]   = "root",            -- Earthgrab (Totem effect)
        [39965]   = "root",            -- Frost Grenade (Item)
        [75148]   = "root",            -- Embersilk Net (Item)
        [55536]   = "root",            -- Frostweave Net (Item)
        [268966]  = "root",            -- Hooked Deep Sea Net (Item)
        [270399]  = "root",            -- Unleashed Roots (Item)
        [270196]  = "root",            -- Chains of Light (Item)
        [267024]  = "root",            -- Stranglevines (Item)

        -------------------------------------------------------------------------------
        -- Disarms
        -------------------------------------------------------------------------------
        [209749]  = "disarm",          -- Faerie Swarm (Balance Honor Talent)
        [207777]  = "disarm",          -- Dismantle
        [233759]  = "disarm",          -- Grapple Weapon
        [236077]  = "disarm",          -- Disarm
        [236236]  = "disarm",          -- Disarm (Protection) TODO: incorrect?

        -------------------------------------------------------------------------------
        -- Taunts (PvE)
        -------------------------------------------------------------------------------
        [56222]   = "taunt",           -- Dark Command
        [51399]   = "taunt",           -- Death Grip
        [185245]  = "taunt",           -- Torment
        [6795]    = "taunt",           -- Growl (Druid)
        [2649]    = "taunt",           -- Growl (Hunter Pet)
        [20736]   = "taunt",           -- Distracting Shot
        [116189]  = "taunt",           -- Provoke
        [118635]  = "taunt",           -- Provoke (Black Ox Statue)
        [196727]  = "taunt",           -- Provoke (Niuzao)
        [204079]  = "taunt",           -- Final Stand
        [62124]   = "taunt",           -- Hand of Reckoning
        [17735]   = "taunt",           -- Suffering (Voidwalker)
        [355]     = "taunt",           -- Taunt
--      [36213]   = "taunt",           -- Angered Earth (Earth Elemental, has no debuff)

        -------------------------------------------------------------------------------
        -- Knockbacks (Experimental)
        -- Warning:
        -- * Only multi target knockbacks have a DR.
        -- * These may only be tracked on first SPELL_AURA_APPLIED.
        -- * Most spell IDs below are untested.
        -- * DR duration for knockbacks are 10s instead of 18s and is immediately immune after first DR.
        -------------------------------------------------------------------------------
--      [108199]  = "knockback",        -- Gorefiend's Grasp (has no debuff)
--      [202249]  = "knockback",        -- Overrun TODO: needs verification
        [132469]  = "knockback",        -- Typhoon
        [102793]  = "knockback",        -- Ursol's Vortex (Warning: May only be tracked on SPELL_AURA_REFRESH afaik)
        [186387]  = "knockback",        -- Bursting Shot
        [236775]  = "knockback",        -- Hi-Explosive Trap
        [157981]  = "knockback",        -- Blast Wave
--      [116844]  = "knockback",        -- Ring of Peace (has no debuff)
        [204263]  = "knockback",        -- Shining Force
        [51490]   = "knockback",        -- Thunderstorm
    }
else
    -- Spell list for Classic patch 1.13.x.
    -- Note: In Classic WoW most abilities have several ranks, where each rank has a different spellID.
    -- It'd be a lot easier to use GetSpellInfo here and store spell names instead to avoid having
    -- to list an spellID for every single rank. However, for compatibility and accuracy reasons we still
    -- use spellIDs here. (Some spells have same name but different effects. It's also easy for spell names to clash with NPC spells.)
    Lib.spellList = {
        -- NO SPELLIDS OR CATEGORIES ARE VERIFIED SO FAR FOR CLASSIC
        -- THESE ARE ONLY PLACEHOLDERS
        [339]     = "root",           -- Entangling Roots Rank 1
        [1062]    = "root",           -- Entangling Roots Rank 2
        [5195]    = "root",           -- Entangling Roots Rank 3
        [5196]    = "root",           -- Entangling Roots Rank 4
        [9852]    = "root",           -- Entangling Roots Rank 5
        [9853]    = "root",           -- Entangling Roots Rank 6
        [19306]   = "root",           -- Counterattack
        [19229]   = "root",           -- Improved Wing Clip
        [122]     = "root",           -- Frost Nova Rank 1
        [865]     = "root",           -- Frost Nova Rank 2
        [6131]    = "root",           -- Frost Nova Rank 3
        [10230]   = "root",           -- Frost Nova rank 4
        [8377]    = "root",           -- Earthgrab (Totem)

        [5211]    = "stun",           -- Bash Rank 1
        [6798]    = "stun",           -- Bash Rank 2
        [8983]    = "stun",           -- Bash Rank 3
        [24394]   = "stun",           -- Intimidation
        [853]     = "stun",           -- Hammer of Justice Rank 1
        [5588]    = "stun",           -- Hammer of Justice Rank 2
        [5589]    = "stun",           -- Hammer of Justice Rank 3
        [10308]   = "stun",           -- Hammer of Justice Rank 4
        [22703]   = "stun",           -- Inferno Effect (Summon Infernal)
        [408]     = "stun",           -- Kidney Shot Rank 1
        [8643]    = "stun",           -- Kidney Shot Rank 2
        [12809]   = "stun",           -- Concussion Blow
        [20253]   = "stun",           -- Intercept Stun Rank 1
        [20614]   = "stun",           -- Intercept Stun Rank 2
        [20615]   = "stun",           -- Intercept Stun Rank 3
        [20549]   = "stun",           -- War Stomp (Racial) TODO: confirm category

        [676]     = "disarm",         -- Disarm

        [2637]    = "incapacitate",   -- Hibernate Rank 1
        [18657]   = "incapacitate",   -- Hibernate Rank 2
        [18658]   = "incapacitate",   -- Hibernate Rank 3
        [3355]    = "incapacitate",   -- Freezing Trap Rank 1
        [14308]   = "incapacitate",   -- Freezing Trap Rank 2
        [14309]   = "incapacitate",   -- Freezing Trap Rank 3
        [19386]   = "incapacitate",   -- Wyvern Sting Rank 1
        [24132]   = "incapacitate",   -- Wyvern Sting Rank 2
        [24133]   = "incapacitate",   -- Wyvern Sting Rank 3
        [28271]   = "incapacitate",   -- Polymorph: Turtle
        [28270]   = "incapacitate",   -- Polymorph: Cow
        [28272]   = "incapacitate",   -- Polymorph: Pig
        [118]     = "incapacitate",   -- Polymorph Rank 1
        [12824]   = "incapacitate",   -- Polymorph Rank 2
        [12825]   = "incapacitate",   -- Polymorph Rank 3
        [12826]   = "incapacitate",   -- Polymorph Rank 4
        [20066]   = "incapacitate",   -- Repentance
        [1776]    = "incapacitate",   -- Gouge Rank 1
        [1777]    = "incapacitate",   -- Gouge Rank 2
        [8629]    = "incapacitate",   -- Gouge Rank 3
        [11285]   = "incapacitate",   -- Gouge Rank 4
        [11286]   = "incapacitate",   -- Gouge Rank 5
        [6770]    = "incapacitate",   -- Sap Rank 1
        [2070]    = "incapacitate",   -- Sap Rank 2
        [11297]   = "incapacitate",   -- Sap Rank 3

        [1513]    = "fear",          -- Scare Beast Rank 1
        [14326]   = "fear",          -- Scare Beast Rank 2
        [14327]   = "fear",          -- Scare Beast Rank 3
        [8122]    = "fear",          -- Psychic Scream Rank 1
        [8124]    = "fear",          -- Psychic Scream Rank 2
        [10888]   = "fear",          -- Psychic Scream Rank 3
        [10890]   = "fear",          -- Psychic Scream Rank 4
        [2094]    = "fear",          -- Blind
        [5782]    = "fear",          -- Fear Rank 1
        [6213]    = "fear",          -- Fear Rank 2
        [6215]    = "fear",          -- Fear Rank 3
        [5484]    = "fear",          -- Howl of Terror Rank 1
        [17928]   = "fear",          -- Howl of Terror Rank 1
        [6358]    = "fear",          -- Seduction
        [5246]    = "fear",          -- Intimidating Shout

        [6789]    = "horror",        -- Death Coil Rank 1
        [17925]   = "horror",        -- Death Coil Rank 2
        [17926]   = "horror",        -- Death Coil Rank 2

        [9005]    = "opener_stun",   -- Pounce Rank 1
        [9823]    = "opener_stun",   -- Pounce Rank 2
        [9827]    = "opener_stun",   -- Pounce Rank 3
        [1833]    = "opener_stun",   -- Cheap Shot

        [23694]   = "short_root",   -- Improved Hamstring

        [16922]   = "short_stun",   -- Improved Starfire
        [19410]   = "short_stun",   -- Improved Concussive Shot
        [12355]   = "short_stun",   -- Impact
        [20170]   = "short_stun",   -- Seal of Justice Stun
        [15269]   = "short_stun",   -- Blackout
        [18093]   = "short_stun",   -- Pyroclasm
        [12798]   = "short_stun",   -- Revenge Stun
        [5530]    = "short_stun",   -- Mace Stun Effect (Mace Specilization)

        [18469]   = "silence",      -- Counterspell - Silenced
        [15487]   = "silence",      -- Silence
        [18425]   = "silence",      -- Kick - Silenced
        [24259]   = "silence",      -- Spell Lock
        [18498]   = "silence",      -- Shield Bash - Silenced

        --[19675] = "feral_charge",   -- Feral Charge
        [19185]   = "entrapment",     -- Entrapment
        [19503]   = "scatter_shot",   -- Scatter Shot
        [605]     = "mind_control",   -- Mind Control Rank 1
        [10911]   = "mind_control",   -- Mind Control Rank 2
        [10912]   = "mind_control",   -- Mind Control Rank 3
        [7922]    = "charge",         -- Charge Stun
        [8056]    = "frost_shock",    -- Frost Shock Rank 1
        [8058]    = "frost_shock",    -- Frost Shock Rank 2
        [10472]   = "frost_shock",    -- Frost Shock Rank 3
        [10473]   = "frost_shock",    -- Frost Shock Rank 4

        --[[ TODO: need to figure out if these cause any DRs, same with procs from gear/weapons
        [13327] = "", -- Reckless Charge
        [16566] = "", -- Net-o-Matic
        [1090] = "", -- Sleep
        [8312] = "", -- Trap

        [5134] = "", -- Flash Bomb Fear
        [19821] = "", -- Arcane Bomb Silence

        [4068] = "", -- Iron Grenade
        [19769] = "", -- Thorium Grenade
        [13808] = "", -- M73 Frag Grenade
        [4069] = "", -- Big Iron Bomb
        [12543] = "", -- Hi-Explosive Bomb
        [4064] = "", -- Rough Copper Bomb
        [12421] = "", -- Mithril Frag Bomb
        [19784] = "", -- Dark Iron Bomb
        [4067] = "", -- Big Bronze Bomb
        [4066] = "", -- Small Bronze Bomb
        [4065] = "", -- Large Copper Bomb
        [13237] = "", -- Goblin Mortar
        [835] = "", -- Tidal Charm]]
    }
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

--- Get table of all spells that DRs.
-- Key is the spellID, and value is the unlocalized DR category.
-- @see IterateSpellsByCategory
-- @treturn table {number=string}
function Lib:GetSpells()
    return Lib.spellList
end

--- Get table of all DR categories.
-- Key is unlocalized name used for API functions, value is localized name used for UI.
-- @treturn table {string=string}
function Lib:GetCategories()
    return Lib.categoryNames[Lib.gameExpansion]
end

--- Get table of all categories that DRs in PvE only.
-- Key is unlocalized name used for API functions, value is localized name used for UI.
-- Tip: you can combine :GetPvECategories() and :IterateSpellsByCategory() to get spellIDs only for PvE aswell.
-- @treturn table {string=string}
function Lib:GetPvECategories()
    return Lib.categoriesPvE[Lib.gameExpansion]
end

--- Get constant for how long a DR lasts.
-- @tparam[opt="default"] string category Unlocalized category name
-- @treturn number
function Lib:GetResetTime(category)
    return Lib.resetTimes[Lib.gameExpansion][category or "default"] or Lib.resetTimes[Lib.gameExpansion].default
end

--- Get unlocalized DR category by spell ID.
-- @tparam number spellID
-- @treturn ?string|nil The category name.
function Lib:GetCategoryBySpellID(spellID)
    return Lib.spellList[spellID]
end

--- Get localized category from unlocalized category name, case sensitive.
-- @tparam string category Unlocalized category name
-- @treturn ?string|nil The localized category name.
function Lib:GetCategoryLocalization(category)
    return Lib.categoryNames[Lib.gameExpansion][category]
end

--- Check if a category has DR against mobs.
-- Note that this is only for mobs, player pets have DR on all categories.
-- Also taunt, root & cyclone only have DR against special mobs.
-- See UnitClassification() and UnitIsQuestBoss().
-- @tparam string category Unlocalized category name
-- @treturn bool
function Lib:IsPvECategory(category)
    return Lib.categoriesPvE[Lib.gameExpansion][category] and true or false -- make sure bool is always returned here
end

--- Get next successive diminished duration
-- @tparam number diminished How many times the DR has been applied so far
-- @tparam[opt="default"] string category Unlocalized category name
-- @usage local reduction = DRList:GetNextDR(1) -- returns 0.50, half duration on debuff
-- @treturn number DR percentage in decimals. Returns 0 if max DR is reached or arguments are invalid.
function Lib:GetNextDR(diminished, category)
    local durations = Lib.diminishedDurations[Lib.gameExpansion][category or "default"]
    if not durations and Lib.categoryNames[Lib.gameExpansion][category] then
        -- Redirect to default when "stun", "root" etc is passed
        durations = Lib.diminishedDurations[Lib.gameExpansion]["default"]
    end

    return durations and durations[diminished] or 0
end

do
    local next = _G.next

    local function CategoryIterator(category, index)
        local newCat
        repeat
            index, newCat = next(Lib.spellList, index)
            if index and newCat == category then
                return index, category
            end
        until not index
    end

    --- Iterate through the spells of a given category.
    -- @tparam string category Unlocalized category name
    -- @usage for spellID in DRList:IterateSpellsByCategory("root") do print(spellID) end
    -- @warning Slow function, do not use for combat related stuff unless you cache results.
    -- @return Iterator function
    function Lib:IterateSpellsByCategory(category)
        assert(Lib.categoryNames[Lib.gameExpansion][category], "invalid category")
        return CategoryIterator, category
    end
end

-- keep same API as DRData-1.0 for easier transitions
Lib.GetCategoryName = Lib.GetCategoryLocalization
Lib.IsPVE = Lib.IsPvECategory
Lib.NextDR = Lib.GetNextDR
Lib.GetSpellCategory = Lib.GetCategoryBySpellID
Lib.IterateSpells = Lib.IterateSpellsByCategory
Lib.RESET_TIME = Lib.resetTimes[Lib.gameExpansion].default
Lib.spells = Lib.spellList
Lib.pveDR = Lib.categoriesPvE
