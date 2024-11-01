module spi_generator (  
    input wire CLK,          // Reloj del sistema  
    input wire RESET,        // Señal de reinicio  
    input wire CKP,         // Polaridad del reloj  
    input wire CPH,         // Fase del reloj  
    input wire [7:0] data_in, // Datos a enviar  
    output reg CS,          // Chip Select  
    output wire SCK,         // Reloj SPI  
    output reg MOSI,        // Master Out Slave In  
    input wire MISO,        // Master In Slave Out  
    output reg [7:0] data_out // Datos recibidos  
);  


endmodule