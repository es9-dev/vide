local function inline_test(): string
    return debug.info(1, "n")
end

local is_O2 = inline_test() ~= "inline_test"

-- WHY THIS EXISTS. `create.luau` writes `defaults.luau`'s own per-class
-- table onto every instance before a caller's properties apply, so a
-- caller who never named a property still gets one written explicitly.
-- On real Roblox that write matters (the engine's own default arrives the
-- same way regardless, but the explicit write predates this flag and
-- nothing here changes that). On Dew, it actively works against a real
-- feature: Dew's own DataModel reads the identical default from the same
-- reflection data `defaults.luau` was hand-copied from, so the write adds
-- nothing there and only gets in the way of a `StyleRule` that wants to
-- fill the same property later -- an explicit value, once written, wins
-- over a `StyleRule` by the engine's own correct rule, permanently
-- shadowing it. `desktop` is Dew's own global, real there and nil
-- everywhere else (including this file's own test double, which mocks
-- `Instance` but never `desktop`), so this is the same is-it-Dew signal
-- the rest of this fork already reads elsewhere.
local is_dew = typeof((desktop :: any)) == "table"

return {
    strict = not is_O2,
    defaults = not is_dew,
    defer_nested_properties = true,
    batch = false,
}
