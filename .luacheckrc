std = "lua51"
max_line_length = false

exclude_files = {
    "libs/",
    ".luacheckrc"
}

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

    -- Tests
    "SLASH_DRLIST1",
    "SlashCmdList",
    "GetSpellInfo",
    "debugprofilestop",
}
