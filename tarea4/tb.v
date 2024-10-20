`include "generadorI2C.v"
module tb_i2c_transaction_generator;

    // Señales de entrada
    reg clk;
    reg rst;
    reg start_stb;
    reg rnw;
    reg [6:0] i2c_addr;
    reg [15:0] wr_data;
    reg sda_in;

    // Señales de salida
    wire scl;
    wire sda_out;
    wire sda_oe;
    wire [15:0] rd_data;

    // Instanciación del módulo a probar
    i2c_transaction_generator uut (
        .clk(clk),
        .rst(rst),
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

    // Generación del reloj
    always #5 clk = ~clk;  // Periodo de 10 unidades de tiempo

    // Procedimiento de prueba
    initial begin
        // Crear archivo VCD para GTKWAVE
        $dumpfile("prueba1.vcd");    // Nombre del archivo VCD
        $dumpvars(0, tb_i2c_transaction_generator);  // Volcar todas las variables del testbench

        // Inicialización de señales
        clk = 0;
        rst = 0;
        start_stb = 0;
        rnw = 1;  // Leer
        i2c_addr = 7'd94;  // Dirección I2C
        wr_data = 16'h0000;
        sda_in = 1'b0;  // Línea de datos en reposo

        // Reiniciar el sistema
        #10 rst = 0;  // Aplicar reinicio
        #20 rst = 1;  // Quitar reinicio

        // Esperar un ciclo y comenzar la transacción
        #30 start_stb = 1;  // Señal de inicio
        #10 start_stb = 0;

        // Esperar para observar el comportamiento
        #500;

        // Finalizar simulación
        $finish;
    end

endmodule
