
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
    ["Perkeo"] = true,
    ["Director's Cut"] = true,
    ["Retcon"] = true,

    -- Keys

    immutable = true,
    order = true,
    level = true,
    played = true,
    played_this_round = true,
    ante_scaling = true,
    ante = true,
    blind_ante = true,
    min_highlighted = true,
    nodes = true,
    mod_num = true,
    consumeable = true
}

local key_callbacks = {}

local function blacklist_one(new, old)
    if old == 1 then return old else return new end
end

key_callbacks.x_chips = blacklist_one
key_callbacks.h_x_chips = blacklist_one
key_callbacks.x_mult = blacklist_one
key_callbacks.h_x_mult = blacklist_one

function key_callbacks.max_highlighted(new, old, value)
    if value.consumeable then
        value.consumeable.max_highlighted = math.floor(new)
    end
    if value.min_highlighted then
        value.min_highlighted = math.floor(new)
        if value.consumeable then
            value.consumeable.min_highlighted = math.floor(new)
        end
    end
    if value.mod_num then
        value.mod_num = math.floor(new)
        if value.consumeable then
            value.consumeable.mod_num = math.floor(new)
        end
    end
    return new
end

function key_callbacks.dollars (new, old)
    if MISPRINTMOD.config.dollars then
       return new
   end
   return old
end

function key_callbacks.voucher_slots (new, old)
    if MISPRINTMOD.config.voucher_slots then
       return math.max(1, new)
   end
   return old
end

function key_callbacks.play_limit (new, old)
    if MISPRINTMOD.config.play_limit then
       return math.floor(new + 0.5)
   end
   return old
end

function key_callbacks.discard_limit (new, old)
    if MISPRINTMOD.config.discard_limit then
       return math.floor(new + 0.5)
   end
   return old
end

function key_callbacks.highlight_limit (new, old)
    if MISPRINTMOD.config.highlight_limit then
       return math.ceil(new)
   end
   return old
end

function key_callbacks.hand_size (new, old)
    if MISPRINTMOD.config.hand_size then
       return math.ceil(new)
   end
   return old
end

function key_callbacks.discards (new, old)
    if MISPRINTMOD.config.discards then
       return math.floor(new + 0.5)
   end
   return old
end

function key_callbacks.hands (new, old)
    if MISPRINTMOD.config.hands then
       return math.ceil(new)
   end
   return old
end

function key_callbacks.reroll_cost (new, old)
    if MISPRINTMOD.config.reroll_cost then
       return new
   end
   return old
end

function key_callbacks.joker_slots (new, old)
    if MISPRINTMOD.config.joker_slots then
       return math.floor(new + 0.5)
   end
   return old
end

function key_callbacks.consumable_slots (new, old)
    if MISPRINTMOD.config.consumable_slots then
       return math.floor(new + 0.5)
   end
   return old
end


function deep_copy(value)
    local ty = type(value)
    if ty == "table" then
        local t = {}
        local key, val = next(value, nil)
        while key ~= nil do
            t[key] = deep_copy(val)
            key, val = next(value, key)
        end
        setmetatable(t, debug.getmetatable(value))
        return t
    end
    return value
end

function deep_copy_and_randomize(value, seed)
    local t = deep_copy(value)
    return randomize(t, seed)
end

function sanitize_float(f)
    if type(f) ~= "number" then return f end
    return math.floor(f * 1000) / 1000
end

function randomize(value, seed, amount)
    amount = amount or 1
    local ty = type(value)
    if ty == "number" or (
        -- Talisman
        ty == "table" and (
            (BigMeta and getmetatable(value) == BigMeta) or
            (OmegaMeta and getmetatable(value) == OmegaMeta)
        )
    ) then
        local a = pseudorandom(pseudoseed(seed..".a"))
        local b = pseudorandom(pseudoseed(seed..".b"))
        a = math.min(math.max(a, 0.000001), 0.9999999)
        b = math.min(math.max(b, 0.000001), 0.9999999)
        -- Exp-normal distributed random numbers
        local power = math.sqrt(-2 * math.log(a)) * math.cos(2 * math.pi * b)
        local factor = math.pow(MISPRINTMOD.config.Base, power)
        return sanitize_float((value * (1 - amount)) + (value * factor) * amount)
    end
    if ty == "table" then
        if value.inkbleed_immutable and value.inkbleed_immutable == true then
            return value
        end
        local key, val = next(value, nil)
        while key ~= nil do
            local v = val
            if not name_blacklist[key] then
                v = randomize(val, seed .. "." .. key, amount)
                if key_callbacks[key] then
                    v = key_callbacks[key](v, val, value)
                end
            end
            value[key] = v
            key, val = next(value, key)
        end
    end
    return value
end

function Card:misprinted_deck_initialize()
    if G.GAME.modifiers.misprint_misprinted_deck then
        if self:misprint_blacklisted() then return end

        local random_seed = self.randomseed or "misprint_random.card"
        random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. "." .. random_seed

        self.ability = deep_copy_and_randomize(self.ability, random_seed)
    end
end

function Card:misprint_blacklisted()
    if self.area and self.area.config.collection then return true end
    if self.ability and name_blacklist[self.ability.name] then return true end
    if self.name and name_blacklist[self.name] then return true end
    return false
end
