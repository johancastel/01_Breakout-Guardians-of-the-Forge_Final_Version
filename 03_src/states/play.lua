-- states/play.lua
local state = {}
local game
local collision = require("03_src/collision")
local PowerUp = require("03_src/PowerUp")

function state.enter(g)
    game = g
end

function state.update(dt)
    -- 1. Actualizar paleta y escenario
    game.paddle:update(dt)
    game.level:update(dt)
    
    -- 2. Actualizar y procesar colisiones con bordes para todas las bolas
    for i = #game.balls, 1, -1 do
        local ball = game.balls[i]
        ball:update(dt)
        
        -- Rebote con bordes laterales y superior
        if ball.x < 0 then
            ball.x = 0
            ball.vx = -ball.vx
            if game.sfx then game.sfx.playWall() end
        elseif ball.x > 800 - ball.w then
            ball.x = 800 - ball.w
            ball.vx = -ball.vx
            if game.sfx then game.sfx.playWall() end
        end
        
        if ball.y < 0 then
            ball.y = 0
            ball.vy = -ball.vy
            if game.sfx then game.sfx.playWall() end
        elseif ball.y > 600 then
            -- Remover la bola caída
            table.remove(game.balls, i)
            
            -- Si ya no quedan bolas, perdemos una vida
            if #game.balls == 0 then
                game.lives = game.lives - 1
                if game.sfx then game.sfx.playLoseLife() end
                
                -- Screen shake en muerte (fuerte)
                game.shakeTimer = 0.4
                game.shakeIntensity = 6
                
                if game.lives <= 0 then
                    game.sm:switch("gameover", game)
                else
                    game.sm:switch("serve", game)
                end
                return
            end
        end
    end
    
    -- 3. Colisión de las bolas con la paleta (AABB)
    for _, ball in ipairs(game.balls) do
        if collision.aabb(ball, game.paddle) then
            ball:bounceOnPaddle(game.paddle)
            if game.sfx then game.sfx.playBounce() end
        end
    end
    
    -- 4. Colisión de las bolas con los ladrillos
    local allDead = true
    for _, brick in ipairs(game.level.bricks) do
        if not brick._dead then
            if brick.type ~= "unbreakable" then
                allDead = false -- Aún quedan bloques rompibles
            end
            
            -- Verificar colisión contra todas las bolas activas
            for _, ball in ipairs(game.balls) do
                if not brick._dead and collision.aabb(ball, brick) then
                    collision.resolveBallBrick(ball, brick)
                    local points = brick:onHit()
                    game.score = game.score + points
                    
                    -- Sonido polimórfico y melódico basado en columna
                    if game.sfx then 
                        if brick.type == "unbreakable" then
                            game.sfx.playWall()
                        else
                            game.sfx.playBrickMelodic(brick.col, brick.type)
                        end
                    end
                    
                    -- Partículas, vibración de cámara suave o fuerte según combo
                    game:createParticles(brick.x + brick.w/2, brick.y + brick.h/2)
                    
                    game.consecutiveHits = game.consecutiveHits + 1
                    game.consecutiveHitTimer = 0.8 -- Ventana de 0.8s
                    
                    if game.consecutiveHits >= 3 then
                        game.shakeTimer = 0.25
                        game.shakeIntensity = 5.0 -- Vibración fuerte
                    else
                        game.shakeTimer = 0.08
                        game.shakeIntensity = 1.5 -- Vibración muy sutil
                    end
                    
                    -- Spawnear PowerUp
                    if brick._dead and brick.containsPower then
                        -- Frecuencia aumentada: Duplicamos 3 (Frenar) y 8 (Veloz) para que aparezcan más seguido
                        local availableTypes = {1, 3, 3, 4, 5, 7, 8, 8}
                        if not game.levelPlusLifeSpawned then
                            table.insert(availableTypes, 2)
                        end
                        if not game.levelMinusLifeSpawned then
                            table.insert(availableTypes, 6)
                        end
                        
                        local pType = availableTypes[love.math.random(1, #availableTypes)]
                        local effect, letter, color, label
                        
                        if pType == 1 then
                            -- A: Ampliar Paleta
                            letter = "A"
                            color = {0.2, 0.8, 0.2} -- Verde
                            label = "Ampliar"
                            effect = function()
                                game.paddle.w = 150
                                game.paddle.width = 150
                                game.powerUpTimer = 30.0
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                        elseif pType == 2 then
                            -- +V: Vida Extra
                            letter = "+V"
                            color = {0.9, 0.2, 0.4} -- Rojo/Rosa
                            label = "+1 Vida"
                            effect = function()
                                game.lives = game.lives + 1
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                            game.levelPlusLifeSpawned = true -- Registrar aparición
                        elseif pType == 3 then
                            -- F: Frenar Bolas (Ralentizar)
                            letter = "F"
                            color = {0.2, 0.6, 0.9} -- Celeste
                            label = "Frenar"
                            effect = function()
                                for _, b in ipairs(game.balls) do
                                    local currentSpeed = math.sqrt(b.vx^2 + b.vy^2)
                                    if currentSpeed > 0 then
                                        b.vx = (b.vx / currentSpeed) * 240
                                        b.vy = (b.vy / currentSpeed) * 240
                                    end
                                end
                                game.speedTimer = 30.0 -- Dura 30 segundos
                                game.speedState = "frenar"
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                        elseif pType == 4 then
                            -- X: Multi-Bola (Lanza 2 bolas extras a 45 grados)
                            letter = "X"
                            color = {0.9, 0.5, 0.1} -- Naranja dorado
                            label = "Multi-bola"
                            effect = function()
                                if #game.balls > 0 then
                                    local baseBall = game.balls[1]
                                    local Ball = require("03_src/Ball")
                                    
                                    -- Bola extra 1 (izquierda)
                                    local b2 = Ball.new()
                                    b2.x = baseBall.x
                                    b2.y = baseBall.y
                                    b2.vx = baseBall.vx - 120
                                    b2.vy = -math.abs(baseBall.vy)
                                    table.insert(game.balls, b2)
                                    
                                    -- Bola extra 2 (derecha)
                                    local b3 = Ball.new()
                                    b3.x = baseBall.x
                                    b3.y = baseBall.y
                                    b3.vx = baseBall.vx + 120
                                    b3.vy = -math.abs(baseBall.vy)
                                    table.insert(game.balls, b3)
                                end
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                        elseif pType == 5 then
                            -- R: Reducir Paleta (Cursed/Debuff)
                            letter = "R"
                            color = {0.7, 0.1, 0.7} -- Púrpura oscuro
                            label = "Reducir"
                            effect = function()
                                game.paddle.w = 60
                                game.paddle.width = 60
                                game.powerUpTimer = 30.0
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                        elseif pType == 6 then
                            -- -V: Quitar una Vida (Cursed/Debuff)
                            letter = "-V"
                            color = {0.8, 0.1, 0.1} -- Rojo oscuro
                            label = "-1 Vida"
                            effect = function()
                                game.lives = game.lives - 1
                                if game.sfx then game.sfx.playLoseLife() end
                                game.shakeTimer = 0.4
                                game.shakeIntensity = 6
                                if game.lives <= 0 then
                                    game.sm:switch("gameover", game)
                                end
                            end
                            game.levelMinusLifeSpawned = true -- Registrar aparición
                        elseif pType == 8 then
                            -- V: Veloz (Aumentar velocidad bolas)
                            letter = "V"
                            color = {0.95, 0.35, 0.1} -- Naranja/Rojo brillante
                            label = "Veloz"
                            effect = function()
                                for _, b in ipairs(game.balls) do
                                    local currentSpeed = math.sqrt(b.vx^2 + b.vy^2)
                                    if currentSpeed > 0 then
                                        b.vx = (b.vx / currentSpeed) * 520
                                        b.vy = (b.vy / currentSpeed) * 520
                                    end
                                end
                                game.speedTimer = 30.0 -- Dura 30 segundos
                                game.speedState = "veloz"
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                        else
                            -- I: Invertir Controles (Cursed/Debuff)
                            letter = "I"
                            color = {0.85, 0.85, 0.1} -- Amarillo
                            label = "Invertir"
                            effect = function()
                                game.paddle.invertedControls = true
                                game.invertTimer = 30.0 -- Dura 30 segundos
                                if game.sfx then game.sfx.playPowerUp() end
                            end
                        end
                        
                        table.insert(game.activePowerUps, PowerUp.new(brick.x + brick.w/2 - 8, brick.y + brick.h, effect, letter, color, label))
                    end
                end
            end
        end
    end
    
    -- Terminar nivel si no hay bloques rompibles
    if allDead then
        if game.currentLevel == 2 then
            game.sm:switch("victory", game)
        else
            game.currentLevel = 2
            game.sm:switch("serve", game)
        end
        return
    end
    
    -- 5. Actualizar PowerUps activos
    for i = #game.activePowerUps, 1, -1 do
        local pu = game.activePowerUps[i]
        pu:update(dt)
        
        if collision.aabb(pu, game.paddle) then
            pu.efecto()
            table.remove(game.activePowerUps, i)
        elseif pu.y > 600 then
            table.remove(game.activePowerUps, i)
        end
    end
    
    -- 6. Actualizar temporizador de ensanchamiento/reducción
    if game.powerUpTimer > 0 then
        game.powerUpTimer = game.powerUpTimer - dt
        if game.powerUpTimer <= 0 then
            game.paddle.w = 100
            game.paddle.width = 100
        end
    end
    
    -- Actualizar temporizador de controles invertidos
    if game.invertTimer > 0 then
        game.invertTimer = game.invertTimer - dt
        if game.invertTimer <= 0 then
            game.paddle.invertedControls = false
        end
    end
    
    -- Actualizar temporizador de velocidad de bolas
    if game.speedTimer > 0 then
        game.speedTimer = game.speedTimer - dt
        if game.speedTimer <= 0 then
            game.speedState = "normal"
            -- El efecto expira: regresar velocidad a 380
            for _, b in ipairs(game.balls) do
                local currentSpeed = math.sqrt(b.vx^2 + b.vy^2)
                if currentSpeed > 0 then
                    b.vx = (b.vx / currentSpeed) * 380
                    b.vy = (b.vy / currentSpeed) * 380
                end
            end
        end
    end
    
    -- 7. Partículas, shake y temporizador de golpes consecutivos
    game:updateParticles(dt)
    if game.shakeTimer > 0 then
        game.shakeTimer = game.shakeTimer - dt
    end
    if game.consecutiveHitTimer > 0 then
        game.consecutiveHitTimer = game.consecutiveHitTimer - dt
        if game.consecutiveHitTimer <= 0 then
            game.consecutiveHits = 0
        end
    end
end

function state.draw()
    if game.shakeTimer > 0 then
        local intensity = game.shakeIntensity or 1.5
        local dx = (love.math.random() * 2 - 1) * intensity
        local dy = (love.math.random() * 2 - 1) * intensity
        love.graphics.push()
        love.graphics.translate(dx, dy)
    end
    
    game.level:draw()
    game.paddle:draw()
    
    -- Dibujar todas las bolas activas
    for _, ball in ipairs(game.balls) do
        ball:draw()
    end
    
    -- Dibujar PowerUps
    for _, pu in ipairs(game.activePowerUps) do
        pu:draw()
    end
    
    -- Partículas
    game:drawParticles()
    
    if game.shakeTimer > 0 then
        love.graphics.pop()
    end
    
    -- Dibujar lista lateral de efectos activos
    local currentSpeed = 380
    if #game.balls > 0 then
        local b = game.balls[1]
        currentSpeed = math.sqrt(b.vx^2 + b.vy^2)
    end
    
    -- Interfaz y HUD
    game.ui:drawHUD(game.score, game.lives, game.currentLevel, game.level:getProgressPercent(), currentSpeed)
    
    game.ui:drawEffects(game.powerUpTimer, game.paddle.w, game.speedTimer, currentSpeed, game.invertTimer)
end

function state.keypressed(key)
    if key == "escape" then
        game.sm:switch("pause", game)
    end
end

return state
