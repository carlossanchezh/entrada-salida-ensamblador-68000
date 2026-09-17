# Entrada/Salida en ensamblador 68000

## Descripción

Proyecto desarrollado en ensamblador para el **Motorola 68000** que implementa la comunicación serie con un periférico **DUART MC68681**, que proporciona dos líneas serie para leer y escribir caracteres.

Permite leer y escribir datos por las dos líneas serie sin bloquear la ejecución del programa, utilizando interrupciones para gestionar la transferencia de caracteres.

## Arquitectura

### Rutinas

La implementación está dividida en diferentes rutinas que se encargan de las distintas partes del proceso:

`INIT` — Inicializa la DUART y los buffers internos.

`SCAN`	— Lee caracteres recibidos por una línea. No bloqueante.

`PRINT`	— Envía caracteres por una línea. No bloqueante.

`RTI`	— Rutina de interrupción. Gestiona la transferencia real con el hardware.

`LEECAR` / `ESCCAR`	— Auxiliares. Extraen/insertan caracteres en los buffers internos.

`INI_BUFS` — Auxiliar. Inicializa los buffers internos.

### Funcionamiento

El sistema se apoya en cuatro buffers internos circulares (recepción A, recepción B, transmisión A y transmisión B) que desacoplan al programa de usuario de la velocidad real de la línea serie. 

Gracias a ellos, las subrutinas `SCAN` y `PRINT` nunca esperan al hardware: solo mueven caracteres entre el programa y los buffers, mientras que la `RTI` se encarga de la transferencia real.

#### Recepción:

1. La **DUART MC68681** recibe un carácter por la línea A o B y activa la línea de interrupción.

2. La `RTI` identifica la fuente de la interrupción y lee el carácter del registro de recepción correspondiente.

3. El carácter se guarda en el buffer interno de recepción mediante `ESCCAR`.

4. Si el buffer estuviera lleno, el carácter se descarta (pero se lee igualmente de la DUART MC68681 para desactivar la petición de interrupción).

5. Cuando el programa llama a `SCAN`, este extrae los caracteres disponibles del buffer con `LEECAR` y los copia al buffer del usuario, sin bloquearse si no hay suficientes.

#### Transmisión:

1. El programa llama a `PRINT` con los caracteres que quiere enviar.

2. `PRINT` los encola en el buffer interno de transmisión con `ESCCAR` y activa las interrupciones de transmisión de esa línea.

3. La **DUART MC68681** solicita interrupción cuando está lista para transmitir.

4. La `RTI` extrae un carácter del buffer interno con `LEECAR` y lo escribe en el registro de transmisión de la **DUART MC68681**.

5. Cuando el buffer interno se vacía, la `RTI` deshabilita las interrupciones de transmisión de esa línea para evitar peticiones innecesarias.

#### Concurrencia:

La `RTI` y las subrutinas `SCAN`/`PRINT` comparten los buffers internos. El diseño de buffers circulares con punteros separados de extracción e inserción garantiza que ningún carácter se lee dos veces ni se pierde, siempre que cada puntero sea modificado únicamente por la rutina que le corresponde.

### Tecnologías

- Lenguaje ensamblador en arquitectura **Motorola 68000**.
- Periférico DUART MC68681.

## Estructura del proyecto

```plaintext
.
├── es_int.s        # INIT, SCAN, PRINT, RTI
├── bib_aux.s       # ESCCAR, LEECAR, INI_BUFS y buffers internos
└── README.md       # Descripción del proyecto        
```
