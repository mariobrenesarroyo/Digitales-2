module generador_i2c(
    input wire clk, reset, start_stb, rnw, sda_in,
    input wire [6:0] i2c_addr,           // Dirección I2C del dispositivo
    input wire [15:0] wr_data,           // Datos a escribir
    output reg scl, sda_out, sda_oe,
    output reg [15:0] rd_data            // Datos leídos
);

    localparam IDLE = 3'b000, START = 3'b001, ADDR = 3'b010, DATA = 3'b011, STOP = 3'b100;

    reg [2:0] estado, prox_estado;
    reg [2:0] contador_scl, prox_contador_scl;
    reg [3:0] bit_count, prox_bit_count;
    reg ack_received;

    always @(posedge clk) begin
        if (!reset) begin
            estado <= IDLE;
            contador_scl <= 3'b001;
            bit_count <= 0;
            sda_out <= 1;
            sda_oe <= 0;
            rd_data <= 0;
            scl <= 0;
            ack_received <= 0;
        end else begin
            contador_scl <= prox_contador_scl; 
            estado <= prox_estado;
            bit_count <= prox_bit_count;
            ack_received <= 0;
        end
    end

    always @(*) begin
        if (contador_scl == 3'b100) begin
            prox_contador_scl = 3'b001; 
        end else begin
            prox_contador_scl = contador_scl + 1; 
        end
        scl = contador_scl[2]; 
    end

    always @(*) begin
        prox_estado = estado;
        prox_bit_count = bit_count;

        case (estado)
            IDLE: begin
                if (start_stb) begin
                    prox_estado = START;
                    sda_out = 0;
                    sda_oe = 1;
                    prox_bit_count = 0;
                end
            end

            START: begin
                if (scl) begin
                    prox_estado = ADDR;
                end
            end

            ADDR: begin
                if (bit_count < 7) begin
                    sda_out = i2c_addr[6 - bit_count];
                    prox_bit_count = bit_count + 1;
                end else begin
                    sda_out = rnw;
                    prox_estado = DATA;
                    prox_bit_count = 0;
                end
            end

            DATA: begin
                if (!rnw) begin
                    if (bit_count < 16) begin
                        sda_out = wr_data[15 - bit_count];
                        prox_bit_count = bit_count + 1;
                    end else begin
                        prox_estado = STOP;
                    end
                end else begin
                    if (bit_count < 16) begin
                        sda_out = sda_in;
                        prox_bit_count = bit_count + 1;
                    end else begin
                        prox_estado = STOP;
                    end
                end
            end

            STOP: begin
                if (scl) begin
                    sda_out = 1;
                    sda_oe = 0;
                    prox_estado = IDLE;
                end
            end
        endcase
    end

endmodule
