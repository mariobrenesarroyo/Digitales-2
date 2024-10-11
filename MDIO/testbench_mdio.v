`include "generador_mdio.v"
`include "objetivo_mdio.v"
  

// Testbench Code Goes here
module mdio_tb;

reg         clock, reset_generador, reset_objetivo, mdio_start_stb;
wire        mdio_in;
reg  [31:0] transaccion;
reg  [15:0] mdio_data_read;
wire [15:0] mdio_data_write;
wire [15:0] reg_addr;
wire        mdc, mdio_out, mdio_oe;

initial begin
	$dumpfile("mdio.vcd");
	$dumpvars(-1, U0);
	$dumpvars(-1, U1);
end


initial begin
  clock = 0;
  reset_generador = 0;
  reset_objetivo  =0;

  #20  reset_generador = 1;
       reset_objetivo  = 1;
  #120 reset_generador = 0;
  #160 reset_objetivo  =0; 
      mdio_start_stb = 0;
      transaccion = 32'h5BA73549;
  #320 mdio_start_stb = 1;
  #40  mdio_start_stb = 0;
  #7800 transaccion = 32'h65557777;
        mdio_data_read = 16'h2468;
  #160  mdio_start_stb = 1;
  #40   mdio_start_stb = 0;
  #8000 $finish;
end

always begin
 #20 clock = !clock;
end


generador_mdio U0 (
/*AUTOINST*/
		   // Outputs
		   .mdio_out		(mdio_out),
		   .mdio_oe		(mdio_oe),
		   .mdc			(mdc),
		   // Inputs
		   .clk			(clock),
		   .reset		(reset_generador),
		   .start_stb		(mdio_start_stb),
		   .mdio_in		(mdio_in),
		   .transaccion		(transaccion[31:0]));


objetivo_mdio U1 (
/*AUTOINST*/
		  // Outputs
		  .reg_addr		(reg_addr[4:0]),
		  .mdio_in		(mdio_in),
		  // Inputs
		  .mdc			(mdc),
		  .reset		(reset_objetivo),
		  .mdio_out		(mdio_out),
		  .mdio_oe		(mdio_oe),
		  .dato_leido    	(mdio_data_read[15:0]));


endmodule
