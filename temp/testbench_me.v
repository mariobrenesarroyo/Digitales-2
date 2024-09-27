`include "probador_me.v"
`include "me_op1.v"
                                        
// Testbench Code Goes here
module me_tb;

  wire clk, rst, s_in,valido;

  initial begin
	$dumpfile("resultados.vcd");
	$dumpvars(-1, MEOP1);
  end

  det_sec MEOP1 (
    .clk (clk),
    .rst (rst),
    .s_in (s_in),
    .valido (valido));

  probador PROB_MEOP1 (
    .clk (clk),
    .rst (rst),
    .s_in (s_in),
    .valido (valido));

endmodule
