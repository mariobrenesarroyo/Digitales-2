module spi_generator (  
    input wire CLK,           // Reloj del sistema  
    input wire RESET,         // Señal de reinicio  
    input wire CKP,           // Polaridad del reloj  
    input wire CPH,           // Fase del reloj  
    input wire [7:0] data_in, // Datos a enviar  
    output reg CS,            // Chip Select  
    output wire SCK,          // Reloj SPI  
    output reg MOSI,          // Master Out Slave In  
    input wire MISO,          // Master In Slave Out  
    output reg [7:0] data_out // Datos recibidos  
);  

reg [7:0] data_shift_reg;      // Registro para desplazar datos de entrada
reg [1:0] contador_sck, prox_contador_sck;
reg SCK_prev;
reg [2:0] EstPresente, ProxEstado;
reg [3:0] bit_counter, prox_bit_counter;

localparam IDLE = 3'b000;
localparam DATA = 3'b001;

// Generación del reloj SPI a 1/4 de la frecuencia de CLK
always @(posedge CLK) begin
    if (!RESET) begin
        SCK_prev     <= 1'b0;
        contador_sck <= 2'b00;
        CS           <= 1'b1;
        EstPresente  <= IDLE;
        data_shift_reg <= data_in;  // Cargar el valor de data_in al registro de desplazamiento
        data_out <= 8'b0;           // Resetear data_out al inicio
        bit_counter <= 0;
    end else begin
        contador_sck <= prox_contador_sck;
        SCK_prev     <= SCK;
        EstPresente  <= ProxEstado;
        bit_counter  <= prox_bit_counter;

    end
end

always @(posedge flanco_dezplazamiento) begin
    if (EstPresente == DATA)begin
            data_shift_reg[0] <= MISO;
            data_shift_reg[1] <= data_shift_reg[0];
            data_shift_reg[2] <= data_shift_reg[1];
            data_shift_reg[3] <= data_shift_reg[2];
            data_shift_reg[4] <= data_shift_reg[3];
            data_shift_reg[5] <= data_shift_reg[4];
            data_shift_reg[6] <= data_shift_reg[5];
            data_shift_reg[7] <= data_shift_reg[6];
        end
end

always @(*) begin
    prox_contador_sck = contador_sck + 1;
end

assign SCK = (EstPresente == IDLE && CKP) ? 1 : (EstPresente == IDLE && !CKP) ? 0 : contador_sck[1];
assign posedge_sck = SCK && !SCK_prev && RESET; // Identifica el flanco positivo
assign negedge_sck = !SCK && SCK_prev && RESET; // Identifica el flanco negativo

// Asignación de flanco basado en CPH
assign flanco_muestreo = ((CPH == 1'b0 && CKP == 1'b0) || (CPH == 1'b0 && CKP == 1'b1)) ? posedge_sck : negedge_sck;
assign flanco_dezplazamiento = ((CPH == 1'b0 && CKP == 1'b0) || (CPH == 1'b0 && CKP == 1'b1)) ? negedge_sck : posedge_sck;

always @(*) begin
    ProxEstado = EstPresente;
    prox_bit_counter = bit_counter;

    case (EstPresente)
        IDLE: begin
            CS = 1'b1;
            ProxEstado = DATA;
            prox_bit_counter = 4'd8;
            data_shift_reg <= data_in;  // Cargar el valor de data_in al registro de desplazamiento
            MOSI = 0;
        end
        DATA: begin
            CS = 1'b0;
            if(bit_counter == 0)begin
                    CS = 1'b1;
                    MOSI = 1'b0;
                end
            
            if (flanco_muestreo) begin
                MOSI = data_shift_reg[7];
                ProxEstado = DATA;

            end else if (flanco_dezplazamiento) begin
                prox_bit_counter = bit_counter - 1;
                if (bit_counter == 8)begin
                    data_out <= data_shift_reg;
                end
                if (bit_counter == 0) begin
                    ProxEstado = IDLE;
                    CS = 1'b1;
                end else begin
                    ProxEstado = DATA;
                end
            end else begin
                ProxEstado = DATA;
            end
end

    endcase
end

endmodule
