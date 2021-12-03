std = "lua51"
max_line_length = 250

exclude_files = {
    "libs/",
    ".luacheckrc",
}

ignore = {
    "212/self",  -- Unused argument
    "213", -- Unused loop variable
}

-- Force error on 'print' in code to ensure we never forget to remove debug statements on release
not_globals = { "print" }

globals = {
    "SimpleTesting",
    "SLASH_DRLIST1",
    "debugprofilestop",
    "format",
    "_G",
    "GetBuildInfo",
    "GetLocale",
    "GetSpellInfo",
    "LibStub",
    "strmatch",
    "SlashCmdList",
    "WOW_PROJECT_ID",
    "WOW_PROJECT_MAINLINE",
    "WOW_PROJECT_CLASSIC",
    "WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
}
