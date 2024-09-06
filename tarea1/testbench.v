`include "control_de_acceso.v"
`include "tester.v"

// Módulo principal
module acceso_tb;

  // Declaración de señales
  wire clk, reset, llegado_vehiculo, paso_vehiculo, boton_reset;
  wire [15:0] clave_ingresada;   // Clave es un bus de 16 bits
  wire abriendo_compuerta, cerrando_compuerta,alarm_pin_incorrecto, alarm_bloqueo;

  // Instanciación del probador y del módulo bajo prueba
  control_acceso U0(
    .clk(clk),
    .reset(reset),
    .llegado_vehiculo(llegado_vehiculo),
    .paso_vehiculo(paso_vehiculo),
    .clave_ingresada(clave_ingresada),
    .boton_reset(boton_reset),
    .abriendo_compuerta(abriendo_compuerta),
    .cerrando_compuerta(cerrando_compuerta),
    .alarm_pin_incorrecto(alarm_pin_incorrecto),
    .alarm_bloqueo(alarm_bloqueo)

  );

  provador_acceso P0(
    .clk(clk),
    .reset(reset),
    .llegado_vehiculo(llegado_vehiculo),
    .paso_vehiculo(paso_vehiculo),
    .clave_ingresada(clave_ingresada),
    .boton_reset(boton_reset),
    .abriendo_compuerta(abriendo_compuerta),
    .cerrando_compuerta(cerrando_compuerta),
    .alarm_pin_incorrecto(alarm_pin_incorrecto),
    .alarm_bloqueo(alarm_bloqueo)

  );

  defparam P0.CLAVE_CORRECTA = 16'h1194;    //nueva clave correcta en provador por mi carnet C11194
  defparam U0.CLAVE_CORRECTA = 16'h1194;    //nueva clave correcta en  modulo top por C11194

  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(-1, U0);
    // Monitorización de todas las señales
    $monitor("clk=%b, reset=%b, llegado_vehiculo=%b, paso_vehiculo=%b, clave_ingresada=%h, boton_reset=%b, abriendo_compuerta=%b, cerrando_compuerta=%b, alarm_pin_incorrecto=%b, alarm_bloqueo=%b", 
             clk, reset, llegado_vehiculo, paso_vehiculo, clave_ingresada, boton_reset, abriendo_compuerta, cerrando_compuerta, alarm_pin_incorrecto, alarm_bloqueo);
  end

endmodule
