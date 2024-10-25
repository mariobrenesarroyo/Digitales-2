module tester_i2c(
    output reg clk,
    output reg rst,
    output reg start_stb,
    output reg rnw,
    output reg [6:0] i2c_addr_g,
    output reg [15:0] wr_data_g,
    output reg [15:0] rd_data_r,
    input wire [15:0] rd_data_g,
    input wire scl,
    input wire sda_out,
    input wire sda_oe,
    input wire sda_in
);

    // Generación del reloj
    always #5 clk = ~clk;  // Periodo de 10 unidades de tiempo

    // Procedimiento de prueba
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        start_stb = 0;
        rnw = 1'b1;  // escribir es 0 y leer es 1
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
