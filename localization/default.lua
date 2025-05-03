return {
	descriptions = {
        Back={
            b_misprint_misprinted={
                name="Misprinted Deck",
				text = {
					"Values are multiplied by a",
                    "factor of #2#^X, with X",
					"being {C:attention}randomized{} over a",
                    "standard normal distribution",
					-- This is slightly inaccurate but I don't have a lot of space to work with :P
                    "{C:inactive}~43% chance of x1, ~16% chance of x#1# or x#2#,",
                    "{C:inactive}~0.8% chance of up to x#3# or x#4#, etc. to x0 and xInfinity",
                    "{C:inactive}More drastic multipliers are rarer"
				},
            },
        },
	},
	misc = {
		dictionary = {
			number_select_reset = "Reset",
            misprint_base = "Multiplier Base"
		}
	}
}