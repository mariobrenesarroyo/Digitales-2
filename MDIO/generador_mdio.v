module generador_mdio(
   // Outputs
   mdio_out, mdio_oe, mdc, dato_leido,
   // Inputs
   clk, reset, start_stb, mdio_in, transaccion
   );

  //Entradas y salidas
  input clk,reset,start_stb,mdio_in;
  input [31:0] transaccion;
  output reg mdio_out, mdio_oe;
  output     mdc;
  output reg [15:0] dato_leido;

  localparam INICIO    = 3'b001;
  localparam ESCRITURA = 3'b010;
  localparam LECTURA   = 3'b100;
  localparam DIV_FREQ  = 2;

  //Variables intermedias
  reg [2:0] estado, prox_estado;
  reg [4:0] cuenta_bits, prox_cuenta_bits;
  reg [DIV_FREQ-1:0] div_freq;
  reg start_stb_d, start_stb_reg;
  wire iniciar, escritura, lectura;
  wire posedge_mdc;
  reg mdc_anterior, prox_mdio_out;

  assign iniciar   = (transaccion[31:30] == 2'b01);
  assign escritura = (transaccion[29:28] == 2'b01);
  assign lectura = (transaccion[29:28] == 2'b10);
  //MDC a fraccion del clk
  assign mdc = div_freq[DIV_FREQ-1];
  assign posedge_mdc = !mdc_anterior && mdc;

  //Fip flops
  always @(posedge clk) begin
    if (reset) begin
      estado       <= INICIO;
      cuenta_bits  <= 0;
      div_freq     <= 0;
      mdc_anterior <= 0;
      mdio_out     <= 0;
      start_stb_reg <= 0;
      start_stb_d  <= 0;
    end else begin
      estado        <= prox_estado;
      cuenta_bits   <= prox_cuenta_bits;
      div_freq      <= div_freq+1;
      mdc_anterior  <= mdc;
      mdio_out      <= prox_mdio_out;
      start_stb_reg <= start_stb;
      start_stb_d   <= start_stb_reg;
    end
  end

  //Logica combinacional

/*  always @(posedge mdc) begin
     if (estado == ESCRITURA) prox_cuenta_bits = cuenta_bits+1;
  end */

  always @(*) begin
    prox_estado = estado;
    prox_cuenta_bits = cuenta_bits;
    prox_mdio_out = mdio_out;

    case (estado)
	    INICIO: begin
		    mdio_oe = 1'b0;
		    prox_cuenta_bits = 0;
		    if (iniciar && lectura && (start_stb || start_stb_d) && posedge_mdc)   prox_estado = LECTURA;
		    if (iniciar && escritura && (start_stb || start_stb_d) && posedge_mdc) prox_estado = ESCRITURA;
	    end
	    ESCRITURA: begin
		mdio_oe = 1'b1;
//		prox_mdio_out = transaccion[31-cuenta_bits];
		if (posedge_mdc) begin 
		   prox_cuenta_bits = cuenta_bits+1;
		   prox_mdio_out = transaccion[31-cuenta_bits];
		   if (cuenta_bits == 31) prox_estado = INICIO;
                end

            end
	    LECTURA: begin
		mdio_oe = (cuenta_bits < 16);
                if (posedge_mdc) prox_mdio_out = transaccion[31-cuenta_bits];
                if (!mdio_oe) dato_leido[31-cuenta_bits] = mdio_in;
	        if (posedge_mdc) prox_cuenta_bits = cuenta_bits+1;
		if (cuenta_bits == 31) prox_estado = INICIO;
	    end
            default: begin
	    end
    endcase;
  end
endmodule
