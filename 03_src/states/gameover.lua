-- states/gameover.lua
local state = {}
local game

function state.enter(g)
    game = g
end

function state.draw()
    -- Capa roja semi-transparente
    love.graphics.setColor(0.2, 0.05, 0.05, 0.85)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    love.graphics.setFont(love.graphics.newFont(36))
    love.graphics.setColor(0.9, 0.2, 0.2)
    love.graphics.printf("LA FORJA HA COLAPSADO", 0, 180, 800, "center")
    love.graphics.printf("GAME OVER", 0, 240, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf("Puntaje Final: " .. game.score, 0, 320, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.printf("Presione ENTER para volver a intentar\nPresione Q para salir del juego", 0, 420, 800, "center")
end

function state.keypressed(key)
    if key == "return" then
        game:restartGame()
        game.sm:switch("title", game)
    elseif key == "q" then
        love.event.quit()
    end
end

return state
