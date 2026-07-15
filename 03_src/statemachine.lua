-- statemachine.lua
local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(states)
    return setmetatable({ states = states, current = {} }, StateMachine)
end

function StateMachine:switch(name, ...)
    self.current = self.states[name]
    if self.current and self.current.enter then
        self.current.enter(...)
    end
end

function StateMachine:update(dt)
    if self.current and self.current.update then
        self.current.update(dt)
    end
end

function StateMachine:draw()
    if self.current and self.current.draw then
        self.current.draw()
    end
end

function StateMachine:keypressed(k)
    if self.current and self.current.keypressed then
        self.current.keypressed(k)
    end
end

return StateMachine
