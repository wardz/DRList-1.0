std = "lua51"
max_line_length = 250

exclude_files = {
    "DRList-1.0/libs/",
    ".luacheckrc",
}

ignore = {
    "212/self", -- Unused argument 'self'
    "213", -- Unused loop variables
}

-- Force error on 'print' in code to ensure we never forget to remove debug statements on release
not_globals = { "print" }

globals = {
    "SimpleTesting",
    "SLASH_DRLIST1",
    "debugprofilestop",
    "format",
    "_G",
    "GetLocale",
    "GetSpellInfo",
    "LibStub",
    "strmatch",
    "SlashCmdList",
    "WOW_PROJECT_ID",
    "WOW_PROJECT_MAINLINE",
    "WOW_PROJECT_CLASSIC",
    "WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
    "WOW_PROJECT_WRATH_CLASSIC",
    "WOW_PROJECT_CATACLYSM_CLASSIC",
}
