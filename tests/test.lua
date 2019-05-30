-- Running tests from command line:
-- > cd DRList-1.0
-- > lua tests\test.lua
--
-- Running tests ingame:
-- /drlist

if loadfile then
    assert(loadfile("tests/engine.lua"))()
end

local Tests = SimpleTesting:New("DRList-1.0")
if not Tests:IsInGame() then
    strmatch = string.match
    GetLocale = function() return "enUS" end
    GetBuildInfo = function() return nil, nil, nil, 80000 end -- always set this to retail
    GetSpellInfo = function() return "" end

    assert(loadfile("libs/LibStub/LibStub.lua"))()
    assert(loadfile("DRList-1.0.lua"))()
end

local DRList = LibStub("DRList-1.0")

function Tests:BeforeEach()
    -- We always run a test for retail first, then we can run tests for classic later
    -- by setting DRList.gameExpansion = "classic" in the test function itself
    DRList.gameExpansion = "retail"
end

Tests:It("Loads lib", function()
    assert(LibStub("DRList-1.0"))
    assert(type(LibStub("DRList-1.0").spellList) == "table")
end)

Tests:It("GetsSpellList", function()
    assert(next(DRList.spellList))
    assert(DRList:GetSpells()[853] == "stun")
    assert(DRList:GetSpells()[339] == "root")
end)

Tests:It("GetsResetTimes", function()
    assert(DRList:GetResetTime() == 18.4)
    assert(DRList:GetResetTime("stun") == 18.4)
    assert(DRList:GetResetTime(123) == 18.4)
    assert(DRList:GetResetTime(true) == 18.4)
    assert(DRList:GetResetTime({}) == 18.4)
    assert(DRList:GetResetTime("knockback") == 10.4)

    DRList.gameExpansion = "classic"
    assert(DRList:GetResetTime() == 19)
    assert(DRList:GetResetTime("knockback") == 19)
end)

Tests:It("GetsCategoryNames", function()
    assert(type(DRList.categoryNames[DRList.gameExpansion].stun) == "string")
    assert(type(DRList:GetCategories().root) == "string")
    assert(type(DRList:GetCategories().knockback) == "string")

    DRList.gameExpansion = "classic"
    assert(type(DRList.categoryNames["classic"].stun) == "string")
    assert(type(DRList:GetCategories().root) == "string")
    assert(type(DRList:GetCategories().short_root) == "string")
    assert(DRList:GetCategories().knockback == nil)
end)

Tests:It("GetsCategoryNamesPvE", function()
    assert(type(DRList:GetPvECategories().stun) == "string")
    assert(type(DRList:GetPvECategories().taunt) == "string")
    assert(DRList:GetPvECategories().disorient == nil)

    DRList.gameExpansion = "classic"
    assert(type(DRList:GetPvECategories().stun) == "string")
    assert(DRList:GetPvECategories().taunt == nil)
end)

Tests:It("GetsCategoryFromSpell", function()
    assert(DRList:GetCategoryBySpellID(853) == "stun")
    assert(DRList:GetCategoryBySpellID(339) == "root")
    assert(DRList:GetCategoryBySpellID(1776) == "incapacitate")
    -- assert(DRList:GetCategoryBySpellID(605) == "disorient")

    assert(DRList:GetCategoryBySpellID(123) == nil)
    assert(DRList:GetCategoryBySpellID("123") == nil)
    assert(DRList:GetCategoryBySpellID(true) == nil)
    assert(DRList:GetCategoryBySpellID({}) == nil)
    assert(DRList:GetCategoryBySpellID() == nil)

    -- Run same test again for classic
    if DRList.gameExpansion == "retail" then
        DRList.gameExpansion = "classic"
        -- assert(DRList:GetCategoryBySpellID(605) == "mind_control")
        Tests.tests.GetsCategoryFromSpell()
    end
end)

Tests:It("GetsLocalizations", function()
    assert(next(DRList.categoryNames))
    assert(DRList:GetCategoryLocalization("abc") == nil)
    assert(DRList:GetCategoryLocalization(123) == nil)
    assert(DRList:GetCategoryLocalization(true) == nil)
    assert(DRList:GetCategoryLocalization({}) == nil)
    assert(DRList:GetCategoryLocalization() == nil)

    local low = string.lower
    assert(low(DRList.categoryNames[DRList.gameExpansion]["stun"]) == low(DRList.L.STUNS))
    assert(low(DRList:GetCategoryLocalization("root")) == low(DRList.L.ROOTS))
    assert(DRList:GetCategoryLocalization("knockback"))

    DRList.gameExpansion = "classic"
    assert(low(DRList.categoryNames[DRList.gameExpansion]["stun"]) == low(DRList.L.STUNS))
    assert(low(DRList:GetCategoryLocalization("short_root")) == low(DRList.L.SHORT_ROOTS))
    assert(low(DRList:GetCategoryLocalization("mind_control")) == low(DRList.L.MIND_CONTROL))
    assert(DRList:GetCategoryLocalization("knockback") == nil)
end)

