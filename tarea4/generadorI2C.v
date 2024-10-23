module i2c_transaction_generator (
    input wire clk,             // Señal de reloj de entrada
    input wire rst,           // Señal de reinicio
    input wire start_stb,       // Señal de inicio de transacción
    input wire rnw,             // Señal de lectura/escritura
    input wire [6:0] i2c_addr,  // Dirección I2C
    input wire [15:0] wr_data,  // Datos a escribir
    input wire sda_in,          // Datos de entrada
    output     scl,             // Señal de reloj I2C
    output reg sda_out,         // Salida de datos serial
    output reg sda_oe,          // Habilitación de salida de datos serial
    output reg [15:0] rd_data   // Datos leídos
);

reg [1:0] contador_scl, prox_contador_scl ;
reg [3:0] bit_counter, prox_bit_counter ;
reg [7:0] i2c_direccion_rw ;
reg [3:0] EstPresente, ProxEstado;

//estados
localparam IDLE          = 4'b0000;
localparam START         = 4'b0001;
localparam SLAVE_ADDRESS = 4'b0010;
localparam ACK           = 4'b0011;
localparam LECTURA_1     = 4'b0100;
localparam ESCRITURA_1   = 4'b0101;
localparam STOP          = 4'b0110;
localparam ESCRITURA_2   = 4'b0111;
localparam LECTURA_2     = 4'b1000;
localparam WAITACK       = 4'b1001;
localparam WAITACK_2     = 4'b1010;



always @(posedge clk) begin
    if (~rst) begin
        contador_scl <= 2'b00;
        bit_counter  <= 4'b0000;
        sda_out      <= 1'b1;
        sda_oe       <= 1'b1;
        EstPresente  <= IDLE;
        rd_data      <= 16'd0;
        i2c_direccion_rw <= {i2c_addr,rnw};
    end else begin
        contador_scl <= prox_contador_scl;
        EstPresente <= ProxEstado;
        bit_counter <= prox_bit_counter;

        // Actualizar rd data solo si flanco positvo de scl
            if ((contador_scl == 2'b10) && (EstPresente == LECTURA_1 || EstPresente == LECTURA_2)) begin
                rd_data <= {rd_data[14:0], sda_in};
            end
    end
end


//funcionamiento de frecuencia de 1/4 de reloj de scl con respecto al clk
assign scl = (contador_scl[1]) || (EstPresente == IDLE) || (EstPresente == START) || (EstPresente == STOP);


always @(*)begin
    ProxEstado = EstPresente;
    prox_contador_scl = contador_scl + 1;
    case(EstPresente)
        IDLE: begin
            sda_out = 1'b1;
            sda_oe  = 1'b1;
            if(start_stb)begin
                ProxEstado = START;
            end
            else begin
                ProxEstado = IDLE;

            end
        end
        START: begin
            sda_out = 1'b0;
            sda_oe  = 1'b1;
            ProxEstado = SLAVE_ADDRESS;
            prox_bit_counter = 4'd7;  // Uso de prox_bit_counter en lugar de bit_counter
        end
        SLAVE_ADDRESS: begin
            sda_oe = 1'b1;
            if(contador_scl == 2'b10) begin
                sda_out = i2c_direccion_rw[bit_counter];  // Usas bit_counter que se actualiza secuencialmente
                prox_bit_counter = bit_counter - 1;
                if(bit_counter == 0) begin
                    sda_oe = 1'b0;
                    ProxEstado = ACK;
                end else begin
                    ProxEstado = SLAVE_ADDRESS;
                end
            end else begin
                ProxEstado = SLAVE_ADDRESS;
            end
        end
        ACK: begin
            sda_oe = 1'b0;
            prox_bit_counter = 4'd15;
            if(contador_scl == 2'b10 && sda_in == 1'b0)begin
                if(i2c_direccion_rw[0])begin
                    ProxEstado = LECTURA_1;
                end
                else begin
                    ProxEstado = ESCRITURA_1;
                end              
            end
            else begin
                ProxEstado = ACK;
                
            end
        end
        ESCRITURA_1: begin
            sda_oe = 1'b1;
            if(contador_scl == 2'b10) begin
                sda_out = wr_data[bit_counter];  // Usas bit_counter que se actualiza secuencialmente
                prox_bit_counter = bit_counter - 1;
                if(bit_counter == 8) begin
                    ProxEstado = WAITACK;
                end else begin
                    ProxEstado = ESCRITURA_1;
                end
            end else begin
                ProxEstado = ESCRITURA_1;
            end
        end
        LECTURA_1:begin
            sda_oe = 1'b0;
            // Actualizar rd_data solo en flanco positivo de scl
            if (contador_scl == 2'b10) begin
                prox_bit_counter = bit_counter - 1;
                if(bit_counter == 8) begin
                    ProxEstado = WAITACK;
                end else begin
                    ProxEstado = LECTURA_1;
                end
            end else begin
                ProxEstado = LECTURA_1;
                
                

            end
        end
        WAITACK: begin
            if(contador_scl == 2'b10) begin
                if(rnw)begin
                    sda_out = 1'b0;
                    sda_oe  = 1'b1;
                    ProxEstado = LECTURA_2;
                    prox_bit_counter = 4'd7;
                end
                else begin
                    sda_oe = 1'b0;
                    sda_out = 1'b0;
                    if(sda_in) begin
                        ProxEstado = WAITACK;
                    end
                    else begin
                        ProxEstado = ESCRITURA_2;
                        prox_bit_counter = 4'd7;
                    end
                end
            end
            else ProxEstado = WAITACK;
        end
        ESCRITURA_2: begin
            sda_oe = 1'b1;
            if(contador_scl == 2'b10) begin
                sda_out = wr_data[bit_counter];  // Usas bit_counter que se actualiza secuencialmente
                prox_bit_counter = bit_counter - 1;
                if(bit_counter == 0) begin
                    ProxEstado = WAITACK_2;
                end else begin
                    ProxEstado = ESCRITURA_2;
                end
            end 
            else begin
                ProxEstado = ESCRITURA_2;
            end
        end
        LECTURA_2:begin
            sda_oe = 1'b0;
            // Actualizar rd_data solo en flanco positivo de scl
            if (contador_scl == 2'b10) begin
                prox_bit_counter = bit_counter - 1;
                if(bit_counter == 0) begin
                    ProxEstado = WAITACK_2;
                end else begin
                    ProxEstado = LECTURA_2;
                end
            end else begin
                ProxEstado = LECTURA_2;
            end
        end
        WAITACK_2: begin
            if(contador_scl == 2'b10) begin
                if(rnw)begin
                    sda_out = 1'b0;
                    sda_oe = 1'b1;
                    ProxEstado = STOP;

                end
                else begin
                    sda_oe = 1'b0;
                    if(sda_in) ProxEstado = WAITACK_2;
                    else ProxEstado = STOP;
                end
            end
            else begin
                ProxEstado = WAITACK_2;
            end
        end    
        STOP: begin
            sda_oe = 1'b1;
            sda_out = 1'b0;
            ProxEstado = IDLE;
        end
    endcase
end
endmodule