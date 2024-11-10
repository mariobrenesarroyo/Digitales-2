`include "generadorSPI.v"
`include "receptorSPI.v"

module tb_spi_generator;

  reg CLK;
  reg RESET;
  reg CKP;
  reg CPH;
  reg [7:0] data_in;
  wire CS;
  wire SCK;
  wire MOSI,MOSI_2,MOSI_3;
  wire MISO,MISO_2,MISO_3;
  wire [7:0] data_out_generador, data_out_reciever1,data_out_reciever2;

  // Instancia del generador SPI
  spi_generator spi_gen (
    .CLK(CLK),
    .RESET(RESET),
    .CKP(CKP),
    .CPH(CPH),
    .data_in(data_in),
    .CS(CS),
    .SCK(SCK),
    .MOSI(MOSI),
    .MISO(MISO_3),                 // MISO conectado al MISO del receptor
    .data_out(data_out_generador)
  );

  // Instancia del receptor SPI
  spi_receiver spi_recv1 (
    .SCK(SCK),                   // Conexión del reloj SPI
    .SS(CS),                     // Selección de esclavo
    .CKP(CKP),
    .CPH(CPH),
    .MOSI(MOSI),                 // Conexión de MOSI desde el generador
    .MISO(MISO_2),                 // Conexión de MISO del receptor hacia el generador
    .data_out(data_out_reciever1)
  );

  spi_receiver spi_recv2 (
    .SCK(SCK),                   // Conexión del reloj SPI
    .SS(CS),                     // Selección de esclavo
    .CKP(CKP),
    .CPH(CPH),
    .MOSI(MISO_2),                 // Conexión de MOSI desde el generador
    .MISO(MISO_3),                 // Conexión de MISO del receptor hacia el generador
    .data_out(data_out_reciever2)
  );

  initial begin
    // Inicialización de las entradas
    CLK = 0;
    RESET = 0;
    CKP = 1;
    CPH = 1;
    data_in = 8'd1;

    // Aplicar reset
    #10 RESET = 1;
    #390 data_in = 8'd9;
    #345 data_in = 8'd4;

    // Finalizar simulación después de un tiempo suficiente
    #1700 $finish;
  end

  always #5 CLK = ~CLK; // Generación del reloj con un período de 10 unidades de tiempo

  initial begin
    // Habilitar el volcado de ondas
    $dumpfile("resultados.vcd");
    $dumpvars(0, tb_spi_generator);
  end

endmodule
