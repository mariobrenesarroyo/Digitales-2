module contador_3_bits(
    input wire clk,
    input wire rst,
    output reg a
);

    reg [2:0] contador;       // Contador de 3 bits
    reg [2:0] prox_contador;  // Próximo valor del contador

    // Inicialización del contador y la salida 'a'
    initial begin
        contador = 3'b000;
        a = 1'b0; // Inicializa 'a'
    end

    always @(posedge clk) begin
        if (rst) begin
            contador <= 3'b001; // Reset activo alto
            a <= 1'b0; // Reinicia la salida
        end else begin
            contador <= prox_contador; // Actualiza contador con el próximo valor
        end
    end

    always @(*) begin
        // Lógica para determinar el próximo valor del contador
        if (contador == 3'b100) begin
            prox_contador = 3'b001; // Resetea el contador a 1 si llega a 4
        end else begin
            prox_contador = contador + 1; // Incrementa el contador
        end
        a = contador[2]; // Actualiza la salida 'a' para reflejar contador[2]
    end

endmodule
