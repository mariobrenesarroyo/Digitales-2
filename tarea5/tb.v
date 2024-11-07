`include "generadorSPI.v"

module tb_spi_generator;

  reg CLK;
  reg RESET;
  reg CKP;
  reg CPH;
  reg [7:0] data_in;
  wire CS;
  wire SCK;
  wire MOSI;
  reg MISO;
  wire [7:0] data_out;

  spi_generator uut (
    .CLK(CLK),
    .RESET(RESET),
    .CKP(CKP),
    .CPH(CPH),
    .data_in(data_in),
    .CS(CS),
    .SCK(SCK),
    .MOSI(MOSI),
    .MISO(MISO),
    .data_out(data_out)
  );

  initial begin
    // Initialize inputs
    CLK = 0;
    RESET = 0;
    CKP = 0;
    CPH = 0;
    data_in = 8'd1;
    MISO = 0;

    // Apply reset
    #10 RESET = 1;


    // Complete simulation after sufficient time
    #400 $finish;
  end

  always #5 CLK = ~CLK; // Clock generation with a period of 10 time units

  initial begin
    // Enable wave dumping
    $dumpfile("resultados.vcd");
    $dumpvars(0, tb_spi_generator);
  end

endmodule
