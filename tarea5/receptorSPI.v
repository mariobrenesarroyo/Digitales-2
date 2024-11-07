module spi_receiver (
    input wire SCK,           // Reloj SPI externo
    input wire SS,            // Selección de esclavo (Chip Select, activo en bajo)
    input wire CPK,           // Polaridad del reloj
    input wire CPH,           // Fase del reloj
    input wire MOSI,          // Master Out Slave In (datos desde el maestro)
    output reg MISO,          // Master In Slave Out (datos hacia el siguiente esclavo)
    output reg [7:0] data_out // Datos recibidos
);

reg [7:0] data_shift_reg;     // Registro para desplazar datos recibidos
reg [2:0] bit_counter;        // Contador de bits
reg SCK_prev;                 // Estado anterior de SCK para detectar flancos

// Flancos del reloj SCK, controlados por CPH y CPK
wire posedge_sck = SCK && !SCK_prev; // Detecta el flanco positivo de SCK
wire negedge_sck = !SCK && SCK_prev; // Detecta el flanco negativo de SCK

// Definir en qué flanco se debe muestrear y desplazar los datos
wire flanco_muestreo = ((CPH == 1'b0 && CPK == 1'b0) || (CPH == 1'b0 && CPK == 1'b1)) ? posedge_sck : negedge_sck;
wire flanco_dezplazamiento = ((CPH == 1'b0 && CPK == 1'b0) || (CPH == 1'b0 && CPK == 1'b1)) ? negedge_sck : posedge_sck;

always @(posedge SCK or negedge SCK) begin
    if (!SS) begin  // Actúa solo si SS es bajo
        if (flanco_muestreo) begin
            MISO <= data_shift_reg[7];  // Asigna el valor de data_shift_reg[7] a MISO
        end
        if (flanco_dezplazamiento) begin
            data_shift_reg <= {data_shift_reg[6:0], MOSI};  // Desplaza data_shift_reg y asigna MOSI al bit menos significativo
        end
    end
end

endmodule
