module spi_receiver (
    input wire SCK,           // Reloj SPI externo
    input wire SS,            // Selección de esclavo (Chip Select, activo en bajo)
    input wire CKP,           // Polaridad del reloj
    input wire CPH,           // Fase del reloj
    input wire MOSI,          // Master Out Slave In (datos desde el maestro)
    output reg MISO,          // Master In Slave Out (datos hacia el siguiente esclavo)
    output reg [7:0] data_out // Datos recibidos
);

reg [7:0] data_shift_reg;


assign posedge_sck = SCK && !SS;
assign negedge_sck = !SCK && !SS;

assign flanco_muestreo = ((CPH == 1'b0 && CKP == 1'b0) || (CPH == 1'b0 && CKP == 1'b1)) ? posedge_sck : negedge_sck;
assign flanco_dezplazamiento = ((CPH == 1'b0 && CKP == 1'b0) || (CPH == 1'b0 && CKP == 1'b1)) ? negedge_sck : posedge_sck;

always @(posedge flanco_dezplazamiento && !SS) begin
    if(!flanco_muestreo)begin
    data_shift_reg <= {data_shift_reg[6:0], MOSI};
    data_out <= data_shift_reg;
    end
end

always @(posedge flanco_muestreo && !SS)begin
    MISO <= data_shift_reg[7];
end



endmodule
