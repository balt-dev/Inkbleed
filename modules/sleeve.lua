CardSleeves.Sleeve{
    key = "misprinted",
    atlas = "sleeveBack",
    pos = { x = 0, y = 0 },
    config = {},
    loc_vars = function (self)
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