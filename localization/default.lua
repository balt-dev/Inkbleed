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
					"{C:inactive}More drastic multipliers are rarer"
				},
            },
        },
        Sleeve={
            sleeve_misprint_misprinted={
                name="Misprinted Sleeve",
				text = {
					"Values are multiplied by a factor of #2#^X",
					"with X being {C:attention}randomized{} over a",
					"standard normal distribution",
					"{C:inactive}More drastic multipliers are rarer"
				},
            },
        },
	},
	misc = {
		dictionary = {
			number_select_reset = "Reset",
            misprint_base = "Multiplier Base",

            misprint_enabled = "Enabled Randomizers:",
            misprint_base_chips = "Base Chips",
            misprint_money = "Dollars",
            misprint_hand_size = "Hand Size",
            misprint_discards = "Discards",
            misprint_hands = "Hands",
            misprint_base_reroll_cost = "Base Reroll Cost",
            misprint_joker_slots = "Joker Slots",
            misprint_voucher_slots = "Voucher Slots",
            misprint_consumable_slots = "Consumable Slots",
            misprint_hand_values = "Hand Values",
            misprint_jokers_and_consumables = "Jokers & Consumables",
            misprint_win_ante = "Win Ante",
            misprint_editions = "Editions",
            misprint_enhancements = "Enhancements",
            misprint_rental_rate = "Rental Rate",
            misprint_perishable_rounds = "Perishable Rounds",
            misprint_play_limit = "Play Limit",
            misprint_discard_limit = "Discard Limit",
            misprint_highlight_limit = "Highlight Limit",
            misprint_cost = "Cost",
            misprint_tags = "Tags",
            misprint_hand_levels = "Hand Starting Levels",
            misprint_ambient_tilt = "Ambient Card Tilt",
            misprint_scale = "Card Scale",

            misprint_only_increase = "Only increase values?",

            misprint_explain_hover = "How does this work? (Hover)",
            misprint_yap = {
                "Each value configured to be randomized is multiplied by a value determined by",
                "the formula B^x, where B is the configured base.",
                "x varies on a {C:attention}standard normal{} distribution, meaning, for example,",
                "it has a good chance of being close to 0 (leading to a multiplication of around 1),",
                "a lower chance of being close to 1 or -1 (leading to a multiplication of around B or 1/B),",
                "an even lower chance of being close to 2 or -2 (leading to a multiplication of around B^2 or 1/B^2),",
                "and so on and so forth.",
                "{X:attention,C:white}TL;DR{}: Multiplier can go infinitely big or small, but bigger/smaller means more rare.",
                "The higher you set B, the bigger/smaller it usually gets.",
            }
		}
	}
}
