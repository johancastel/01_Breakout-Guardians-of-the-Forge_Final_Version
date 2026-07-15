-- states/title.lua
local state = {}
local game
local time = 0
local particles = {}

function state.enter(g)
    game = g
    game:restartGame() -- Resetear todo el estado del juego al entrar al menú de título
    time = 0
    particles = {}
end

function state.update(dt)
    time = time + dt
    
    -- Generar chispas que suben desde el fondo
    if love.math.random() < 0.25 then
        table.insert(particles, {
            x = love.math.random(0, 800),
            y = 600,
            vx = love.math.random(-25, 25),
            vy = love.math.random(-80, -180),
            size = love.math.random(2, 5),
            life = love.math.random(2, 4),
            maxLife = 4
        })
    end
    
    -- Actualizar chispas
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

function state.draw()
    -- 1. Resplandor cálido de la forja de fondo (Círculos difusos)
    for i = 1, 12 do
        local radius = 320 + i * 45
        local alpha = 0.015 * (13 - i)
        love.graphics.setColor(0.9, 0.35, 0.1, alpha)
        love.graphics.circle("fill", 400, 300, radius)
    end
    
    -- 2. Dibujar chispas de la forja
    for _, p in ipairs(particles) do
        local alpha = p.life / p.maxLife
        if p.life > p.maxLife * 0.4 then
            love.graphics.setColor(0.95, 0.8, 0.2, alpha) -- Oro brillante
        else
            love.graphics.setColor(0.95, 0.25, 0.05, alpha) -- Brasa roja
        end
        love.graphics.rectangle("fill", p.x, p.y, p.size, p.size)
    end
    
    -- 3. Silueta de Yunque industrial en la parte inferior
    love.graphics.setColor(0.08, 0.08, 0.09, 0.95)
    -- Base del yunque
    love.graphics.polygon("fill", 310, 600, 490, 600, 450, 520, 350, 520)
    -- Cuerpo del yunque
    love.graphics.rectangle("fill", 365, 475, 70, 45)
    -- Cuerno y parte superior
    love.graphics.polygon("fill", 270, 440, 490, 440, 530, 475, 290, 475)
    
    -- Brillo del metal forjándose caliente
    local glowVal = math.abs(math.sin(time * 2))
    love.graphics.setColor(0.95, 0.45, 0.1, 0.2 + 0.35 * glowVal)
    love.graphics.rectangle("fill", 320, 435, 150, 6, 2, 2)
    
    -- 4. Título Principal Pulsante
    local glowColor = {
        0.9 + 0.1 * math.sin(time * 2.5),
        0.45 + 0.15 * math.sin(time * 2.5),
        0.1
    }
    
    love.graphics.setFont(love.graphics.newFont(36))
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.printf("BREAKOUT", 2, 142, 800, "center")
    love.graphics.setColor(glowColor[1], glowColor[2], glowColor[3])
    love.graphics.printf("BREAKOUT", 0, 140, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.printf("GUARDIANS OF THE FORGE", 2, 197, 800, "center")
    love.graphics.setColor(0.85, 0.85, 0.85)
    love.graphics.printf("GUARDIANS OF THE FORGE", 0, 195, 800, "center")
    
    -- 5. Instrucciones intermitentes
    local textAlpha = 0.4 + 0.6 * math.abs(math.sin(time * 3))
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.setColor(0.95, 0.95, 0.95, textAlpha)
    love.graphics.printf("Presione ESPACIO para templar el metal", 0, 330, 800, "center")
    
    -- 6. Créditos
    love.graphics.setFont(love.graphics.newFont(12))
    -- Sombra negra para legibilidad
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.printf("Desarrollado por: Jhoan Castelblanco & Julian Orellanos", 1, 561, 800, "center")
    -- Rojo lava/naranja brillante
    love.graphics.setColor(0.95, 0.35, 0.15)
    love.graphics.printf("Desarrollado por: Jhoan Castelblanco & Julian Orellanos", 0, 560, 800, "center")
end

function state.keypressed(key)
    if key == "space" or key == "return" then
        game:restartGame() -- Garantiza iniciar siempre en el Nivel 1 con score 0 y 3 vidas
        
        -- Cargar el primer nivel directamente
        game.level:loadLevel(1)
        if game.sfx then
            game.sfx.loadLevelMusic(game.level.bricks)
            game.sfx.playMusic()
        end
        game.levelPlusLifeSpawned = false
        game.levelMinusLifeSpawned = false
        
        -- Configurar el Energy Core con velocidad de saque inicial
        local primaryBall = game.balls[1]
        if primaryBall then
            primaryBall:reset()
            primaryBall.x = game.paddle.x + (game.paddle.w / 2) - (primaryBall.w / 2)
            primaryBall.y = game.paddle.y - primaryBall.h - 4
            primaryBall.vx = love.math.random(-150, 150)
            primaryBall.vy = -350
        end
        
        if game.sfx then game.sfx.playLaunch() end
        
        -- Pasar directamente al estado de juego activo (PLAY) sin doble espacio
        game.sm:switch("play", game)
    end
end

return state
