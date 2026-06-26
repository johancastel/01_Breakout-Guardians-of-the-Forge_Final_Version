local PowerUp = {}

PowerUp.__index = PowerUp

function PowerUp:new()

    local self = setmetatable({}, PowerUp)

    return self

end

function PowerUp:update(dt)

end

function PowerUp:draw()

end

return PowerUp