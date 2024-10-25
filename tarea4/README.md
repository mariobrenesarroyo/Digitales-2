# Proyecto de Receptor de Transacciones I2C

Este proyecto incluye la implementación y simulación de un receptor de transacciones I2C, según las especificaciones del documento I2C-bus Specification and User Manual revisión 7.0.

## Estructura de Archivos

- **generadorI2C.v**: Módulo que genera las señales necesarias para la comunicación I2C.
- **receptor_i2c.v**: Módulo del receptor que maneja la recepción de transacciones I2C.
- **tb.v**: Testbench para verificar el funcionamiento del receptor de transacciones I2C.
- **tester_i2c.v**: Archivo de prueba adicional para el receptor de I2C.
- **Makefile**: Archivo de construcción para compilar y ejecutar las simulaciones.

## Uso del Makefile

### Compilar y Ejecutar Simulación

Para compilar y ejecutar la simulación, utiliza el comando:

```sh
make run
```
## Estructura de Archivos

- **Este comando realizará las siguientes acciones:

- **Compilar los archivos Verilog utilizando iverilog.

Ejecutar la simulación con vvp.

Abrir el archivo de resultados en gtkwave.

# Limpiar Archivos Generados
Para limpiar los archivos generados durante la compilación y simulación, utiliza el comando:
```sh
make clean
```

# Requisitos
Icarus Verilog: Un compilador Verilog.

GTKWave: Un visor de archivos VCD.
