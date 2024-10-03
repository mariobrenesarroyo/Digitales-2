# Controlador de Cajero Automático

## Descripción

Este proyecto implementa un **controlador para un cajero automático** utilizando una **máquina de estados finita (FSM)**. El diseño maneja las operaciones básicas de un cajero, como la verificación del PIN, depósitos, retiros y la gestión de errores, como intentos fallidos de PIN y fondos insuficientes.

## Estructura del Proyecto

El proyecto incluye los siguientes archivos principales:

- `cajero.v`: Módulo principal que describe el controlador del cajero automático.
- `testbench.v`: Banco de pruebas que simula el comportamiento del controlador.
- `tester.v`: Módulo probador que genera las señales para probar el funcionamiento del controlador.
- `cmos_cells.lib`: Biblioteca de celdas CMOS utilizada para la síntesis con Yosys.
- `Makefile`: Archivo de automatización que facilita la compilación, simulación y síntesis del diseño.
- `sintesis.ys` y `sintesis_rtlil.ys`: Scripts de Yosys para realizar la síntesis del diseño y generar la descripción RTLIL.

## Requisitos

Para ejecutar este proyecto necesitarás las siguientes herramientas instaladas:

- **Icarus Verilog**: Para compilar y simular el código Verilog.
- **Yosys**: Para realizar la síntesis del diseño.
- **GTKWave**: Para visualizar las señales de la simulación.
- **Make**: Para ejecutar los comandos desde el Makefile.

## Uso

### Compilar, ejecutar y visualizar la simulación

Para compilar y ejecutar el proyecto y luego visualizar los resultados en GTKWave, ejecuta:

```bash
make run
```

Este comando compilará el archivo testbench.v, ejecutará la simulación y abrirá GTKWave con el archivo resultados.vcd.


# Realizar la síntesis
Si deseas realizar la síntesis del diseño utilizando Yosys, puedes usar el siguiente comando:

```bash
make synth
```
Esto generará el netlist sintetizado y ejecutará la simulación con este netlist.

# Limpiar los archivos generados
Si deseas eliminar los archivos generados por la compilación o la síntesis, ejecuta:

```bash
make clean
```

# Ver la simulación con o sin retardos
Para ver la simulación con o sin retardos, puedes modificar y descomentar las líneas correspondientes al inicio del archivo testbench_synth.v.