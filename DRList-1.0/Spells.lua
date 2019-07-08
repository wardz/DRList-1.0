local Lib = LibStub and LibStub("DRList-1.0")

-- List of spellIDs that causes DR.
if Lib.gameExpansion == "retail" then
    Lib.spellList = {
        -- Disorients
        [207167]  = "disorient",       -- Blinding Sleet
        [207685]  = "disorient",       -- Sigil of Misery
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

        -- Incapacitates
        [217832]  = "incapacitate",    -- Imprison
        [221527]  = "incapacitate",    -- Imprison (Honor talent)
        [2637]    = "incapacitate",    -- Hibernate
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
        [710]     = "incapacitate",    -- Banish
        [6789]    = "incapacitate",    -- Mortal Coil
        [107079]  = "incapacitate",    -- Quaking Palm (Pandaren racial)
        [89637]   = "incapacitate",    -- Big Daddy (Item)
        [255228]  = "incapacitate",    -- Polymorphed (Organic Discombobulation Grenade) (Item)
        [71988]   = "incapacitate",    -- Vile Fumes (Item)

        -- Silences
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

        -- Stuns
        [210141]  = "stun",            -- Zombie Explosion
        [108194]  = "stun",            -- Asphyxiate (Unholy)
        [221562]  = "stun",            -- Asphyxiate (Blood)
        [91800]   = "stun",            -- Gnaw (Ghoul)
        [91797]   = "stun",            -- Monstrous Blow (Mutated Ghoul)
        [287254]  = "stun",            -- Dead of Winter
        [179057]  = "stun",            -- Chaos Nova
--      [213491]  = "stun",            -- Demonic Trample (Only DRs with itself once)
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

        -- Roots
        -- Note: Short roots (<= 2s) usually have no DR, e.g Thunderstruck.
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

        -- Disarms
        [209749]  = "disarm",          -- Faerie Swarm (Balance Honor Talent)
        [207777]  = "disarm",          -- Dismantle
        [233759]  = "disarm",          -- Grapple Weapon
        [236077]  = "disarm",          -- Disarm

        -- Taunts (PvE)
        [56222]   = "taunt",           -- Dark Command
        [51399]   = "taunt",           -- Death Grip
        [185245]  = "taunt",           -- Torment
        [6795]    = "taunt",           -- Growl (Druid)
        [2649]    = "taunt",           -- Growl (Hunter Pet) -- TODO: verify if DRs
        [20736]   = "taunt",           -- Distracting Shot
        [116189]  = "taunt",           -- Provoke
        [118635]  = "taunt",           -- Provoke (Black Ox Statue)
        [196727]  = "taunt",           -- Provoke (Niuzao)
        [204079]  = "taunt",           -- Final Stand
        [62124]   = "taunt",           -- Hand of Reckoning
        [17735]   = "taunt",           -- Suffering (Voidwalker)
        [355]     = "taunt",           -- Taunt
--      [36213]   = "taunt",           -- Angered Earth (Earth Elemental, has no debuff)

        -- Knockbacks (Experimental)
--      [108199]  = "knockback",        -- Gorefiend's Grasp (has no debuff)
--      [202249]  = "knockback",        -- Overrun TODO: verify
        [132469]  = "knockback",        -- Typhoon
        [102793]  = "knockback",        -- Ursol's Vortex (Warning: May only be tracked on SPELL_AURA_REFRESH afaik)
        [186387]  = "knockback",        -- Bursting Shot
        [236775]  = "knockback",        -- Hi-Explosive Trap
        [157981]  = "knockback",        -- Blast Wave
        [204263]  = "knockback",        -- Shining Force
        [51490]   = "knockback",        -- Thunderstorm
    }
