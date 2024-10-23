`include "generadorI2C.v"
`include "receptor_i2c.v"

module tb_i2c_transaction;

    // Señales de entrada y salida compartidas
    reg clk;
    reg rst;
    wire scl;
    wire sda_out;
    wire sda_oe;
    wire sda_in;

    // Señales específicas del generador
    reg start_stb;
    reg rnw;
    reg [6:0] i2c_addr_g;
    reg [15:0] wr_data_g;
    wire [15:0] rd_data_g;

    // Señales específicas del receptor
    reg [15:0] rd_data_r;   // Establecido a 16'h9875
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

    // Generación del reloj
    always #5 clk = ~clk;  // Periodo de 10 unidades de tiempo

    // Procedimiento de prueba
    initial begin
        // Crear archivo VCD para GTKWAVE
        $dumpfile("prueba1.vcd");    // Nombre del archivo VCD
        $dumpvars(0, tb_i2c_transaction);  // Volcar todas las variables del testbench

        // Inicialización de señales
        clk = 0;
        rst = 0;
        start_stb = 0;
        rnw = 1'b1;  // leer
        i2c_addr_g = 7'd94;  // Dirección I2C
        wr_data_g = 16'hABC3;
        rd_data_r = 16'h54AC;  // Establecer el valor de rd_data del receptor

        // Reiniciar el sistema
        #10 rst = 0;  // Aplicar reinicio
        #20 rst = 1;  // Quitar reinicio

        // Esperar un ciclo y comenzar la transacción
        #30 start_stb = 1;  // Señal de inicio
        #10 start_stb = 0;

        // Esperar para observar el comportamiento
        #1200;


        // Finalizar simulación
        $finish;
    end

endmodule
