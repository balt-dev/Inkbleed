
local cardInitHook = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = cardInitHook(self, X, Y, W, H, card, center, params)
    if MISPRINTMOD.config.jokers_and_consumables then
        self:misprinted_deck_initialize()
        if center and center.misprint_randomized then
            self.ability = center.config
        end
        self.misprint_randomized = true
    end
    return ret
end

local cardSetBaseHook = Card.set_base
function Card:set_base(card, initial)
    local ret = cardSetBaseHook(self, card, initial)
    if
        G.GAME.modifiers.misprint_misprinted_deck and self.base
        and MISPRINTMOD.config.base_chips
    then
        local random_seed = self.randomseed or "misprint_random.base"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed
        self.base.altered_nominal = randomize(self.base.nominal, random_seed)
    end
    return ret
end

local cardSetEditionHook = Card.set_edition
function Card:set_edition(card, initial)
    local ret = cardSetEditionHook(self, card, initial)
    if
        G.GAME.modifiers.misprint_misprinted_deck and self.edition
        and MISPRINTMOD.config.editions
        and (self.edition and not self.edition.negative)
    then
        local random_seed = self.randomseed or "misprint_random.edition"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed
        randomize(self.edition, random_seed)
    end
    return ret
end

local cardSetAbilityHook = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = cardSetAbilityHook(self, center, initial, delay_sprites)
    if
        G.GAME.modifiers.misprint_misprinted_deck
        and MISPRINTMOD.config.scale
    then
        local random_seed = self.randomseed or "misprint_random.scale"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed

        local mul = randomize(1, random_seed, 0.025, 3)
        mul = math.max(math.min(mul, 1.7), 0.3)
        self.T.w = self.T.w * mul
        self.T.h = self.T.h * mul
    end
    if
        G.GAME.modifiers.misprint_misprinted_deck
        and MISPRINTMOD.config.cost
    then
        local random_seed = self.randomseed or "misprint_random.cost"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed

        self.base_cost = randomize(self.base_cost, random_seed)
    end

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
        local seed = gameSeed .. "misprint_random"

        if MISPRINTMOD.config.base_reroll_cost then
            G.GAME.starting_params.reroll_cost = randomize(G.GAME.starting_params.reroll_cost, seed .. ".base_reroll_cost")
        end
        if MISPRINTMOD.config.win_ante then
            G.GAME.win_ante = math.ceil(randomize(G.GAME.win_ante, seed .. ".win_ante", 0.3) - 0.5)
        end
        if MISPRINTMOD.config.perishable_rounds then
            G.GAME.perishable_rounds = randomize(G.GAME.perishable_rounds, seed .. ".perishable_rounds")
        end
        if MISPRINTMOD.config.rental_rate then
            G.GAME.rental_rate = randomize(G.GAME.rental_rate, seed .. ".rental_rate")
        end

        randomize(G.GAME.starting_params, seed .. ".starting_params", 0.3)
        randomize(G.GAME.round_resets, seed .. ".round_resets", 0.1)

        if MISPRINTMOD.config.hand_values then
            G.GAME.hands = deep_copy_and_randomize(G.GAME.hands, seed .. ".hands")
            for _, tab in pairs(G.GAME.hands) do
                tab.s_mult = tab.mult
                tab.s_chips = tab.chips
            end
        end
        if MISPRINTMOD.config.dollars then
            G.GAME.dollars = randomize(G.GAME.dollars, seed .. ".dollars", 0.2)
        end

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.7,
            func = function()
                SMODS.change_play_limit(0)
                SMODS.change_discard_limit(0)
                return true
            end,
        }))
    end
end

local card_apply = Card.apply_to_run

function Card:apply_to_run(center)
    return card_apply(self, center)
end

local init_loc = init_localization

function init_localization()
    local to_fix = {
        G.localization.descriptions.Voucher.v_antimatter.text,
        G.localization.descriptions.Voucher.v_overstock_norm.text,
        G.localization.descriptions.Voucher.v_overstock_plus.text,
        G.localization.descriptions.Voucher.v_crystal_ball.text,
    }
    for _, tbl in pairs(to_fix) do
        print("Fixing ", tbl)
        local counter = 0
        for i, line in ipairs(tbl) do
            tbl[i] = line:gsub("([%+%-])%d+", function(prefix)
                counter = counter + 1
                return prefix .. "#" .. counter .. "#"
            end)
        end
    end
    print("Fixed localization for Inkbleed!")
    init_loc()
end

