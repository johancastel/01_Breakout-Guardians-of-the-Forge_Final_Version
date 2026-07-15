-- states/victory.lua
local state = {}
local game

function state.enter(g)
    game = g
end

function state.draw()
    -- Capa dorada/amarilla semi-transparente
    love.graphics.setColor(0.05, 0.15, 0.05, 0.85)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    love.graphics.setFont(love.graphics.newFont(36))
    love.graphics.setColor(0.3, 0.9, 0.3)
    love.graphics.printf("¡FORJA LIBERADA!", 0, 160, 800, "center")
    love.graphics.setColor(0.9, 0.8, 0.2)
    love.graphics.printf("VICTORIA ABSOLUTA", 0, 220, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf("Has restaurado el poder ancestral de los Guardianes.", 0, 300, 800, "center")
    love.graphics.printf("Puntaje Final: " .. game.score, 0, 340, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.printf("Presione ENTER para volver al menú principal\nPresione Q para salir del juego", 0, 440, 800, "center")
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
