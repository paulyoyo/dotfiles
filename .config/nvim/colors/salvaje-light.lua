-- colors/salvaje-light.lua
-- Salvaje colorscheme — LIGHT variant from the same 5 anchors.
-- Keys keep their semantic role from the dark version (snow=primary fg,
-- black=canvas, etc.); values are inverted for a light bg. All the
-- downstream hi() calls cascade automatically.

  -- Palette (light-mode values, same keys as salvaje.lua)
  local p = {
    -- Anchors, remapped for light bg
    lilac      = "#6B3D9E", -- Deep Lilac darkened for text/accents on white
    wisteria   = "#9B69BB", -- Wisteria darkened for readability on light
    gold       = "#A08600", -- ochre (raw #EAD82F is invisible on white text)
    snow       = "#060100", -- primary FOREGROUND (was bg in dark) → near-black
    black      = "#F7F7F5", -- canvas BACKGROUND (was fg in dark) → bright snow
    -- Derived, darkened
    rose       = "#B23B54",
    sage       = "#5C8F42",
    teal       = "#427F87",
    lilac_grey = "#E8DFF0", -- light lilac tint (selections, subtle bg)
    bg1        = "#EFECF3", -- float/cursorline bg (lightest lilac tint)
    bright_lilac = "#8D5FC0",
    bright_rose  = "#96253C",
    bright_sage  = "#4A7A35",
    bright_gold  = "#8A7300",
    bright_teal  = "#33646A",
    bright_wisteria = "#7F52A0",
    -- Neutrals
    grey_0 = "#E5E1EB", -- darker panel (slightly deeper than bg1)
    grey_1 = "#DDD3E6", -- lilac_grey alias variant
    grey_2 = "#C4B4D0", -- non-text markers
    grey_3 = "#8E7BA0", -- line numbers
    grey_4 = "#6E5D82", -- comments / inactive fg (readable on light)
    soft_white = "#3A2E48", -- delimiter / dim contrast
    none = "NONE",
  }

  -- Reset
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.background = "light"
  vim.g.colors_name = "salvaje-light"
  vim.o.termguicolors = true

  local hi = function(group, spec)
    vim.api.nvim_set_hl(0, group, spec)
  end

  -- ── Base editor ────────────────────────────────────────────────
  hi("Normal",       { fg = p.snow, bg = p.black })
  hi("NormalFloat",  { fg = p.snow, bg = p.bg1 })
  hi("FloatBorder",  { fg = p.lilac, bg = p.bg1 })
  hi("FloatTitle",   { fg = p.gold, bg = p.bg1, bold = true })
  hi("NormalNC",     { fg = p.snow, bg = p.black })
  hi("SignColumn",   { fg = p.grey_4, bg = p.black })
  hi("FoldColumn",   { fg = p.grey_4, bg = p.black })
  hi("EndOfBuffer",  { fg = p.black, bg = p.black })
  hi("VertSplit",    { fg = p.lilac_grey, bg = p.black })
  hi("WinSeparator", { fg = p.lilac_grey, bg = p.black })
  hi("Folded",       { fg = p.grey_4, bg = p.grey_0 })
  hi("LineNr",       { fg = p.grey_3, bg = p.black })
  hi("CursorLine",   { bg = p.grey_0 })
  hi("CursorLineNr", { fg = p.gold, bg = p.grey_0, bold = true })
  hi("CursorColumn", { bg = p.grey_0 })
  hi("ColorColumn",  { bg = p.grey_0 })
  hi("MatchParen",   { fg = p.gold, bg = p.lilac_grey, bold = true })
  hi("Visual",       { bg = p.lilac_grey })
  hi("VisualNOS",    { bg = p.lilac_grey })
  hi("Search",       { fg = p.black, bg = p.gold })
  hi("IncSearch",    { fg = p.black, bg = p.bright_gold })
  hi("CurSearch",    { fg = p.black, bg = p.bright_gold })
  hi("Substitute",   { fg = p.black, bg = p.rose })
  -- NonText is the fallback snacks uses for gitignored files in the
  -- explorer. Keeping it at grey_2 (#3D2B4F) made those files invisible
  -- in sunlight. Bumped to grey_4 (#BAA8C7) for readability.
  hi("NonText",      { fg = p.grey_4 })
  hi("Whitespace",   { fg = p.grey_2 })
  hi("SpecialKey",   { fg = p.grey_3 })
  hi("Conceal",      { fg = p.grey_4 })
  hi("Directory",    { fg = p.wisteria, bold = true })
  hi("Title",        { fg = p.gold, bold = true })
  hi("ErrorMsg",     { fg = p.rose, bold = true })
  hi("WarningMsg",   { fg = p.gold })
  hi("MoreMsg",      { fg = p.sage })
  hi("Question",     { fg = p.sage })
  hi("ModeMsg",      { fg = p.wisteria, bold = true })
  hi("Pmenu",        { fg = p.snow, bg = p.bg1 })
  hi("PmenuSel",     { fg = p.black, bg = p.wisteria, bold = true })
  hi("PmenuSbar",    { bg = p.grey_0 })
  hi("PmenuThumb",   { bg = p.lilac })
  hi("WildMenu",     { fg = p.black, bg = p.gold })
  hi("TabLine",      { fg = p.grey_4, bg = p.grey_0 })
  hi("TabLineFill",  { bg = p.black })
  hi("TabLineSel",   { fg = p.black, bg = p.wisteria, bold = true })
  hi("StatusLine",   { fg = p.snow, bg = p.lilac_grey })
  hi("StatusLineNC", { fg = p.grey_4, bg = p.grey_0 })

  -- ── Syntax (legacy groups — treesitter inherits from these) ────
  hi("Comment",      { fg = p.grey_4, italic = true })
  hi("Constant",     { fg = p.rose })
  hi("String",       { fg = p.sage })
  hi("Character",    { fg = p.sage })
  hi("Number",       { fg = p.bright_gold })
  hi("Float",        { fg = p.bright_gold })
  hi("Boolean",      { fg = p.rose, bold = true })
  hi("Identifier",   { fg = p.wisteria })
  hi("Function",     { fg = p.gold })
  hi("Statement",    { fg = p.lilac, bold = true })
  hi("Conditional",  { fg = p.lilac, italic = true })
  hi("Repeat",       { fg = p.lilac, italic = true })
  hi("Label",        { fg = p.bright_lilac })
  hi("Operator",     { fg = p.teal })
  hi("Keyword",      { fg = p.lilac, italic = true })
  hi("Exception",    { fg = p.rose, bold = true })
  hi("PreProc",      { fg = p.bright_teal })
  hi("Include",      { fg = p.bright_teal })
  hi("Define",       { fg = p.bright_teal })
  hi("Macro",        { fg = p.bright_teal })
  hi("PreCondit",    { fg = p.bright_teal })
  hi("Type",         { fg = p.gold, italic = true })
  hi("StorageClass", { fg = p.rose })
  hi("Structure",    { fg = p.gold })
  hi("Typedef",      { fg = p.gold })
  hi("Special",      { fg = p.bright_wisteria })
  hi("SpecialChar",  { fg = p.bright_wisteria })
  hi("Tag",          { fg = p.wisteria })
  hi("Delimiter",    { fg = p.soft_white })
  hi("SpecialComment", { fg = p.grey_4, italic = true, bold = true })
  hi("Debug",        { fg = p.rose })
  hi("Underlined",   { fg = p.wisteria, underline = true })
  hi("Error",        { fg = p.rose, bold = true })
  hi("Todo",         { fg = p.gold, bg = p.lilac_grey, bold = true })

  -- ── Treesitter ─────────────────────────────────────────────────
  hi("@variable",          { fg = p.snow })
  hi("@variable.builtin",  { fg = p.rose, italic = true })
  hi("@variable.parameter",{ fg = p.bright_wisteria, italic = true })
  hi("@variable.member",   { fg = p.bright_teal })
  hi("@constant",          { fg = p.rose })
  hi("@constant.builtin",  { fg = p.rose, bold = true })
  hi("@constant.macro",    { fg = p.bright_teal })
  hi("@string",            { fg = p.sage })
  hi("@string.escape",     { fg = p.bright_wisteria, bold = true })
  hi("@string.special",    { fg = p.bright_wisteria })
  hi("@string.regexp",     { fg = p.bright_wisteria })
  hi("@character",         { fg = p.sage })
  hi("@number",            { fg = p.bright_gold })
  hi("@boolean",           { fg = p.rose, bold = true })
  hi("@float",             { fg = p.bright_gold })
  hi("@function",          { fg = p.gold })
  hi("@function.builtin",  { fg = p.gold, italic = true })
  hi("@function.call",     { fg = p.gold })
  hi("@function.macro",    { fg = p.bright_teal })
  hi("@function.method",   { fg = p.gold })
  hi("@method",            { fg = p.gold })
  hi("@method.call",       { fg = p.gold })
  hi("@constructor",       { fg = p.bright_lilac, bold = true })
  hi("@parameter",         { fg = p.bright_wisteria, italic = true })
  hi("@keyword",           { fg = p.lilac, italic = true })
  hi("@keyword.function",  { fg = p.lilac, italic = true })
  hi("@keyword.operator",  { fg = p.lilac, italic = true })
  hi("@keyword.return",    { fg = p.rose, italic = true, bold = true })
  hi("@keyword.import",    { fg = p.bright_teal, italic = true })
  hi("@keyword.export",    { fg = p.bright_teal, italic = true })
  hi("@conditional",       { fg = p.lilac, italic = true })
  hi("@repeat",            { fg = p.lilac, italic = true })
  hi("@label",             { fg = p.bright_lilac })
  hi("@operator",          { fg = p.teal })
  hi("@exception",         { fg = p.rose, bold = true })
  hi("@type",              { fg = p.gold, italic = true })
  hi("@type.builtin",      { fg = p.gold, italic = true })
  hi("@type.definition",   { fg = p.gold, italic = true, bold = true })
  hi("@type.qualifier",    { fg = p.bright_teal, italic = true })
  hi("@structure",         { fg = p.gold })
  hi("@namespace",         { fg = p.wisteria })
  hi("@module",            { fg = p.wisteria })
  hi("@include",           { fg = p.bright_teal, italic = true })
  hi("@preproc",           { fg = p.bright_teal })
  hi("@punctuation.delimiter",{ fg = p.soft_white })
  hi("@punctuation.bracket",  { fg = p.soft_white })
  hi("@punctuation.special",  { fg = p.bright_wisteria })
  hi("@comment",           { fg = p.grey_4, italic = true })
  hi("@comment.error",     { fg = p.rose, bold = true })
  hi("@comment.warning",   { fg = p.gold, bold = true })
  hi("@comment.todo",      { fg = p.gold, bg = p.lilac_grey, bold = true })
  hi("@comment.note",      { fg = p.teal, bold = true })
  hi("@tag",               { fg = p.lilac, bold = true })
  hi("@tag.attribute",     { fg = p.bright_wisteria, italic = true })
  hi("@tag.delimiter",     { fg = p.soft_white })
  hi("@text.emphasis",     { italic = true })
  hi("@text.strong",       { bold = true })
  hi("@text.underline",    { underline = true })
  hi("@text.strike",       { strikethrough = true })
  hi("@text.title",        { fg = p.gold, bold = true })
  hi("@text.literal",      { fg = p.sage })
  hi("@text.uri",          { fg = p.wisteria, underline = true })
  hi("@text.reference",    { fg = p.bright_wisteria })
  hi("@text.todo",         { fg = p.gold, bg = p.lilac_grey, bold = true })
  hi("@text.note",         { fg = p.teal, bold = true })
  hi("@text.warning",      { fg = p.gold, bold = true })
  hi("@text.danger",       { fg = p.rose, bold = true })

  -- ── LSP semantic tokens ────────────────────────────────────────
  hi("@lsp.type.class",         { fg = p.gold, italic = true })
  hi("@lsp.type.interface",     { fg = p.bright_gold, italic = true })
  hi("@lsp.type.enum",          { fg = p.bright_lilac })
  hi("@lsp.type.enumMember",    { fg = p.rose })
  hi("@lsp.type.function",      { fg = p.gold })
  hi("@lsp.type.method",        { fg = p.gold })
  hi("@lsp.type.namespace",     { fg = p.wisteria })
  hi("@lsp.type.parameter",     { fg = p.bright_wisteria, italic = true })
  hi("@lsp.type.property",      { fg = p.bright_teal })
  hi("@lsp.type.struct",        { fg = p.gold })
  hi("@lsp.type.type",          { fg = p.gold, italic = true })
  hi("@lsp.type.variable",      { fg = p.snow })
  hi("@lsp.type.keyword",       { fg = p.lilac, italic = true })
  hi("@lsp.type.string",        { fg = p.sage })
  hi("@lsp.type.number",        { fg = p.bright_gold })
  hi("@lsp.type.macro",         { fg = p.bright_teal })
  hi("@lsp.mod.readonly",       { italic = true })
  hi("@lsp.mod.deprecated",     { strikethrough = true })

  -- ── Diagnostics ────────────────────────────────────────────────
  hi("DiagnosticError",        { fg = p.rose })
  hi("DiagnosticWarn",         { fg = p.gold })
  hi("DiagnosticInfo",         { fg = p.teal })
  hi("DiagnosticHint",         { fg = p.sage })
  hi("DiagnosticOk",           { fg = p.sage })
  hi("DiagnosticVirtualTextError",{ fg = p.rose, bg = p.grey_0, italic = true })
  hi("DiagnosticVirtualTextWarn", { fg = p.gold, bg = p.grey_0, italic = true })
  hi("DiagnosticVirtualTextInfo", { fg = p.teal, bg = p.grey_0, italic = true })
  hi("DiagnosticVirtualTextHint", { fg = p.sage, bg = p.grey_0, italic = true })
  hi("DiagnosticUnderlineError",{ undercurl = true, sp = p.rose })
  hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.gold })
  hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.teal })
  hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.sage })
  hi("DiagnosticSignError",    { fg = p.rose })
  hi("DiagnosticSignWarn",     { fg = p.gold })
  hi("DiagnosticSignInfo",     { fg = p.teal })
  hi("DiagnosticSignHint",     { fg = p.sage })

  -- ── Gitsigns ───────────────────────────────────────────────────
  hi("GitSignsAdd",    { fg = p.sage })
  hi("GitSignsChange", { fg = p.gold })
  hi("GitSignsDelete", { fg = p.rose })
  hi("DiffAdd",        { bg = "#DFF0D8" })
  hi("DiffChange",     { bg = "#E8DFF0" })
  hi("DiffDelete",     { bg = "#F5D5DA" })
  hi("DiffText",       { bg = "#D8C8E8" })
  hi("diffAdded",      { fg = p.sage })
  hi("diffChanged",    { fg = p.gold })
  hi("diffRemoved",    { fg = p.rose })

  -- ── Telescope / Snacks picker ──────────────────────────────────
  hi("TelescopeNormal",         { fg = p.snow, bg = p.bg1 })
  hi("TelescopeBorder",         { fg = p.lilac, bg = p.bg1 })
  hi("TelescopePromptNormal",   { fg = p.snow, bg = p.grey_0 })
  hi("TelescopePromptBorder",   { fg = p.wisteria, bg = p.grey_0 })
  hi("TelescopePromptTitle",    { fg = p.black, bg = p.wisteria, bold = true })
  hi("TelescopePreviewTitle",   { fg = p.black, bg = p.gold, bold = true })
  hi("TelescopeResultsTitle",   { fg = p.black, bg = p.teal, bold = true })
  hi("TelescopeSelection",      { fg = p.snow, bg = p.lilac_grey, bold = true })
  hi("TelescopeMatching",       { fg = p.gold, bold = true })
  hi("SnacksPickerBorder",      { fg = p.lilac, bg = p.bg1 })
  hi("SnacksPickerTitle",       { fg = p.black, bg = p.wisteria, bold = true })
  hi("SnacksPickerMatch",       { fg = p.gold, bold = true })

  -- ── Neo-tree / Snacks explorer ─────────────────────────────────
  hi("NeoTreeNormal",           { fg = p.snow, bg = p.bg1 })
  hi("NeoTreeNormalNC",         { fg = p.snow, bg = p.bg1 })
  hi("NeoTreeDirectoryName",    { fg = p.wisteria })
  hi("NeoTreeDirectoryIcon",    { fg = p.wisteria })
  hi("NeoTreeFileName",         { fg = p.snow })
  hi("NeoTreeRootName",         { fg = p.gold, bold = true })
  hi("NeoTreeGitAdded",         { fg = p.sage })
  hi("NeoTreeGitModified",      { fg = p.gold })
  hi("NeoTreeGitDeleted",       { fg = p.rose })
  hi("NeoTreeGitIgnored",       { fg = p.grey_4, italic = true })
  hi("NeoTreeDimText",          { fg = p.grey_4 })
  hi("NeoTreeDotfile",          { fg = p.grey_4 })
  hi("NeoTreeHiddenByName",     { fg = p.grey_4, italic = true })

  -- ── Snacks explorer (LazyVim default) ──────────────────────────
  -- Snacks uses these groups for its file explorer. Dimmed entries
  -- (gitignored, hidden) need a brighter grey_4 to stay readable.
  hi("SnacksPickerDir",         { fg = p.wisteria })
  hi("SnacksPickerFile",        { fg = p.snow })
  hi("SnacksPickerDimmed",      { fg = p.grey_4 })
  hi("SnacksPickerGitIgnored",  { fg = p.grey_4, italic = true })
  hi("SnacksPickerIgnored",     { fg = p.grey_4, italic = true })
  hi("SnacksPickerHidden",      { fg = p.grey_4, italic = true })
  hi("SnacksPickerPathHidden",  { fg = p.grey_4, italic = true })
  hi("SnacksPickerPathIgnored", { fg = p.grey_4, italic = true })
  hi("SnacksExplorerFileIgnored", { fg = p.grey_4, italic = true })
  hi("SnacksExplorerDimmed",    { fg = p.grey_4 })

  -- ── Which-key ──────────────────────────────────────────────────
  hi("WhichKey",          { fg = p.gold, bold = true })
  hi("WhichKeyGroup",     { fg = p.wisteria })
  hi("WhichKeyDesc",      { fg = p.snow })
  hi("WhichKeySeparator", { fg = p.grey_4 })
  hi("WhichKeyFloat",     { bg = p.bg1 })
  hi("WhichKeyBorder",    { fg = p.lilac, bg = p.bg1 })

  -- ── Flash / Leap ───────────────────────────────────────────────
  hi("FlashLabel",   { fg = p.black, bg = p.gold, bold = true })
  hi("FlashMatch",   { fg = p.black, bg = p.wisteria })
  hi("FlashCurrent", { fg = p.black, bg = p.bright_gold, bold = true })

  -- ── Treesitter context ─────────────────────────────────────────
  hi("TreesitterContext",       { bg = p.grey_0 })
  hi("TreesitterContextLineNumber",{ fg = p.gold, bg = p.grey_0 })

  -- ── Rainbow delimiters ─────────────────────────────────────────
  hi("RainbowDelimiterRed",    { fg = p.rose })
  hi("RainbowDelimiterYellow", { fg = p.gold })
  hi("RainbowDelimiterBlue",   { fg = p.lilac })
  hi("RainbowDelimiterOrange", { fg = p.bright_gold })
  hi("RainbowDelimiterGreen",  { fg = p.sage })
  hi("RainbowDelimiterViolet", { fg = p.wisteria })
  hi("RainbowDelimiterCyan",   { fg = p.teal })

  -- ── Indent-blankline ───────────────────────────────────────────
  hi("IblIndent",        { fg = p.grey_1 })
  hi("IblScope",         { fg = p.lilac })
  hi("IndentBlanklineChar",       { fg = p.grey_1 })
  hi("IndentBlanklineContextChar",{ fg = p.lilac })

  -- ── Noice ──────────────────────────────────────────────────────
  hi("NoiceCmdline",        { fg = p.snow, bg = p.bg1 })
  hi("NoiceCmdlineIcon",    { fg = p.gold })
  hi("NoiceCmdlinePopup",   { bg = p.bg1 })
  hi("NoiceCmdlinePopupBorder",{ fg = p.lilac, bg = p.bg1 })
  hi("NoicePopupmenu",      { bg = p.bg1 })
  hi("NoicePopupmenuBorder",{ fg = p.lilac })

  -- ── Mini.* ─────────────────────────────────────────────────────
  hi("MiniHipatternsFixme", { fg = p.black, bg = p.rose, bold = true })
  hi("MiniHipatternsHack",  { fg = p.black, bg = p.gold, bold = true })
  hi("MiniHipatternsTodo",  { fg = p.black, bg = p.teal, bold = true })
  hi("MiniHipatternsNote",  { fg = p.black, bg = p.sage, bold = true })

  -- ── DAP ────────────────────────────────────────────────────────
  hi("DapBreakpoint",        { fg = p.rose })
  hi("DapBreakpointCondition", { fg = p.gold })
  hi("DapLogPoint",          { fg = p.teal })
  hi("DapStopped",           { fg = p.sage })
  hi("DapUIBreakpointsInfo", { fg = p.teal })
  hi("DapUIWatchesValue",    { fg = p.sage })

  -- ── Harpoon ────────────────────────────────────────────────────
  hi("HarpoonBorder", { fg = p.lilac, bg = p.bg1 })
  hi("HarpoonTitle",  { fg = p.black, bg = p.gold, bold = true })
