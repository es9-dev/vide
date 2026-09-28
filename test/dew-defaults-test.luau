--[[
	`flags.defaults` skips `defaults.luau`'s own per-class write under Dew,
	since Dew's own DataModel already returns the identical default from
	the same reflection data that table was hand-copied from -- and the
	write, once made, permanently shadows a `StyleRule` that wants the
	same property later. `desktop` (a real Dew global, absent everywhere
	else including this file's own mock) is the signal `flags.luau` reads;
	it has to be set as a real global BEFORE `flags`, or anything that
	requires it, is required for the first time, since the flag is
	computed once and cached for the whole process. That is why this is
	its own standalone script rather than a case inside `tests.luau`,
	which already requires `create` (and therefore `flags`) before any
	case in it runs.
]]

desktop = { Widget = function() end } :: any

local flags = require "../src/flags"
assert(flags.defaults == false, "flags.defaults should be false once `desktop` is a real global")

local create = require "../src/create"
local frame = create "Frame" {} :: Instance & { BackgroundColor3: any }

-- THE MOCK NEVER DEFAULTS `BackgroundColor3` ITSELF (confirmed: `test/mock
-- .luau` sets no per-property defaults for any class) -- so `nil` here
-- means `defaults.luau`'s own write genuinely did not happen, not that
-- the mock happened to agree with it.
assert(
	frame.BackgroundColor3 == nil,
	`create("Frame") should leave BackgroundColor3 unset under Dew, got {frame.BackgroundColor3}`
)

print "dew-defaults-test: PASS"
