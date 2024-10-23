module i2c_transaction_receiver (
    input wire clk,              // Señal de reloj de entrada desde el CPU
    input wire rst,              // Entrada de reinicio
    output reg [6:0] i2c_addr,   // Dirección del receptor de transacciones
    input wire scl,              // Señal de reloj I2C
    input wire sda_out,          // Entrada serial (datos)
    input wire sda_oe,           // Habilitación de SDA_OUT (entrada)
    output reg sda_in,           // Salida serial enviada desde el receptor
    output reg [15:0] wr_data,   // Salida paralela (datos recibidos)
    input wire [15:0] rd_data    // Entrada paralela (datos a enviar)
);

reg [3:0] bit_counter, prox_bit_counter;
reg [3:0] EstPresente, ProxEstado;
reg scl_prev;  // Registro para almacenar el estado anterior de scl

// Estados
localparam ESPERA        = 4'b0000;
localparam SLAVE_ADDRESS = 4'b0010;
localparam ACK           = 4'b0011;
localparam DATA          = 4'b0100;
localparam WAITACK       = 4'b0101;
localparam DATA_2        = 4'b0110;
localparam WAITACK_2     = 4'b0111;

// Detectar flanco positivo de scl
wire posedge_scl = scl && !scl_prev && rst;
wire negedge_scl = !scl && scl_prev && rst;  // Detectar flanco negativo para sincronización

always @(posedge clk) begin
    if (~rst) begin
        EstPresente <= ESPERA;
        scl_prev <= 1'b1;
        wr_data <= 16'd0;
        i2c_addr <= 7'd0;
        bit_counter <= 4'd6;
    end else begin
        EstPresente <= ProxEstado;
        bit_counter <= prox_bit_counter;
        scl_prev <= scl;

        // Actualizar wr_data en flanco positivo de scl y en estado de escritura
        if (posedge_scl && sda_oe && ((EstPresente == DATA && (bit_counter >= 8)) || EstPresente == DATA_2 && (7 >= bit_counter) )) begin
            wr_data <= {wr_data[14:0], sda_out};
        end

        // Actualizar i2c_addr en flanco positivo de scl mientras se recibe la dirección
        if (posedge_scl && EstPresente == SLAVE_ADDRESS && sda_oe) begin
            i2c_addr <= {i2c_addr[5:0], sda_out};
        end
    end
end

always @(*) begin
    ProxEstado = EstPresente;
    prox_bit_counter = bit_counter;
    sda_in = 1'b1;

    case (EstPresente)
        ESPERA: begin
            if(!sda_out && scl)begin
                ProxEstado = SLAVE_ADDRESS;
                prox_bit_counter = 4'd7;
            end
        end
        SLAVE_ADDRESS: begin
            if (posedge_scl) begin
                prox_bit_counter = bit_counter - 1;
                if (bit_counter == 0) begin
                    ProxEstado = ACK;
                end
            end
        end
        ACK: begin
            if (posedge_scl) begin
                sda_in = 1'b0;  // Acknowledge enviado por el receptor
                ProxEstado = DATA;
                prox_bit_counter = 4'd15;
            end
        end
        DATA: begin
            if (posedge_scl) begin
                if (sda_oe) begin
                    prox_bit_counter = bit_counter - 1;
                    if (bit_counter == 8) begin
                        ProxEstado = WAITACK;
                    end
                end else begin
                    // Receptor enviando datos (lectura)
                    sda_in = rd_data[1 + bit_counter];
                    prox_bit_counter = bit_counter - 1;
                    if (bit_counter == 0) begin
                        ProxEstado = WAITACK;
                    end
                end
            end
        end
        WAITACK: begin
            if (posedge_scl) begin
                prox_bit_counter = 4'd8;
                if (sda_oe) begin
                    if (sda_out) ProxEstado = WAITACK;
                    else ProxEstado = DATA_2;
                end else begin
                    ProxEstado = DATA_2;
                end
            end
        end
        DATA_2: begin
            if (posedge_scl) begin
                if (sda_oe) begin
                    prox_bit_counter = bit_counter - 1;
                    if (bit_counter == 0) begin
                        ProxEstado = WAITACK_2;
                    end
                end else begin
                    sda_in = rd_data[bit_counter];
                    prox_bit_counter = bit_counter - 1;
                    if (bit_counter == 0) begin
                        ProxEstado = WAITACK_2;
                    end
                end
            end
        end
        WAITACK_2: begin
            if (posedge_scl) begin
                if (sda_oe) begin
                    if (sda_out) ProxEstado = WAITACK_2;
                    else ProxEstado = ESPERA;
                end else begin
                    ProxEstado = ESPERA;
                end
            end
        end
    endcase
end

endmodule
