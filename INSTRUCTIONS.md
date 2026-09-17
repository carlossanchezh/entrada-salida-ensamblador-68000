# Instrucciones de Instalación y Ejecución

Este documento describe los requisitos, la instalación y la ejecución del proyecto Entrada/Salida en ensamblador para el Motorola 68000.

## Requisitos

- Un **ensamblador** compatible con el Motorola 68000.

- Un **emulador** o **simulador** compatible con el Motorola 68000 capaz de simular el periférico DUART MC68681.

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/carlossanchezh/entrada-salida-ensamblador-68000.git
```

### 2. Preparar el emulador y el ensamblador

Este repositorio no incluye el emulador ni el ensamblador. 

Debes disponer de una herramienta compatible con el MC68000 y seguir las instrucciones de instalación y uso del ensamblador/emulador que hayas elegido para:

- Ensamblar el fichero `es_int.s`.

- Ejecutar el código objeto resultante en el emulador.

## Ejecución

### 1. Ensamblado

Usa tu ensamblador compatible con el MC68000 para traducir `es_int.s` a un código objeto con una extensión correspondiente a la herramienta utilizada.

> Ten en cuenta que `es_int.s` incluye `bib_aux.s` mediante la pseudoinstrucción `INCLUDE`. Asegúrate de que la línea del `INCLUDE` va seguida de al menos una línea vacía para evitar errores de ensamblado.

### 2. Ejecución en el emulador

Carga el código objeto generado en tu emulador compatible con el MC68000 y ejecútalo siguiendo las instrucciones de dicha herramienta.

> Consulta la documentación de tu emulador para saber cómo reiniciar el procesador, cargar el código objeto, colocar puntos de ruptura o visualizar las líneas serie.

### 3. Ejecución del programa

Una vez en ejecución, el programa principal de prueba incluido en es_int.s lee caracteres de la línea A y los reenvía por la línea B o viceversa, por lo que podrás comprobar la recepción y transmisión escribiendo por una línea y viendo el mismo mensaje aparecer por la otra.

> Consulta la documentación de tu emulador para saber cómo visualizar la actividad de las líneas serie A y B.