`include "generador_I2C.v"
`include "receptor_i2c.v"

module testbench;
    // Definir señales
    reg clk;
    reg reset;
    reg start_stb;
    reg rnw;
    reg [6:0] i2c_addr;
    reg [15:0] wr_data;
    wire scl;
    wire sda_out;
    wire sda_oe;
    wire [15:0] rd_data;
    wire sda_in;

    // Instanciar el generador y receptor
    generador_i2c generador (
        .clk(clk),
        .reset(reset),
        .start_stb(start_stb),
        .rnw(rnw),
        .i2c_addr(i2c_addr),
        .wr_data(wr_data),
        .sda_in(sda_in),
        .scl(scl),
        .sda_out(sda_out),
        .sda_oe(sda_oe),
        .rd_data(rd_data)
    );

    receptor_i2c receptor (
        .clk(clk),
        .reset(reset),
        .scl(scl),
        .sda_out(sda_out),
        .sda_in(sda_in)
    );

    // Generación de reloj
    always #10 clk = ~clk;

    initial begin
        // Inicializar señales
        clk = 0;
        reset = 0;
        start_stb = 0;
        rnw = 0;
        i2c_addr = 7'b1011110; // Dirección según los dos últimos dígitos del carné (94 decimal)
        wr_data = 16'hABCD;    // Datos de ejemplo para la transacción de escritura

        // Reiniciar el sistema
        #10 reset = 0;
        #10 reset = 1;

        // Transacción de escritura (2 bytes)
        #20 start_stb = 1;
        #20 start_stb = 0;
        #40; // Simular un tiempo suficiente para la transacción de escritura

    
        #200 $finish;
    end

    // Inicializar GTKWAVE para la visualización
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end
endmodule