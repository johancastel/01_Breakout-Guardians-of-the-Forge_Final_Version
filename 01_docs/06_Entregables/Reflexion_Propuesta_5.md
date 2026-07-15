# PROPUESTA DE ENTREGA - MEJORA PARA CALIFICACIÓN 5.0

> [!NOTE]
> Este documento contiene la plantilla y el texto corregido para que puedan actualizar su documento formal de entrega (`.docx` / `.pdf`). Copien y peguen estas secciones directamente en su entregable.

---

## 1. Portada del Trabajo (Ajustada)

**Título:** Breakout: Guardians of the Forge  
**Subtítulo:** Actividad de Construcción Aplicada (ACA) - Entrega 1  
**Asignatura:** Diseño y Desarrollo de Videojuegos  
**Integrantes:**  
* Jhoan Andrés Castelblanco  
* Julián Eliécer Orellanos  
**Grupo:** E  
**Fecha de Entrega:** Julio de 2026  
**Institución:** Corporación Unificada Nacional de Educación Superior (CUN)  

---

## 2. Fe de Erratas / Correcciones Ortográficas Realizadas

A continuación, se listan los términos corregidos en el texto de la reflexión final:
*   *realmente* (se corrigió la falta de tilde o tipeo).
*   *pareció* (se añadió la tilde omitida en la o).
*   *teníamos* (se añadió la tilde omitida en la i).
*   *entendimos* (se corrigió el tiempo/conjugación o error de dedo).

---

## 3. Reflexión Final y Autocrítica del Diseño (Texto Corregido y Ampliado)

### Reflexión de Aprendizaje
El proceso de diseño de este proyecto base nos ha permitido comprender la importancia de planificar rigurosamente la arquitectura de un videojuego antes de proceder con el código funcional. **Realmente** consideramos que estructurar el juego mediante una máquina de estados explícita nos ahorró problemas de acoplamiento. Al principio, nos **pareció** una labor sumamente abstracta, ya que **teníamos** dudas sobre la forma en que Love2D gestiona el ciclo de actualización de pantalla (`update`) y dibujo (`draw`). Sin embargo, una vez que **entendimos** el funcionamiento del Game Loop y la propagación de delta time (`dt`), logramos estructurar clases cohesivas que respetan el principio de responsabilidad única.

### Autocrítica del Diseño: ¿Qué cambiaríamos de nuestra arquitectura?
Al evaluar críticamente nuestro diagrama UML y el flujo de clases propuesto, identificamos dos áreas clave que cambiaríamos de nuestro diseño para hacerlo más mantenible y escalable en el futuro:

1.  **Desacoplamiento de la Entrada (Input Manager):**
    Actualmente, la responsabilidad de capturar las pulsaciones de teclado y los controles del Forge Shield (`Paddle`) recae directamente entre las llamadas generales de la clase `Game` y el método de actualización del `Paddle`. Si en el futuro deseáramos añadir soporte para mando de juego (gamepad) o controles en pantalla táctil, tendríamos que reescribir código en varios archivos. **Cambiaríamos el diseño** introduciendo una clase dedicada `InputManager` que actúe como intermediario, mapeando los comandos físicos a acciones del juego de manera desacoplada.

2.  **Abstracción de las Colisiones Físicas:**
    En el diseño inicial, la detección de colisiones ocurre de manera directa entre `Ball`, `Paddle` y `Brick`. Esto genera una dependencia circular fuerte entre estas tres entidades. **Cambiaríamos el diseño** implementando un sistema o clase `CollisionSystem` dedicado que se encargue exclusivamente de comprobar las colisiones y emitir eventos o notificar a los objetos implicados. Esto mantendría los archivos de clase (`Ball.lua`, `Paddle.lua`) con lógica de comportamiento más limpia y sin responsabilidades de cálculo geométrico externo.

3.  **Transición de Escenas vs. Estados del Juego:**
    Vemos que algunos estados de la máquina de estados, como `LOADING_LEVEL` o `PAUSE`, actúan de manera híbrida entre estados de juego y escenas visuales. Para proyectos más grandes, **separaríamos la arquitectura en un Gestor de Escenas (SceneManager)** y una máquina de estados del juego interna para evitar que la clase `Game` se vuelva demasiado grande (un "God Object").
