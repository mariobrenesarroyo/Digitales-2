# Vamos a generar un archivo README.md con el contenido que proporcionamos
readme_content = """
# Proyecto de Simulación y Síntesis

Este proyecto contiene varios archivos relacionados con la simulación y síntesis de circuitos digitales. A continuación, se describe el propósito de cada archivo y cómo utilizar el Makefile para automatizar las tareas comunes.

## Archivos

- **cmos_cells.lib**: Biblioteca de celdas CMOS utilizada en las simulaciones.
- **cmos_cells.v**: Archivo Verilog que define las celdas CMOS.
- **control_de_acceso.v**: Módulo Verilog para el control de acceso.
- **control_synth.v**: Versión sintetizada del módulo de control de acceso.
- **Makefile**: Archivo de automatización para compilar y ejecutar simulaciones.
- **sintesis.ys**: Script de Yosys para la síntesis del diseño.
- **sintesis_rtlil.ys**: Script de Yosys para la síntesis RTLIL.
- **testbench.v**: Banco de pruebas para la simulación conductual.
- **testbench_rtlil.v**: Banco de pruebas para la simulación RTLIL.
- **testbench_synth.v**: Banco de pruebas para la simulación sintetizada.
- **tester.v**: Archivo de pruebas adicional.

## Uso del Makefile

El Makefile proporciona varias reglas para automatizar la simulación y limpieza de archivos. A continuación se describen las reglas disponibles:

### Reglas Principales

- **conductual**: Compila y ejecuta la simulación conductual.
  ```bash
  make conductual
    ```

Esto ejecuta los siguientes comandos:

```bash
Mostrar siempre los detalles

Copiar código
iverilog testbench.v
vvp a.out
gtkwave resultados.vcd
```
**rtlil**: Ejecuta la síntesis RTLIL y luego la simulación.
```bash
make rtlil
```
Esto ejecuta los siguientes comandos:
```bash
yosys sintesis_rtlil.ys
iverilog testbench_rtlil.v
vvp a.out
gtkwave resultados.vcd
```

**synth**: Ejecuta la síntesis y luego la simulación sintetizada.
```bash
make synth
```

Esto ejecuta los siguientes comandos:
```bash
yosys sintetis.ys
iverilog testbench_synth.v
vvp a.out
gtkwave resultados.vcd
```

### Reglas de Limpieza
**clean**: Elimina los archivos generados por las simulaciones.

```bash
make clean
```
Esto ejecuta los siguientes comandos:
```bash
del a.out resultados.vcd || true
rm -f a.out resultados.vcd
```
**clean-rtlil**: Limpia los archivos generados por la simulación RTLIL.
```bash
make clean-rtlil
```

Esto ejecuta los siguientes comandos:
```bash
make clean
del control_rtlil.v || true
rm -f control_rtlil.v
```

**clean-synth**: Limpia los archivos generados por la simulación sintetizada.
```bash
make clean-synth
```

Esto ejecuta los siguientes comandos:
```bash
make clean
del control_synth.v || true
rm -f control_synth.v
```

### Notas
* Asegúrate de tener instalados iverilog, vvp, gtkwave y yosys para ejecutar las simulaciones y síntesis correctamente.

* Los comandos del y rm están incluidos para compatibilidad con Windows y Unix respectivamente.