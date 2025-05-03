--- STEAMODDED HEADER
--- MOD_NAME: MoreBalancedMisprint
--- MOD_ID: misprint
--- PREFIX: misprint
--- MOD_AUTHOR: [baltdev]
--- MOD_DESCRIPTION: Implements an alternative method of the Misprint deck, entirely separate from Cryptid!
--- VERSION: 1.0.0
----------------------

MISPRINTMOD = SMODS.current_mod


assert(SMODS.current_mod.lovely, "Lovely patches were not loaded! Make sure your mod is in the right place.")

assert(SMODS.load_file("./modules/assets.lua"))()
assert(SMODS.load_file("./modules/config.lua"))()
assert(SMODS.load_file("./modules/deck.lua"))()
assert(SMODS.load_file("./modules/hooks.lua"))()
assert(SMODS.load_file("./modules/misprintize.lua"))()

if CardSleeves then
    assert(SMODS.load_file("./modules/sleeve.lua"))()
end