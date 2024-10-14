module generador_i2c(
    input wire clk, reset, start_stb, rnw, sda_in,
    input wire [6:0] i2c_addr,           // Dirección I2C del dispositivo
    input wire [15:0] wr_data,           // Datos a escribir
    output reg scl, sda_out, sda_oe,
    output reg [15:0] rd_data            // Datos leídos
);

    // Estados del generador I2C
    localparam IDLE = 3'b000, START = 3'b001, ADDR = 3'b010, DATA = 3'b011, STOP = 3'b100;
    reg [2:0] estado, prox_estado;
    reg [2:0] contador_scl, prox_contador_scl;
    reg [3:0] bit_count, prox_bit_count;

    always @(posedge clk)begin
        if (~reset)begin
            contador_scl = 3'b000;
            estado <= IDLE;
            bit_count <= 4'b0000;
            scl <= 0;
            sda_out <= 0;
            sda_oe <= 0;
        end
    end

endmodule