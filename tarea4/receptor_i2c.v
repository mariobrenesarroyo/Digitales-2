module receptor_i2c(
    input wire clk,           // Reloj de entrada
    input wire reset,         // Señal de reinicio
    input wire [6:0] i2c_addr,// Dirección I2C del receptor
    input wire scl,           // Entrada de reloj I2C
    input wire sda_out,       // Entrada serial (SDA)
    input wire sda_oe,        // Habilitación de salida de datos serial
    output reg sda_in,        // Salida serial (SDA)
    output reg [15:0] wr_data,// Datos recibidos
    input wire [15:0] rd_data // Datos a enviar
);

    // Estados del FSM
    localparam IDLE = 3'b000, START = 3'b001, ADDR = 3'b010, DATA = 3'b011, ACK = 3'b100, STOP = 3'b101;

    // Variables internas
    reg [2:0] estado, prox_estado;
    reg [3:0] bit_count;
    reg [7:0] data_buffer;
    reg [6:0] addr_buffer;

    // Inicialización de registros
    initial begin
        estado = IDLE;
        prox_estado = IDLE;
        bit_count = 0;
        sda_in = 1;
        wr_data = 0;
        data_buffer = 0;
        addr_buffer = 0;
    end

    // Máquina de estados finita (FSM)
    always @(posedge clk) begin
        if (~reset) begin
            estado <= IDLE;
            bit_count <= 0;
            sda_in <= 1;
            wr_data <= 0;
            data_buffer <= 0;
            addr_buffer <= 0;
        end else begin
            estado <= prox_estado;
        end
    end

    always @(*) begin
        prox_estado = estado;
        case (estado)
            IDLE: begin
                if (sda_out == 0 && scl == 1) begin // Condición de START
                    prox_estado <= START;
                end
            end
            START: begin
                if (scl == 1) begin
                    prox_estado <= ADDR;
                    bit_count <= 0;
                end
            end
            ADDR: begin
                if (scl == 1) begin
                    addr_buffer[6 - bit_count] <= sda_out;
                    bit_count <= bit_count + 1;
                    if (bit_count == 6) begin
                        if (addr_buffer == i2c_addr) begin
                            prox_estado <= DATA;
                        end else begin
                            prox_estado <= IDLE;
                        end
                        bit_count <= 0;
                    end
                end
            end
            DATA: begin
                if (scl == 1) begin
                    data_buffer[7 - bit_count] <= sda_out;
                    bit_count <= bit_count + 1;
                    if (bit_count == 7) begin
                        wr_data <= {wr_data[7:0], data_buffer};
                        prox_estado <= ACK;
                        bit_count <= 0;
                    end
                end
            end
            ACK: begin
                if (scl == 1) begin
                    sda_in <= 0; // Enviar ACK
                    prox_estado <= STOP;
                end
            end
            STOP: begin
                if (sda_out == 1 && scl == 1) begin // Condición de STOP
                    prox_estado <= IDLE;
                end
            end
        endcase
    end

endmodule
