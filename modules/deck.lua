-- TODO: Add a cardsleeve

SMODS.Back{
    key = "misprinted",
    atlas = "deckBacks",
    pos = { x = 0, y = 0 },
    config = { },
    set_badges = function (self, card, badges)
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                1 / MISPRINTMOD.config.Base,
				MISPRINTMOD.config.Base,
				1 / (MISPRINTMOD.config.Base * MISPRINTMOD.config.Base),
				MISPRINTMOD.config.Base * MISPRINTMOD.config.Base
            }
        }
    end,
    apply = function(self)
        G.GAME.modifiers.misprint_misprinted_deck = true
    end,

}
