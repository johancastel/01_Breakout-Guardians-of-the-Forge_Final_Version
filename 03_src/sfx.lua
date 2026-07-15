-- sfx.lua
local M = {}

local function generateBeep(frequency, duration, type)
    if not love.sound or not love.audio then return nil end

    local sampleRate = 44100
    local samples = math.floor(sampleRate * duration)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local val = 0
        if type == "sine" then
            val = math.sin(2 * math.pi * frequency * t)
        elseif type == "square" then
            val = math.sin(2 * math.pi * frequency * t) > 0 and 0.5 or -0.5
        elseif type == "noise" then
            val = love.math.random() * 2 - 1
        end
        local fade = math.min(1, (samples - i) / (sampleRate * 0.05))
        soundData:setSample(i, val * 0.25 * fade)
    end
    
    local success, source = pcall(love.audio.newSource, soundData)
    return success and source or nil
end

local melodicNormal = {}
local melodicStrong = {}
local bounceSource, hitNormalSource, hitStrongSource, wallSource, powerupSource, loseLifeSource, launchSource, musicSource

function M.loadLevelMusic(bricks)
    if not love.sound or not love.audio then return end
    
    -- Detener música actual
    M.stopMusic()
    
    local sampleRate = 44100
    local stepDuration = 0.25 -- 16 notas de 0.25s (4 segundos total)
    local numSteps = 16
    local samples = math.floor(sampleRate * stepDuration * numSteps)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    -- Mapear los primeros 16 bloques del nivel a notas de bajo (ritmo de nivel)
    local melody = {}
    local scale = {110.0, 130.8, 146.8, 164.8, 196.0, 220.0} -- Escala La menor pentatónica
    
    for i = 1, numSteps do
        local brick = bricks and bricks[i]
        if not brick then
            -- Si no hay bloque (o es el menú), 30% de probabilidad de tono armónico aleatorio, si no silencio
            if love.math.random() < 0.3 then
                melody[i] = scale[love.math.random(1, #scale)]
            else
                melody[i] = 0 -- Silencio rítmico (crea síncopa)
            end
        elseif brick.type == "normal" then
            melody[i] = 110.0 -- A2 (La)
        elseif brick.type == "strong" then
            melody[i] = 146.8 -- D3 (Re)
        elseif brick.type == "unbreakable" then
            melody[i] = 164.8 -- E3 (Mi)
        else
            melody[i] = 130.8 -- C3 (Do)
        end
    end
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local step = math.floor(t / stepDuration) + 1
        if step > numSteps then step = numSteps end
        
        local freq = melody[step]
        local stepTime = t % stepDuration
        
        -- Onda senoidal suave para el bajo de la melodía
        local bass = 0
        if freq > 0 then
            bass = math.sin(2 * math.pi * freq * t)
        end
        
        -- Envolvente de volumen para marcar cada tono del ritmo (fade out rápido al final de cada paso)
        local env = 0
        if freq > 0 then
            env = 1.0
            if stepTime > stepDuration * 0.75 then
                env = (stepDuration - stepTime) / (stepDuration * 0.25)
            end
        end
        
        -- Sintetizar un golpe de percusión (bombo analógico retro) en notas impares
        local drum = 0
        if step % 2 == 1 then
            local kickFreq = 160 * math.exp(-stepTime * 35) -- Caída de tono rápida
            drum = math.sin(2 * math.pi * kickFreq * stepTime) * math.exp(-stepTime * 12)
        end
        
        -- Mezcla suave del bajo rítmico y bombo
        local mix = (bass * env * 0.30) + (drum * 0.45)
        
        -- Aplicar un sutil desvanecimiento al final del loop
        local loopFade = math.min(1, (samples - i) / (sampleRate * 0.1))
        soundData:setSample(i, mix * loopFade)
    end
    
    local success, source = pcall(love.audio.newSource, soundData)
    if success and source then
        source:setLooping(true)
        source:setVolume(0.12) -- Volumen ambiental controlado
        musicSource = source
    end
end

function M.load()
    pcall(function()
        bounceSource = generateBeep(440, 0.08, "sine")
        hitNormalSource = generateBeep(587, 0.08, "sine")
        hitStrongSource = generateBeep(293, 0.15, "square")
        wallSource = generateBeep(220, 0.05, "sine")
        powerupSource = generateBeep(880, 0.2, "sine")
        loseLifeSource = generateBeep(110, 0.35, "square")
        launchSource = generateBeep(523, 0.12, "sine")
        
        -- Generar las 13 notas melódicas correspondientes a las columnas de la forja
        local noteScale = {220.0, 246.9, 261.6, 293.7, 329.6, 392.0, 440.0, 493.9, 523.3, 587.3, 659.3, 784.0, 880.0} -- Escala La menor expandida
        for col = 1, 13 do
            local freq = noteScale[col] or 440.0
            melodicNormal[col] = generateBeep(freq, 0.08, "sine")
            melodicStrong[col] = generateBeep(freq * 0.5, 0.15, "square") -- Una octava abajo para mayor peso
        end
        
        -- Cargar música inicial de menú vacía (generación aleatoria de fallback)
        M.loadLevelMusic({})
    end)
end

function M.playMusic()
    if musicSource then pcall(function() musicSource:play() end) end
end

function M.stopMusic()
    if musicSource then pcall(function() musicSource:stop() end) end
end

function M.playBounce()
    if bounceSource then pcall(function() bounceSource:clone():play() end) end
end

function M.playBrickMelodic(col, brickType)
    col = col or 1
    if col < 1 or col > 13 then col = 1 end
    
    local source
    if brickType == "strong" then
        source = melodicStrong[col]
    else
        source = melodicNormal[col]
    end
    
    if source then
        pcall(function()
            source:clone():play()
        end)
    end
end

function M.playBrickNormal()
    if hitNormalSource then pcall(function() hitNormalSource:clone():play() end) end
end

function M.playBrickStrong()
    if hitStrongSource then pcall(function() hitStrongSource:clone():play() end) end
end

function M.playWall()
    if wallSource then pcall(function() wallSource:clone():play() end) end
end

function M.playPowerUp()
    if powerupSource then pcall(function() powerupSource:clone():play() end) end
end

function M.playLoseLife()
    if loseLifeSource then pcall(function() loseLifeSource:clone():play() end) end
end

function M.playLaunch()
    if launchSource then pcall(function() launchSource:clone():play() end) end
end

return M
