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

                Cargar el nivel actual

                Crear los bloques

                Inicializar la pelota

                Posicionar la barra

                Inicializar la interfaz

                Cambiar estado a PLAY


            PLAY

                Actualizar la barra

                Actualizar la pelota

                Detectar colisiones

                Actualizar bloques

                Actualizar poderes

                Actualizar la interfaz

                Dibujar todos los elementos del juego

                Si el jugador presiona ESC entonces

                    Cambiar estado a PAUSE

                Fin Si

                Si el jugador pierde todas las vidas entonces

                    Cambiar estado a GAME_OVER

                Fin Si

                Si todos los bloques fueron destruidos entonces

                    Cambiar estado a LEVEL_COMPLETE

                Fin Si


            PAUSE

                Mostrar menú de pausa

                Esperar la decisión del jugador

                Si el jugador selecciona CONTINUAR entonces

                    Cambiar estado a PLAY

                Fin Si

                Si el jugador selecciona SALIR entonces

                    Finalizar aplicación

                Fin Si


            LEVEL_COMPLETE

                Mostrar mensaje de nivel completado

                Calcular bonificación

                Incrementar el número del nivel

                Si existen más niveles entonces

                    Cambiar estado a LOADING_LEVEL

                En caso contrario

                    Cambiar estado a TITLE

                Fin Si


            GAME_OVER

                Mostrar pantalla de Game Over

                Mostrar puntaje final

                Si el jugador presiona ENTER entonces

                    Reiniciar partida

                    Cambiar estado a TITLE

                Fin Si

                Si el jugador selecciona SALIR entonces

                    Finalizar aplicación

                Fin Si

        Fin Según

    Fin Mientras

FIN