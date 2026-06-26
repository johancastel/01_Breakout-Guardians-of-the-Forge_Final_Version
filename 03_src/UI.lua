local UI = {}

UI.__index = UI

function UI:new()

    local self = setmetatable({}, UI)

    return self

end

function UI:update(dt)

end

function UI:draw()

end

return UI