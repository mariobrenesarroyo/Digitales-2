`include "probador_me.v"
`include "me_op1.v"

// Testbench Code
module me_tb;

  // Declaración de señales
  wire clk, rst, s_in, valido, nuevo_numero;

  // Configuración de señales de volcado para la simulación
  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(-1, MEOP1); // Volcar todas las señales del módulo `MEOP1`
  end

  // Instancia del módulo secuenciador (det_sec)
  det_sec MEOP1 (
    .clk (clk),
    .rst (rst),
    .s_in (s_in),
    .valido (valido),
    .nuevo_numero (nuevo_numero)  // Nueva conexión para la señal nuevo_numero
  );

  // Instancia del probador
  probador PROB_MEOP1 (
    .clk (clk),
    .rst (rst),
    .s_in (s_in),
    .valido (valido),
    .nuevo_numero (nuevo_numero)  // Conectar la nueva señal
  );

endmodule
