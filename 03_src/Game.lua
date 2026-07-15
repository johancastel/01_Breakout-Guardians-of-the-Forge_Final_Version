local Game = {}
Game.__index = Game

-- Requerir clases colaboradoras
local Level = require("03_src/Level")
local UI = require("03_src/UI")
local Paddle = require("03_src/Paddle")
local Ball = require("03_src/Ball")
local StateMachine = require("03_src/statemachine")
local sfx = require("03_src/sfx")

function Game.new()
    local self = setmetatable({
        currentState = "TITLE",
        currentLevel = 1,
        score = 0,
        lives = 3,
        isRunning = false,
        
        -- Colaboradores
        level = nil,
        ui = nil,
        paddle = nil,
        balls = {}, -- Lista de bolas activas (soporta Multi-Ball)
        sm = nil,
        sfx = sfx,
        
        -- Temporizadores y efectos
        activePowerUps = {},
        powerUpTimer = 0,
        shakeTimer = 0,
        shakeIntensity = 0, -- Fuerza dinámica de la vibración
        consecutiveHits = 0, -- Contador de golpes consecutivos
        consecutiveHitTimer = 0, -- Ventana de tiempo de golpes
        invertTimer = 0, -- Temporizador para controles invertidos
        speedTimer = 0,  -- Temporizador para efecto de velocidad de bolas
        speedState = "normal", -- Estado de velocidad de bolas ("normal", "veloz", "frenar")
        levelPlusLifeSpawned = false,  -- Control de aparición de +1 vida
        levelMinusLifeSpawned = false, -- Control de aparición de -1 vida
        particles = {}
    }, Game)
    return self
end

function Game:load()
    -- Cargar sonido procedural y arrancar música de fondo
    self.sfx.load()
    self.sfx.playMusic()
    
    -- Instanciar elementos basicos del juego
    self.level = Level.new()
    self.ui = UI.new()
    self.paddle = Paddle.new()
    self.balls = { Ball.new() }
    
    -- Cargar la maquina de estados
    self.sm = StateMachine.new({
        title = require("03_src/states/title"),
        serve = require("03_src/states/serve"),
        play = require("03_src/states/play"),
        pause = require("03_src/states/pause"),
        gameover = require("03_src/states/gameover"),
        victory = require("03_src/states/victory")
    })
    
    -- Forzar reinicio de variables al cargar (Garantiza Nivel 1)
    self:restartGame()
    
    -- Iniciar en estado de titulo
    self.sm:switch("title", self)
    self.isRunning = true
end

function Game:update(dt)
    if self.sm then
        self.sm:update(dt)
    end
end

function Game:draw()
    if self.sm then
        self.sm:draw()
    end
end

function Game:keypressed(key)
    if self.sm then
        self.sm:keypressed(key)
    end
end

function Game:restartGame()
    self.score = 0
    self.lives = 3
    self.currentLevel = 1
    self.activePowerUps = {}
    self.particles = {}
    self.powerUpTimer = 0
    self.shakeTimer = 0
    self.shakeIntensity = 0
    self.consecutiveHits = 0
    self.consecutiveHitTimer = 0
    self.invertTimer = 0
    self.speedTimer = 0
    self.speedState = "normal"
    self.levelPlusLifeSpawned = false
    self.levelMinusLifeSpawned = false
    if self.paddle then
        self.paddle.w = 100
        self.paddle.width = 100
        self.paddle.invertedControls = false
    end
    self.balls = { Ball.new() }
end

function Game:nextLevel()
    self.currentLevel = 2 -- Actualmente solo hay 2 niveles
end

-- Sistema de partículas personalizado (Procedural)
function Game:createParticles(x, y)
    -- Crear 8 pequeñas partículas que salen en direcciones aleatorias
    for i = 1, 8 do
        table.insert(self.particles, {
            x = x,
            y = y,
            vx = love.math.random(-120, 120),
            vy = love.math.random(-120, 120),
            size = love.math.random(3, 6),
            life = 0.5, -- dura medio segundo
            maxLife = 0.5,
            color = {0.8, 0.4, 0.2} -- Tonalidad chispa/fuego
        })
    end
end

function Game:updateParticles(dt)
    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(self.particles, i)
        end
    end
end

function Game:drawParticles()
    for _, p in ipairs(self.particles) do
        -- Efecto fade-out en la opacidad
        local alpha = p.life / p.maxLife
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], alpha)
        love.graphics.rectangle("fill", p.x, p.y, p.size, p.size)
    end
end

return Game