else
    -- Spell list for Classic patch 1.13.2 (** Work in progress **)
    -- Note: In Classic WoW most abilities have several ranks, where each rank has a different spellID.
    -- It'd be a lot easier to use GetSpellInfo here and store spell names instead to avoid having
    -- to list an spellID for every single rank. However, for compatibility and accuracy reasons we still
    -- use spellIDs here. (Some spells have same name but different effects. It's also easy for spell names to clash with NPC spells.)
    Lib.spellList = {
        -- Controlled roots
        [339]     = "root",           -- Entangling Roots Rank 1
        [1062]    = "root",           -- Entangling Roots Rank 2
        [5195]    = "root",           -- Entangling Roots Rank 3
        [5196]    = "root",           -- Entangling Roots Rank 4
        [9852]    = "root",           -- Entangling Roots Rank 5
        [9853]    = "root",           -- Entangling Roots Rank 6
        [19306]   = "root",           -- Counterattack
        [122]     = "root",           -- Frost Nova Rank 1
        [865]     = "root",           -- Frost Nova Rank 2
        [6131]    = "root",           -- Frost Nova Rank 3
        [10230]   = "root",           -- Frost Nova rank 4
        [8377]    = "root",           -- Earthgrab (Totem)

        -- Controlled stuns
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

        -- Disarms (TODO: no idea if DRs in Classic)
        [676]     = "disarm",         -- Disarm
        [27581]   = "disarm",         -- Disarm 2
        --[15752] = "disarm",         -- Disarm (Linken's Boomerang)
        --[11879] = "disarm",         -- Disarm (Shoni's Disarming Tool)
        --[13534] = "disarm",         -- Disarm (The Shatterer)

        -- Incapacitates
        [2637]    = "incapacitate",   -- Hibernate Rank 1
        [18657]   = "incapacitate",   -- Hibernate Rank 2
        [18658]   = "incapacitate",   -- Hibernate Rank 3
        --[22570]   = "incapacitate",   -- Mangle Rank 1
        [3355]    = "incapacitate",   -- Freezing Trap Rank 1
        [14308]   = "incapacitate",   -- Freezing Trap Rank 2
        [14309]   = "incapacitate",   -- Freezing Trap Rank 3
        [19386]   = "incapacitate",   -- Wyvern Sting Rank 1
        [24132]   = "incapacitate",   -- Wyvern Sting Rank 2
        [24133]   = "incapacitate",   -- Wyvern Sting Rank 3
        [28271]   = "incapacitate",   -- Polymorph: Turtle
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

        -- Fears
        [1513]    = "fear",          -- Scare Beast Rank 1
        [14326]   = "fear",          -- Scare Beast Rank 2
        [14327]   = "fear",          -- Scare Beast Rank 3
        [8122]    = "fear",          -- Psychic Scream Rank 1
        [8124]    = "fear",          -- Psychic Scream Rank 2
        [10888]   = "fear",          -- Psychic Scream Rank 3
        [10890]   = "fear",          -- Psychic Scream Rank 4
        [2094]    = "fear",          -- Blind TODO: confirm category
        [5782]    = "fear",          -- Fear Rank 1
        [6213]    = "fear",          -- Fear Rank 2
        [6215]    = "fear",          -- Fear Rank 3
        [5484]    = "fear",          -- Howl of Terror Rank 1
        [17928]   = "fear",          -- Howl of Terror Rank 1
        [6358]    = "fear",          -- Seduction
        [5246]    = "fear",          -- Intimidating Shout

        -- Short Fears
        -- TODO: does coil only DR with itself? if so we should rename category
        [6789]    = "horror",        -- Death Coil Rank 1
        [17925]   = "horror",        -- Death Coil Rank 2
        [17926]   = "horror",        -- Death Coil Rank 2

        -- Controlled stuns
        [9005]    = "stun",         -- Pounce Rank 1
        [9823]    = "stun",         -- Pounce Rank 2
        [9827]    = "stun",         -- Pounce Rank 3
        [1833]    = "opener_stun",  -- Cheap Shot TODO: need to confirm if Pounce shares DR with Cheap Shot

        -- Random/short roots
        [19229]   = "short_root",   -- Improved Wing Clip
        [23694]   = "short_root",   -- Improved Hamstring

        -- Random/short stuns
        [16922]   = "short_stun",   -- Improved Starfire
        [19410]   = "short_stun",   -- Improved Concussive Shot
        [12355]   = "short_stun",   -- Impact
        [20170]   = "short_stun",   -- Seal of Justice Stun
        [15269]   = "short_stun",   -- Blackout
        [18093]   = "short_stun",   -- Pyroclasm
        [12798]   = "short_stun",   -- Revenge Stun
        [5530]    = "short_stun",   -- Mace Stun Effect (Mace Specilization)

        -- Silences
        -- [18469]   = "silence",      -- Counterspell - Silenced
        -- [15487]   = "silence",      -- Silence
        -- [18425]   = "silence",      -- Kick - Silenced
        -- [24259]   = "silence",      -- Spell Lock
        -- [18498]   = "silence",      -- Shield Bash - Silenced
        -- [27559]   = "silence",      -- Silence (Jagged Obsidian Shield)

        -- Spells that DRs with itself only
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

        --[[
        -- Items
        TODO: need to figure out if these cause any DRs
        [13327] = "", -- Reckless Charge
        [13099] = "", -- Net-o-Matic
        [16566] = "", -- Net-o-Matic Backfire 1
        [13138] = "", -- Net-o-Matic Backfire 2
        [1090] = "", -- Sleep
        [9159] = "", -- Sleep (Green Whelp Armor)
        [8312] = "", -- Trap
        [13181] = "", -- Gnomish Mind Control Cap

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
        [835] = "", -- Tidal Charm
        [18278] = "", -- Silence (Weapon Proc)
        [12562] = "", -- The Big One
        [15283] = "", -- Stunning Blow (Weapon Proc)
        [56] = "", -- Stun (Weapon Proc)
        [23454] = "", -- Stun 1s (Weapon Proc)
        [26108] = "", -- Glimpse of Madness
        ]]
    }
end
