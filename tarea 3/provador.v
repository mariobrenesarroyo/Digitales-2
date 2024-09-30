module provador (
    output reg clk, rst,
    input wire TARJETA_RECIBIDA, TIPO_TRNANS, DIGITO_STB, MONTO_STB,
    output reg ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO, FONDOS_INSUFICIENTES, BALANCE_ACTUALIZADO,
    output reg [3:0] DIGITO,
    output reg [15:0] PIN,
    output reg [31:0] MONTO,
    output reg [63:0] BALANCE_INICIAL
);

    initial begin
        clk = 0;
        rst = 0;
        BALANCE_INICIAL = 64'd20000; // Inicializar balance a 20,000
        PIN = 16'd1194; // Inicializar PIN a 1194

        #(30) $finish;
    end

    // Generación de reloj
    always begin
        #(10) clk = ~clk;
    end

endmodule
