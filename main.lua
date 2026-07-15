if os.getenv("LOVE2D_TOOLS") then pcall(require, "_love2d_tools_bridge") end

-- Cargar la clase principal del juego
local Game = require("03_src/Game")
local game

function love.load()
    love.window.setTitle("Breakout: Guardians of the Forge")
    
    -- Instanciar el juego y llamar a su carga de recursos
    game = Game.new()
    game:load()
end

function love.update(dt)
    if game then
        game:update(dt)
    end
end

function love.draw()
    if game then
        game:draw()
    else
        love.graphics.print("Breakout: Guardians of the Forge", 220, 180)
        love.graphics.print("Jhoan Castelblanco - Julian Orellanos", 250, 210)
    end
end
function love.keypressed(key)
    if game then
        game:keypressed(key)
    end
end

function love.quit()
    if game then
        game:restartGame() -- Resetea el estado a Nivel 1 al salir por la X
    end
end