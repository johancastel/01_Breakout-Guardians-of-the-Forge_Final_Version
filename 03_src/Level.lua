local Level = {}
Level.__index = Level

local Brick = require("03_src/Brick")
local StrongBrick = require("03_src/StrongBrick")
local UnbreakableBrick = require("03_src/UnbreakableBrick")
local levelsData = require("03_src/levels")

function Level.new()
    local self = setmetatable({
        levelNumber = 1,
        bricks = {},
        background = "default_bg",
        difficulty = "normal",
        bgParticles = {}, -- Partículas de brasa flotando al fondo
        time = 0
    }, Level)
    return self
end

function Level:loadLevel(levelNum)
    self.levelNumber = levelNum
    local layout = levelsData[levelNum]
    if layout then
        self.bricks = self:buildLevel(layout)
        self.bgParticles = {} -- Limpiar partículas al cambiar de nivel
        self.time = 0
        
        -- Contar bloques rompibles totales para calcular el porcentaje
        self.totalBreakable = 0
        for _, brick in ipairs(self.bricks) do
            if brick.type ~= "unbreakable" then
                self.totalBreakable = self.totalBreakable + 1
            end
        end
    end
end

function Level:getProgressPercent()
    if not self.totalBreakable or self.totalBreakable == 0 then return 100 end
    local deadCount = 0
    for _, brick in ipairs(self.bricks) do
        if brick._dead and brick.type ~= "unbreakable" then
            deadCount = deadCount + 1
        end
    end
    return math.floor((deadCount / self.totalBreakable) * 100)
end

function Level:buildLevel(layout)
    local bricks = {}
    for row, cols in ipairs(layout) do
        for col, code in ipairs(cols) do
            -- Alinear y centrar la cuadrícula de 13 columnas
            local x = 62 + (col - 1) * 52
            local y = 80 + (row - 1) * 24
            
            local b
            if code == 1 then
                b = Brick.new(x, y)
            elseif code == 2 then
                b = StrongBrick.new(x, y)
            elseif code == 3 then
                b = UnbreakableBrick.new(x, y)
            end
            
            if b then
                b.col = col
                b.row = row
                table.insert(bricks, b)
            end
        end
    end
    return bricks
end

function Level:update(dt)
    self.time = self.time + dt

    -- Generar brasas de fondo lentamente
    if love.math.random() < 0.12 then
        table.insert(self.bgParticles, {
            x = love.math.random(0, 800),
            y = 570, -- Spawnear justo encima del río de lava
            vx = love.math.random(-15, 15),
            vy = love.math.random(-30, -90), -- Lentos para dar sensación de profundidad
            size = love.math.random(1, 3),    -- Pequeños
            life = love.math.random(3, 5),
            maxLife = 5
        })
    end
    
    -- Actualizar posiciones
    for i = #self.bgParticles, 1, -1 do
        local p = self.bgParticles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(self.bgParticles, i)
        end
    end
end

function Level:draw()
    -- 1. Dibujar fondo de la cámara de la forja (Gradiente vertical cálido e intenso)
    for i = 0, 600, 15 do
        local factor = i / 600
        -- Transiciona de gris oscuro (arriba) a naranja/rojo cálido (abajo)
        local r = 0.08 + factor * 0.35
        local g = 0.06 + factor * 0.10
        local b = 0.06 - factor * 0.03
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", 0, i, 800, 15)
    end
    
    -- 2. Dibujar las chispas ambientales del fondo (antes de los ladrillos)
    for _, p in ipairs(self.bgParticles) do
        local alpha = (p.life / p.maxLife) * 0.45 -- 45% opacidad máxima
        love.graphics.setColor(0.95, 0.5, 0.15, alpha)
        love.graphics.rectangle("fill", p.x, p.y, p.size, p.size)
    end
    
    -- 3. Dibujar lava fluyendo en el fondo inferior (sea/river)
    love.graphics.setColor(0.85, 0.22, 0.04)
    local points = {}
    table.insert(points, 0)
    table.insert(points, 600)
    for x = 0, 800, 20 do
        local waveY = 575 + 6 * math.sin(x * 0.02 + self.time * 2.2)
        table.insert(points, x)
        table.insert(points, waveY)
    end
    table.insert(points, 800)
    table.insert(points, 600)
    love.graphics.polygon("fill", points)
    
    -- Borde de lava brillante (amarillo/naranja caliente)
    love.graphics.setColor(0.95, 0.65, 0.1)
    love.graphics.setLineWidth(3)
    for i = 3, #points - 3, 2 do
        love.graphics.line(points[i], points[i+1], points[i+2], points[i+3])
    end
    love.graphics.setLineWidth(1) -- Restaurar grosor de línea por defecto
    
    -- 4. Dibujar bloques
    for _, brick in ipairs(self.bricks) do
        brick:draw()
    end
end

function Level:isCompleted()
    for _, brick in ipairs(self.bricks) do
        if not brick._dead and brick.type ~= "unbreakable" then
            return false
        end
    end
    return true
end

return Level