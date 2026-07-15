-- states/pause.lua
local state = {}
local game

function state.enter(g)
    game = g
end

function state.draw()
    -- Dibujar el estado play de fondo estatico
    game.level:draw()
    game.paddle:draw()
    for _, ball in ipairs(game.balls) do
        ball:draw()
    end
    
    local currentSpeed = 380
    if game.balls and #game.balls > 0 then
        local b = game.balls[1]
        currentSpeed = math.sqrt(b.vx^2 + b.vy^2)
    end
    game.ui:drawHUD(game.score, game.lives, game.currentLevel, game.level:getProgressPercent(), currentSpeed)
    
    -- Capa semi-transparente
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    -- Mensaje de pausa
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.printf("JUEGO EN PAUSA", 0, 240, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.printf("Presione ESC o ENTER para Continuar\nPresione Q para volver al menú principal", 0, 300, 800, "center")
end

function state.keypressed(key)
    if key == "escape" or key == "return" then
        game.sm:switch("play", game)
    elseif key == "q" then
        game:restartGame()
        game.sm:switch("title", game)
    end
end

return state
