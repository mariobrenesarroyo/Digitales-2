module sintetizar (resultado, operando, entrada, clk);
  input operando, entrada, clk;
  output reg resultado;
  reg valor;

  always @(*)
  begin
    valor = 1'b0;
    if ((entrada == 1'b1) && (operando == 1'b1)) valor = 1'b1;
  end

  always @(posedge clk) resultado <= valor;
endmodule
