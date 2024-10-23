module i2c_clock_generator (
    input wire clk,    // Señal de reloj de entrada
    input wire rst,    // Señal de reinicio
    output wire scl,   // Señal de reloj I2C de salida
    output wire posedge_scl  // Señal que indica el primer flanco positivo de scl
);

reg [1:0] counter, nxt_counter;  // Contador para dividir la frecuencia
reg scl_prev;  // Registro para almacenar el estado anterior de scl

always @(posedge clk) begin
    if (rst) begin
        counter <= 2'b00;
        scl_prev <= 1'b0;  // Inicializa scl_prev a 0
    end else begin
        counter <= nxt_counter;
        scl_prev <= scl;  // Almacena el estado actual de scl en scl_prev
    end
end

always @(*) begin
    nxt_counter = counter + 1;
end

assign scl = counter[1];

// Detectar flanco positivo de scl
assign posedge_scl = scl && !scl_prev;

endmodule
