-- states/serve.lua
local state = {}
local game

function state.enter(g)
    game = g
    -- Asegurar que hay al menos una bola y está reseteada
    game.balls = { require("03_src/Ball").new() }
    local primaryBall = game.balls[1]
    primaryBall:reset()
    primaryBall.x = game.paddle.x + (game.paddle.w / 2) - (primaryBall.w / 2)
    primaryBall.y = game.paddle.y - primaryBall.h - 2
    
    -- Si no hay nivel cargado, cargar el nivel actual
    if not game.level or game.level.levelNumber ~= game.currentLevel then
        game.level:loadLevel(game.currentLevel)
        if game.sfx then
            game.sfx.loadLevelMusic(game.level.bricks)
            game.sfx.playMusic()
        end
        game.levelPlusLifeSpawned = false
        game.levelMinusLifeSpawned = false
        
        -- Limpiar todos los efectos temporales activos al avanzar de nivel
        game.powerUpTimer = 0
        game.speedTimer = 0
        game.speedState = "normal"
        game.invertTimer = 0
        if game.paddle then
            game.paddle.w = 100
            game.paddle.width = 100
            game.paddle.invertedControls = false
        end
    end
end

function state.update(dt)
    -- Mover paleta y actualizar brasas de fondo
    game.paddle:update(dt)
    game.level:update(dt)
    
    -- La bola acompaña a la paleta
    local primaryBall = game.balls[1]
    if primaryBall then
        primaryBall.x = game.paddle.x + (game.paddle.w / 2) - (primaryBall.w / 2)
        primaryBall.y = game.paddle.y - primaryBall.h - 2
    end
end

function state.draw()
    -- Dibujar escenario
    game.level:draw()
    game.paddle:draw()
    
    local primaryBall = game.balls[1]
    if primaryBall then
        primaryBall:draw()
    end
    
    -- Determinar velocidad de lanzamiento esperada según efectos activos
    local launchSpeed = 380
    if game.speedTimer and game.speedTimer > 0 then
        if game.speedState == "veloz" then
            launchSpeed = 520
        elseif game.speedState == "frenar" then
            launchSpeed = 240
        end
    end
    
    -- Interfaz y HUD
    game.ui:drawHUD(game.score, game.lives, game.currentLevel, game.level:getProgressPercent(), launchSpeed)
    
    -- Dibujar lista lateral de efectos activos durante el saque
    game.ui:drawEffects(game.powerUpTimer, game.paddle.w, game.speedTimer, launchSpeed, game.invertTimer)
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.printf("Presione ESPACIO para lanzar el Energy Core", 0, 380, 800, "center")
end

function state.keypressed(key)
    if key == "space" then
        local primaryBall = game.balls[1]
        if primaryBall then
            local launchSpeed = 380
            if game.speedTimer and game.speedTimer > 0 then
                if game.speedState == "veloz" then
                    launchSpeed = 520
                elseif game.speedState == "frenar" then
                    launchSpeed = 240
                end
            end
            
            -- Dar velocidad inicial respetando el ángulo de lanzamiento y la velocidad actual del powerup
            local angle = love.math.random(-150, 150) / 150 * (math.pi / 5.5)
            primaryBall.vx = launchSpeed * math.sin(angle)
            primaryBall.vy = -launchSpeed * math.cos(angle)
        end
        
        -- Ejecutar sonido de lanzamiento si existe
        if game.sfx then game.sfx.playLaunch() end
        
        game.sm:switch("play", game)
    end
end

return state
