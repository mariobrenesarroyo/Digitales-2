`include "generadorI2C.v"
`include "receptor_i2c.v"
`include "tester_i2c.v"

module tb_i2c_transaction;

    // Señales de entrada y salida compartidas
    wire clk;
    wire rst;
    wire scl;
    wire sda_out;
    wire sda_oe;
    wire sda_in;

    // Señales específicas del generador
    wire start_stb;
    wire rnw;
    wire [6:0] i2c_addr_g;
    wire [15:0] wr_data_g;
    wire [15:0] rd_data_g;

    // Señales específicas del receptor
    wire [15:0] rd_data_r;
    wire [15:0] wr_data_r;
    wire [6:0] i2c_addr_r;

    // Instanciación del módulo generador
    i2c_transaction_generator generator (
        .clk(clk),
        .rst(rst),
        .start_stb(start_stb),
        .rnw(rnw),
        .i2c_addr(i2c_addr_g),
        .wr_data(wr_data_g),
        .sda_in(sda_in),
        .scl(scl),
        .sda_out(sda_out),
        .sda_oe(sda_oe),
        .rd_data(rd_data_g)
    );

    // Instanciación del módulo receptor
    i2c_transaction_receiver receiver (
        .clk(clk),
        .rst(rst),
        .i2c_addr(i2c_addr_r),
        .scl(scl),
        .sda_out(sda_out),
        .sda_oe(sda_oe),
        .sda_in(sda_in),
        .wr_data(wr_data_r),
        .rd_data(rd_data_r)
    );

    // Instanciación del módulo tester
    tester_i2c tester (
        .clk(clk),
        .rst(rst),
        .start_stb(start_stb),
        .rnw(rnw),
        .i2c_addr_g(i2c_addr_g),
        .wr_data_g(wr_data_g),
        .rd_data_r(rd_data_r),
        .rd_data_g(rd_data_g),
        .scl(scl),
        .sda_out(sda_out),
        .sda_oe(sda_oe),
        .sda_in(sda_in)
    );

    // Configuración de VCD para GTKWAVE
    initial begin
        $dumpfile("prueba1.vcd");      // Nombre del archivo VCD
        $dumpvars(0, tb_i2c_transaction);  // Volcar todas las variables del testbench
    end

endmodule
