
local cardInitHook = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = cardInitHook(self, X, Y, W, H, card, center, params)
    self:misprinted_deck_initialize()
    return ret
end

local cardSetBaseHook = Card.set_base
function Card:set_base(card, initial)
    local ret = cardSetBaseHook(self, card, initial)
    if G.GAME.modifiers.misprint_misprinted_deck and self.base then
        local random_seed = self.randomseed or "misprint_random.base"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed
    end
    return ret
end

local cardSetEditionHook = Card.set_edition
function Card:set_edition(card, initial)
    local ret = cardSetEditionHook(self, card, initial)
    if G.GAME.modifiers.misprint_misprinted_deck and self.edition then
        local random_seed = self.randomseed or "misprint_random.edition"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed
        randomize(self.edition, random_seed)
    end
    return ret
end

local cardSetCostHook = Card.set_cost
function Card:set_cost()
    local ret = cardSetCostHook(self)
    if G.GAME.modifiers.misprint_misprinted_deck and self.cost then
        local random_seed = self.randomseed or "misprint_random.cost"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed
        local factor = randomize(1, random_seed)
        self.cost = self.cost * factor
        self.sell_cost = self.sell_cost * factor
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
    return ret
end

-- Patch to fix decimal blinds

local getBlindAmount = get_blind_amount
function get_blind_amount(ante)
    if math.fmod(ante, 1) ~= 0 then
        -- Lerp between ante amounts
        local floor = getBlindAmount(math.floor(ante))
        local ceil = getBlindAmount(math.ceil(ante))
        local factor = math.fmod(ante, 1)
        return floor * (1 - factor) + ceil * factor
    end
    return getBlindAmount(ante)
end

local smodsGetBlindAmount = SMODS.get_blind_amount
function SMODS.get_blind_amount(ante)
    if math.fmod(ante, 1) ~= 0 then
        -- Lerp between ante amounts
        local floor = smodsGetBlindAmount(math.floor(ante))
        local ceil = smodsGetBlindAmount(math.ceil(ante))
        local factor = math.fmod(ante, 1)
        return floor * (1 - factor) + ceil * factor
    end
    return smodsGetBlindAmount(ante)
end

function randomize_game_stuff(gameSeed)
    if G.GAME.modifiers.misprint_misprinted_deck then
        print("randomizing game stuff")
        local seed = gameSeed .. "misprint_random"

        G.GAME.base_reroll_cost = randomize(G.GAME.base_reroll_cost, seed .. ".base_reroll_cost")
        G.GAME.win_ante = math.ceil(randomize(G.GAME.win_ante, seed .. ".win_ante", 0.3) - 0.5)
        G.GAME.perishable_rounds = randomize(G.GAME.perishable_rounds, seed .. ".perishable_rounds")
        G.GAME.rental_rate = randomize(G.GAME.rental_rate, seed .. ".rental_rate")

        randomize(G.GAME.starting_params, seed .. ".starting_params", 0.3)
        randomize(G.GAME.round_resets, seed .. ".round_resets", 0.1)

        G.GAME.hands = deep_copy_and_randomize(G.GAME.hands, seed .. ".hands")
        for _, tab in pairs(G.GAME.hands) do
            tab.s_mult = tab.mult
            tab.s_chips = tab.chips
        end
        G.GAME.dollars = randomize(G.GAME.dollars, seed .. ".dollars", 0.2)
        print("game stuff randomized")
    end
end
