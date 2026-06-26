# Análisis de Entidades

## Breakout: Guardians of the Forge

# Clase: Game

## Responsabilidad

Administrar el flujo general del videojuego, controlar los estados del juego, iniciar partidas, gestionar niveles y coordinar la comunicación entre todas las entidades.

### Atributos

* currentState
* currentLevel
* score
* lives
* isRunning

### Métodos

* load()
* update(dt)
* draw()
* changeState()
* restartGame()
* nextLevel()

### Colabora con

* Level
* UI
* Ball
* Paddle

---

# Clase: Ball

## Responsabilidad

Representar la bola principal (Energy Core), controlar su movimiento, detectar colisiones y aplicar efectos especiales obtenidos mediante poderes.

### Atributos

* Ejex
* Ejey
* radius
* speedX
* speedY
* damage

### Métodos

* update(dt)
* draw()
* move()
* bounce()
* reset()
* applyPower()

### Colabora con

* Paddle
* Brick
* Game
* PowerUp

---

# Clase: Paddle

## Responsabilidad

Representar el Forge Shield controlado por el jugador, permitiendo dirigir la bola y recibir los efectos de los poderes.

### Atributos

* x
* width
* height
* speed
* currentPower

### Métodos

* moveLeft()
* moveRight()
* update(dt)
* draw()
* catchPower()

### Colabora con

* Ball
* PowerUp

---

# Clase: Brick

## Responsabilidad

Representar los bloques del nivel, administrar su resistencia, almacenar poderes y desaparecer cuando su resistencia llegue a cero.

### Atributos

* x
* y
* width
* height
* health
* type
* containsPower

### Métodos

* draw()
* hit()
* destroy()
* releasePower()

### Colabora con

* Ball
* PowerUp

---

# Clase: Level

## Responsabilidad

Administrar la distribución de los bloques, controlar el progreso del nivel y verificar cuándo el jugador completa la cámara actual.

### Atributos

* levelNumber
* bricks
* background
* difficulty

### Métodos

* loadLevel()
* update()
* draw()
* isCompleted()

### Colabora con

* Brick
* Game

---

# Clase: UI

## Responsabilidad

Mostrar toda la información del jugador durante la partida, incluyendo vidas, puntaje, nivel y mensajes del juego.

### Atributos

* score
* lives
* currentLevel
* message

### Métodos

* drawHUD()
* updateScore()
* updateLives()
* showMessage()

### Colabora con

* Game

---

# Clase: PowerUp

## Responsabilidad

Administrar los poderes especiales que aparecen al destruir determinados bloques y aplicar sus efectos sobre la barra o la bola.

### Atributos

* type
* duration
* speed
* isActive

### Métodos

* spawn()
* update(dt)
* draw()
* apply()
* remove()

### Colabora con

* Ball
* Paddle
* Brick
* Game
