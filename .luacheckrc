std = "lua51"
max_line_length = false

exclude_files = {
    "libs/",
    ".luacheckrc"
}

not_globals = { "print" } -- just to help not forgetting to remove debug print statements

ignore = {
    "212/self",  -- Unused argument
    "213", -- Unused loop variable
}

globals = {
    "_G",
    "LibStub",
    "GetLocale",
    "GetBuildInfo",
    "format",
    "strmatch",
    "WOW_PROJECT_MAINLINE",
    "WOW_PROJECT_CLASSIC",
    "WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
    "WOW_PROJECT_ID",

    -- Tests
    "SimpleTesting",
    "SLASH_DRLIST1",
    "SlashCmdList",
    "GetSpellInfo",
    "debugprofilestop",
}
