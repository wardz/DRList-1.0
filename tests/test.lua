-- Running tests from command line:
-- > cd DRList-1.0
-- > lua tests\test.lua
--
-- Running tests ingame:
-- /drlist true

local Tests = {}

if _G.loadfile then -- not running in game
    strmatch = _G.string.match
    format = _G.string.format
    debugprofilestop = _G.os.clock
    GetLocale = function() return "enUS" end
    GetBuildInfo = function() return nil, nil, nil, 80000 end -- always set this to retail
    GetSpellInfo = function() return "" end

    assert(loadfile("libs/LibStub/LibStub.lua"))()
    assert(loadfile("DRList-1.0.lua"))()
else
    SLASH_DRLIST1 = "/drlist"
    SlashCmdList["DRLIST"] = function(msg)
        Tests:RunAll(msg == "true" and true or false)
    end
end

local DRList = LibStub("DRList-1.0")

-- This test is optional and can only be ran ingame
local function SpellListChecks()
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
end

function Tests:TriggerTest(func, funcName)
    local status, err = pcall(func)
    if err then
        table.insert(Tests.errors, {
            status = status,
            text = (err or "nil"):match([[\tests\(.+)]]) or err, -- remove folder path from error text if it exists
            funcName = funcName:gsub("_", "")
        })
    else
        Tests.completedTests = Tests.completedTests + 1
    end

    Tests.totalTests = Tests.totalTests + 1
    return status, err
end

function Tests:Reset()
    Tests.errors = {}
    Tests.totalTests = 0
    Tests.completedTests = 0
end

function Tests:RunAll(runSpellsCheck)
    local beginTime = debugprofilestop()
    Tests:Reset()

    for funcName, testFunc in pairs(Tests) do
        if string.find(funcName, "_") then -- only run functions prefixed with "_"
            Tests:BeforeTest()
            Tests:TriggerTest(testFunc, funcName)
        end
    end

    -- This test can only be ran ingame
    if runSpellsCheck then
        Tests:BeforeTest()
        Tests:TriggerTest(SpellListChecks, "SpellListChecks")
    end

    local timeUsed = debugprofilestop() - beginTime
    print(string.format("Completed %d/%d tests in %.2f seconds.", Tests.completedTests, Tests.totalTests, timeUsed))

    for i = 1, #Tests.errors do
        local err = Tests.errors[i]
        print(string.format("|cFFFF0000[%s]: %s|r", err.funcName, err.text))
    end

    if next(Tests.errors) and _G.os and _G.os.exit then
        os.exit(1)
    end
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------

function Tests:BeforeTest()
    -- We always run a test for retail first, then we can run tests for classic later
    -- by setting DRList.gameExpansion = "classic" in the test function itself
    DRList.gameExpansion = "retail"
end

function Tests:_CanLoadLib()
    assert(LibStub("DRList-1.0"))
    assert(type(LibStub("DRList-1.0").spellList) == "table")
end

function Tests:_GetsSpellList()
    assert(next(DRList.spellList))
    assert(DRList:GetSpells()[853] == "stun")
    assert(DRList:GetSpells()[339] == "root")
end

function Tests:_GetsResetTimes()
    assert(DRList:GetResetTime() == 18.4)
    assert(DRList:GetResetTime("stun") == 18.4)
    assert(DRList:GetResetTime(123) == 18.4)
    assert(DRList:GetResetTime(true) == 18.4)
    assert(DRList:GetResetTime({}) == 18.4)
    assert(DRList:GetResetTime("knockback") == 10.4)

    DRList.gameExpansion = "classic"
    assert(DRList:GetResetTime() == 19)
    assert(DRList:GetResetTime("knockback") == 19)
end

function Tests:_GetsCategoryNames()
    assert(type(DRList.categoryNames[DRList.gameExpansion].stun) == "string")
    assert(type(DRList:GetCategories().root) == "string")
    assert(type(DRList:GetCategories().knockback) == "string")

    DRList.gameExpansion = "classic"
    assert(type(DRList.categoryNames["classic"].stun) == "string")
    assert(type(DRList:GetCategories().root) == "string")
    assert(type(DRList:GetCategories().short_root) == "string")
    assert(DRList:GetCategories().knockback == nil)
end

function Tests:_GetsCategoryFromSpell()
    assert(DRList:GetCategoryBySpellID(853) == "stun")
    assert(DRList:GetCategoryBySpellID(339) == "root")
    assert(DRList:GetCategoryBySpellID(1776) == "incapacitate")
    assert(DRList:GetCategoryBySpellID(605) == "disorient")

    assert(DRList:GetCategoryBySpellID(123) == nil)
    assert(DRList:GetCategoryBySpellID("123") == nil)
    assert(DRList:GetCategoryBySpellID(true) == nil)
    assert(DRList:GetCategoryBySpellID({}) == nil)
    assert(DRList:GetCategoryBySpellID() == nil)
end

function Tests:_GetsLocalizations()
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
    assert(DRList:GetCategoryLocalization("knockback") == nil)
end

function Tests:_ChecksCategoriesPvE()
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
    assert(DRList:IsPvECategory("stun") == false)
    assert(DRList:IsPvECategory("taunt") == false)
end

function Tests:_GetsNextDR()
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
end

function Tests:_IteratesSpells()
    local ran = false
    for k, v in DRList:IterateSpellsByCategory("root") do
        assert(type(k) == "number")
        assert(v == "root")
        ran = true
    end

    assert(ran)
end

if _G.loadfile then
    Tests:RunAll()
end
