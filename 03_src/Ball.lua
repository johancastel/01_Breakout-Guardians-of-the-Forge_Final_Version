local Ball = {}

Ball.__index = Ball

function Ball:new()

    local self = setmetatable({}, Ball)

    return self

end

function Ball:update(dt)

end

function Ball:draw()

end

return Ball