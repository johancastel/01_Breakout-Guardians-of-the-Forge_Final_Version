#Algoritmo General
#INICIO

    Inicializar el juego

    Cargar recursos del juego
        - Sprites
        - Sonidos
        - Fuentes
        - Configuración

    Establecer el estado inicial como TITLE

    Mientras la aplicación esté en ejecución hacer

        Leer la entrada del jugador

        Según el estado actual del juego hacer

            TITLE

                Mostrar pantalla principal

                Si el jugador presiona ENTER entonces

                    Cambiar estado a LOADING_LEVEL

                Fin Si


            LOADING_LEVEL

                level:loadLevel(currentLevel)
                ball:reset()
                paddle:new() -- Posicionar la barra en el centro
                ui:showMessage("CARGANDO NIVEL...")
                game:changeState("PLAY")


            PLAY

                -- Actualización con delta time (dt)
                paddle:update(dt)
                ball:update(dt)
                level:update(dt)
                powerUp:update(dt)

                -- Procesamiento de Colisiones
                Detectar colisión ball con paddle:
                    Si colisionan entonces
                        ball:bounce()
                        paddle:catchPower(powerUp)
                    Fin Si

                Detectar colisión ball con brick en level.bricks:
                    Si colisionan entonces
                        ball:bounce()
                        brick:hit()
                        Si brick:health == 0 entonces
                            brick:destroy()
                            Si brick:containsPower entonces
                                brick:releasePower()
                                powerUp:spawn()
                            Fin Si
                        Fin Si
                    Fin Si

                -- Dibujar elementos
                paddle:draw()
                ball:draw()
                level:draw()
                powerUp:draw()
                ui:drawHUD()

                Si el jugador presiona ESC entonces
                    game:changeState("PAUSE")
                Fin Si

                Si ball.y > pantalla.alto entonces
                    game.lives = game.lives - 1
                    Si game.lives == 0 entonces
                        game:changeState("GAME_OVER")
                    Sino
                        ball:reset()
                    Fin Si
                Fin Si

                Si level:isCompleted() entonces
                    game:changeState("LEVEL_COMPLETE")
                Fin Si


            PAUSE

                ui:showMessage("PAUSA - Seleccione CONTINUAR o SALIR")
                
                Si el jugador selecciona CONTINUAR entonces
                    game:changeState("PLAY")
                Fin Si

                Si el jugador selecciona SALIR entonces
                    love.event.quit()
                Fin Si


            LEVEL_COMPLETE

                ui:showMessage("¡NIVEL COMPLETADO!")
                game:nextLevel()

                Si existen más niveles entonces
                    game:changeState("LOADING_LEVEL")
                En caso contrario
                    game:changeState("TITLE")
                Fin Si


            GAME_OVER

                ui:showMessage("GAME OVER - Puntaje Final: " .. game.score)

                Si el jugador presiona ENTER entonces
                    game:restartGame()
                    game:changeState("TITLE")
                Fin Si

                Si el jugador selecciona SALIR entonces
                    love.event.quit()
                Fin Si

        Fin Según

    Fin Mientras

FIN