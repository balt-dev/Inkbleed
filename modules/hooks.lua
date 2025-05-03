
local cardInitHook = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = cardInitHook(self, X, Y, W, H, card, center, params)
    self:misprinted_deck_initialize()
    return ret
end

local eventManagerHook = EventManager.update
function EventManager:update(dt, forced)
    local ret = eventManagerHook(self, dt, forced)
    if G.GAME.pack_size and G.GAME.pack_choices then
        G.GAME.pack_choices = math.min(G.GAME.pack_size, G.GAME.pack_choices)
    end
    return ret
end