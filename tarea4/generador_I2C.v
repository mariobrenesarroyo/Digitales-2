module generador_i2c(
    input wire clk,           // Reloj de entrada
    input wire reset,         // Señal de reinicio
    input wire start_stb,     // Señal de inicio de transacción
    input wire rnw,           // Señal de lectura/escritura
    input wire [6:0] i2c_addr,// Dirección I2C del dispositivo
    input wire [15:0] wr_data,// Datos a escribir
    input wire sda_in,        // Entrada de datos serial
    output reg scl,           // Salida de reloj I2C
    output reg sda_out,       // Salida de datos serial
    output reg sda_oe,        // Habilitación de salida de datos serial
    output reg [15:0] rd_data // Datos leídos
);

    // Parámetro para definir el divisor de frecuencia
    localparam DIVISOR = 4; // 25% de la frecuencia de clk

    // Estados del FSM
    localparam IDLE = 3'b000, START = 3'b001, ADDR = 3'b010, DATA = 3'b011, STOP = 3'b100;

    // Variables internas
    reg [2:0] estado, prox_estado;
    reg [1:0] contador;
    reg [3:0] bit_count;
    reg [15:0] data_buffer;

    // Generación de la señal SCL
    always @(posedge clk) begin
        if (~reset) begin
            contador <= 0;
            scl <= 0;
        end else begin
            if (contador == (DIVISOR - 1)) begin
                contador <= 0;
                scl <= ~scl; // Invertir el estado de SCL
            end else begin
                contador <= contador + 1;
            end
        end
    end

    // Máquina de estados finita (FSM)
    always @(posedge clk) begin
        if (reset) begin
            estado <= IDLE;
            bit_count <= 0;
            sda_out <= 1;
            sda_oe <= 0;
            rd_data <= 0;
            data_buffer <= 0;
        end else begin
            estado <= prox_estado;
        end
    end

    always @(*) begin
        case (estado)
            IDLE: begin
                if (start_stb) begin
                    prox_estado = START;
                    sda_out = 0; // Condición de START: bajar SDA mientras SCL está en alto
                    sda_oe = 1;
                end
            end
            START: begin
                if (scl) begin
                    prox_estado = ADDR;
                    bit_count = 0;
                    data_buffer = {i2c_addr, rnw}; // Dirección + bit de lectura/escritura
                end
            end
            ADDR: begin
                if (scl) begin
                    sda_out = data_buffer[6 - bit_count];
                    bit_count = bit_count + 1;
                    if (bit_count == 7) begin
                        prox_estado = DATA;
                        bit_count = 0;
                        if (rnw) begin
                            sda_oe = 0; // Liberar el bus para lectura
                        end else begin
                            data_buffer = wr_data; // Preparar datos para escritura
                        end
                    end
                end
            end
            DATA: begin
                if (scl) begin
                    if (rnw) begin
                        rd_data[15 - bit_count] = sda_in; // Leer datos
                    end else begin
                        sda_out = data_buffer[15 - bit_count]; // Escribir datos
                    end
                    bit_count = bit_count + 1;
                    if (bit_count == 15) begin
                        prox_estado <= STOP;
                    end
                end
            end
            STOP: begin
                if (scl) begin
                    sda_out = 1; // Condición de STOP: poner SDA en alto mientras SCL está en alto
                    sda_oe = 1;
                    prox_estado = IDLE;
                end
            end
        endcase
    end

endmodule
