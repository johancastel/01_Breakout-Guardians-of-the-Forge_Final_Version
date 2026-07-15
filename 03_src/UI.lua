local UI = {}
UI.__index = UI

function UI.new()
    local self = setmetatable({
        score = 0,
        lives = 3,
        currentLevel = 1,
        message = ""
    }, UI)
    return self
end

function UI:drawHUD(score, lives, level, progressPercent, ballSpeed)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.setColor(0.9, 0.9, 0.9)
    
    -- Puntaje
    love.graphics.print("PUNTOS: " .. score, 40, 18)
    
    -- Nivel con porcentaje
    local progress = progressPercent or 0
    love.graphics.printf("NIVEL: " .. level .. " / 2 (" .. progress .. "%)", 0, 14, 800, "center")
    
    -- Barra de progreso
    local barW = 150
    local barH = 6
    local barX = 400 - (barW / 2)
    local barY = 34
    
    -- Fondo de la barra (Gris carbón oscuro)
    love.graphics.setColor(0.12, 0.12, 0.12)
    love.graphics.rectangle("fill", barX, barY, barW, barH, 3, 3)
    
    -- Relleno de la barra (Lava brillante)
    if progress > 0 then
        love.graphics.setColor(0.95, 0.45, 0.1)
        love.graphics.rectangle("fill", barX, barY, barW * (progress / 100), barH, 3, 3)
    end
    
    -- Borde de la barra (Gris tenso)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("line", barX, barY, barW, barH, 3, 3)
    
    -- Velocidad de la bola (Muestra velocidad de lanzamiento de 380 si está detenida)
    local dispSpeed = ballSpeed or 380
    if dispSpeed < 10 then dispSpeed = 380 end
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.print("VELOCIDAD: " .. math.floor(dispSpeed), 520, 18)
    
    -- Vidas
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.print("VIDAS: " .. lives, 680, 18)
    
    -- Línea divisoria decorativa
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.line(20, 48, 780, 48)
end

function UI:update(dt)
end

function UI:draw()
end

function UI:updateScore(score)
    self.score = score
end

function UI:updateLives(lives)
    self.lives = lives
end

function UI:showMessage(msg)
    self.message = msg
end

function UI:drawEffects(powerUpTimer, paddleW, speedTimer, currentSpeed, invertTimer)
    local x = 20
    local y = 56
    local spacing = 170
    
    -- 1. Efecto de Paleta
    if powerUpTimer and powerUpTimer > 0 then
        local letter = (paddleW > 100) and "A" or "R"
        local label = (paddleW > 100) and "Ampliar" or "Reducir"
        local color = (paddleW > 100) and {0.2, 0.8, 0.2} or {0.7, 0.1, 0.7}
        
        self:drawEffectRow(x, y, letter, label, color, powerUpTimer, 30)
        x = x + spacing
    end
    
    -- 2. Efecto de Velocidad
    if speedTimer and speedTimer > 0 then
        local letter = (currentSpeed > 380) and "V" or "F"
        local label = (currentSpeed > 380) and "Veloz" or "Frenar"
        local color = (currentSpeed > 380) and {0.95, 0.35, 0.1} or {0.2, 0.6, 0.9}
        
        self:drawEffectRow(x, y, letter, label, color, speedTimer, 30)
        x = x + spacing
    end
    
    -- 3. Efecto de Controles Invertidos
    if invertTimer and invertTimer > 0 then
        self:drawEffectRow(x, y, "I", "Invertir", {0.85, 0.85, 0.1}, invertTimer, 30)
    end
end

function UI:drawEffectRow(x, y, letter, label, color, timeRemaining, maxTime)
    -- Dibujar píldora de la letra
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, 14, 14, 3, 3)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(9))
    local letterOffsetX = (string.len(letter) > 1) and 1 or 4
    love.graphics.print(letter, x + letterOffsetX, y + 1)
    
    -- Dibujar nombre abreviado
    love.graphics.setFont(love.graphics.newFont(10))
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.print(label, x + 20, y + 1)
    
    -- Dibujar mini barra de progreso
    local barX = x + 70
    local barW = 60
    local barH = 4
    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", barX, y + 5, barW, barH, 1, 1)
    
    love.graphics.setColor(color)
    local fillW = barW * (math.min(timeRemaining, maxTime) / maxTime)
    love.graphics.rectangle("fill", barX, y + 5, fillW, barH, 1, 1)
    
    -- Dibujar segundos restantes
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.setFont(love.graphics.newFont(9))
    love.graphics.print(string.format("%.1fs", timeRemaining), barX + barW + 8, y + 1)
end

return UI