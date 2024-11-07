module transmit (
    input wire [7:0] TXD,        // Datos de 8 bits
    input wire TX_EN,            // Habilitación de transmisión
    input wire TX_ER,            // Señal de error
    input wire GTX_CLK,          // Reloj
    output reg [9:0] tx_code_group // Datos de 10 bits codificados
);

    // Señal para determinar la polaridad de la corriente (disparidad)
    reg running_disparity = 1'b0; // Inicialización de la disparidad

    always @(posedge GTX_CLK) begin
        if (TX_EN) begin
            // Caso para D0.0 (octeto 00 - "0000 0000")
            case (TXD)
                8'h00: tx_code_group <= (running_disparity) ? 10'b0110001011 : 10'b1001110100; // RD+ y RD- para D0.0
                // Agregar más casos para otros grupos de código según la tabla 8B/10B
                default: tx_code_group <= 10'bxxxxxxxxxx; // Valores por defecto para manejo de error o códigos no mapeados
            endcase
            // Invertir la disparidad después de cada transmisión para balancear la corriente
            running_disparity <= ~running_disparity;
        end else if (TX_ER) begin
            tx_code_group <= 10'b1111111111; // Grupo de código para error
        end else begin
            tx_code_group <= 10'b0000000000; // Estado inactivo o en espera
        end
    end

endmodule
