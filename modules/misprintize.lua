
local key_callbacks = {}

local function blacklist_one(new, old)
    if old == 1 then return old else return new end
end

key_callbacks.x_chips = blacklist_one
key_callbacks.h_x_chips = blacklist_one
key_callbacks.x_mult = blacklist_one
key_callbacks.h_x_mult = blacklist_one

local function deep_copy_and_randomize(value, seed)
    local ty = type(value)
    if ty == "table" then
        local t = {}
        local key, val = next(value, nil)
        while key ~= nil do
            local v = deep_copy_and_randomize(val, seed .. "." .. key)
            if key_callbacks[key] then
                v = key_callbacks[key](v, val)
            end
            t[key] = v
            key, val = next(value, key)
        end
        setmetatable(t, getmetatable(value))
        return t
    end
    -- Considering we don't have the debug library, this is all we can really do on the copying
    if ty == "number" then
        local a = pseudorandom(pseudoseed(seed..".a"))
        local b = pseudorandom(pseudoseed(seed..".b"))
        -- Exp-normal distributed random numbers
        local factor = math.pow(
            MISPRINTMOD.config.Base,
            math.sqrt(-2 * math.log(a)) * math.cos(2 * math.pi * b)
        )
        return value * factor
    end
    return value
end

function Card:misprinted_deck_initialize()
    if G.GAME.modifiers.misprint_misprinted_deck then
        if Card:misprint_blacklisted() then return end

        local random_seed = self.randomseed or "misprint_random_seed"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed

        self.ability = deep_copy_and_randomize(self.ability, random_seed)
    end
end

local name_blacklist = {
    ["Fortune Teller"] = true,
    ["Shoot the Moon"] = true,
    ["Riff-raff"] = true,
    ["Chaos the Clown"] = true,
    ["Dusk"] = true,
    ["Mime"] = true,
    ["Hack"] = true,
    ["Sock and Buskin"] = true,
    ["Swashbuckler"] = true,
    ["Smeared Joker"] = true,
    ["Certificate"] = true,
    ["Mr. Bones"] = true,
    ["Diet Cola"] = true,
    ["Luchador"] = true,
    ["Midas Mask"] = true,
    ["Shortcut"] = true,
    ["Seance"] = true,
    ["Superposition"] = true,
    ["Sixth Sense"] = true,
    ["DNA"] = true,
    ["Splash"] = true,
    ["Supernova"] = true,
    ["Pareidolia"] = true,
    ["Raised Fist"] = true,
    ["Marble Joker"] = true,
    ["Four Fingers"] = true,
    ["Joker Stencil"] = true,
    ["Showman"] = true,
    ["Blueprint"] = true,
    ["Oops! All 6s"] = true,
    ["Brainstorm"] = true,
    ["Cartomancer"] = true,
    ["Astronomer"] = true,
    ["Burnt Joker"] = true,
    ["Chicot"] = true,
    ["Perkeo"] = true
}

function Card:misprint_blacklisted()
    if self.area and self.area.config.collection then return true end
    if name_blacklist[self.ability.name] then return true end
    return false
end