Tests:It("ChecksCategoriesPvE", function()
    assert(next(DRList.categoriesPvE))
    assert(DRList:IsPvECategory("stun") == true)
    assert(DRList:IsPvECategory("taunt") == true)
    assert(DRList:IsPvECategory("disorient") == false)

    assert(DRList:IsPvECategory() == false)
    assert(DRList:IsPvECategory({}) == false)
    assert(DRList:IsPvECategory("") == false)
    assert(DRList:IsPvECategory(853) == false)
    assert(DRList:IsPvECategory(true) == false)

    DRList.gameExpansion = "classic"
    assert(DRList:IsPvECategory("stun") == true)
    assert(DRList:IsPvECategory("taunt") == false)
end)

Tests:It("GetsNextDR", function()
    assert(DRList:GetNextDR(1, "stun") == 0.50)
    assert(DRList:GetNextDR(2, "stun") == 0.25)
    assert(DRList:GetNextDR(3, "stun") == 0)
    assert(DRList:GetNextDR(10, "stun") == 0)

    assert(DRList:GetNextDR(1, "abc") == 0)
    assert(DRList:GetNextDR(1, 123) == 0)
    assert(DRList:GetNextDR(1, true) == 0)
    assert(DRList:GetNextDR("1", "stun") == 0)
    assert(DRList:GetNextDR(true, "stun") == 0)
    assert(DRList:GetNextDR({}, "stun") == 0)
    assert(DRList:GetNextDR(true) == 0)
    assert(DRList:GetNextDR() == 0)
    assert(DRList:GetNextDR(-1, {}) == 0)
    assert(DRList:GetNextDR(1, "short_stun") == 0)

    assert(DRList:GetNextDR(1, "disorient") == 0.50)
    assert(DRList:GetNextDR(2, "disorient") == 0.25)

    assert(DRList:GetNextDR(0, "knockback") == 0)
    assert(DRList:GetNextDR(1, "knockback") == 0)

    assert(DRList:GetNextDR(1, "taunt") ==  0.65)
    assert(DRList:GetNextDR(2, "taunt") ==  0.42)
    assert(DRList:GetNextDR(3, "taunt") ==  0.27)
    assert(DRList:GetNextDR(4, "taunt") ==  0)
    assert(DRList:GetNextDR(10, "taunt") ==  0)

    DRList.gameExpansion = "classic"
    assert(DRList:GetNextDR(1, "taunt") ==  0)
    assert(DRList:GetNextDR(1, "short_stun") == 0.50)
    assert(DRList:GetNextDR(2, "short_root") == 0.25)
    assert(DRList:GetNextDR(1, "mind_control") == 0.50)
end)

Tests:It("IterateSpellsByCategory", function()
    local ran = false
    for spellID, category in DRList:IterateSpellsByCategory("root") do
        assert(type(spellID) == "number")
        assert(category == "root")
        ran = true
    end
    assert(ran)
    ran = false

    for category, localizedCategory in pairs(DRList:GetPvECategories()) do
        for spellID, cat in DRList:IterateSpellsByCategory(category) do -- luacheck: ignore
            assert(type(spellID) == "number")
            assert(category == cat)
            ran = true
            break
        end
    end
    assert(ran)

    if DRList.gameExpansion == "retail" then
        DRList.gameExpansion = "classic"
        Tests.tests.IterateSpellsByCategory()
    end
end)

-- This test is only ran ingame
Tests:It("Verifies spell list", function()
    DRList.gameExpansion = select(4, GetBuildInfo()) < 80000 and "classic" or "retail"
    local success = true
    local err = ""

    for spellID, category in pairs(DRList.spellList) do
        if type(spellID) ~= "number" or not GetSpellInfo(spellID) then
            success = false
            err = err .. "|cFFFF0000Invalid spell:|r " .. spellID .. "\n"
        end

        if type(category) ~= "string" or not DRList.categoryNames[DRList.gameExpansion][category] then
            success = false
            err = err .. "|cFFFF0000Invalid category:|r " .. category .. "\n"
        end
    end

    if not success then
        return error(err)
    end

    return success
end, true)

if Tests:IsInGame() then
    SLASH_DRLIST1 = "/drlist"
    SlashCmdList["DRLIST"] = function()
        Tests:RunAll()
        DRList.gameExpansion = select(4, GetBuildInfo()) < 80000 and "classic" or "retail"
    end
else
    Tests:RunAll()
end
