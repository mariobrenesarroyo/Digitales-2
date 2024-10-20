module i2c_clock_generator (
    input wire clk,    // Señal de reloj de entrada
    input wire rst,    // Señal de reinicio
    output  scl     // Señal de reloj I2C de salida
);
reg [1:0] counter,nxt_counter;  // Contador para dividir la frecuencia
reg [7:0] i2c_direccion_rw ;

always @(posedge clk) begin
    if (rst) begin
        counter <= 2'b00;
    end else begin
        counter <= nxt_counter;
    end
end

always @(*)begin
    nxt_counter = counter + 1;
end
assign scl = (counter[1]);
endmodule
