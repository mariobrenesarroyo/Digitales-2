module provador (
    output reg clk, rst,TARJETA_RECIBIDA, TIPO_TRNANS, DIGITO_STB, MONTO_STB,
    input  ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO, FONDOS_INSUFICIENTES, BALANCE_ACTUALIZADO,
    output reg [3:0] DIGITO,
    output reg [15:0] PIN,
    output reg [31:0] MONTO,
    output reg [63:0] BALANCE_INICIAL
);

    initial begin
        clk = 0; 
        rst = 1;
        BALANCE_INICIAL = 64'd20000; // Inicializar balance a 20,000
        PIN = 16'h1194; // Inicializar PIN a 1194
        TARJETA_RECIBIDA = 0; DIGITO_STB = 0; TIPO_TRNANS = 0; MONTO_STB = 0;

        //Caso 1 deposito perfecto 
        #(10) rst = 0;       // Activar reset
        #(10) rst = 1; TARJETA_RECIBIDA = 1'b1;   // Desactivar reset y recibe tarjeta
        #(20) TARJETA_RECIBIDA = 0; DIGITO = 4'h1;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO = 4'h9;
        #(20) DIGITO = 4'h4;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0; MONTO = 32'd15000;
        #(20) MONTO_STB = 1;
        #(20) MONTO_STB = 0; MONTO = 32'd0;

        //caso 2 retiro perfecto
        #(20) TARJETA_RECIBIDA = 1'b1; DIGITO = 4'h1;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0;
        #(20) DIGITO = 4'h4; 
        #(20) DIGITO_STB = 1; TIPO_TRNANS = 1;
        #(20) DIGITO_STB = 0; MONTO = 32'd15000;
        #(20) MONTO_STB = 1;  TIPO_TRNANS = 0;
        #(20) MONTO_STB = 0; MONTO = 32'd0;

        //caso 3 clave 3 veces incorrecta
        #(20) TARJETA_RECIBIDA = 1; DIGITO = 4'h1;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0;
        #(20) DIGITO = 4'h5;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(30) rst = 0;
        #(10) rst = 1;



        //caso 4 retiro fallido
        #(20) TARJETA_RECIBIDA = 1'b1; DIGITO = 4'h1;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0;
        #(20) DIGITO = 4'h4; 
        #(20) DIGITO_STB = 1; TIPO_TRNANS = 1;
        #(20) DIGITO_STB = 0; MONTO = 32'd45000;
        #(20) MONTO_STB = 1;  TIPO_TRNANS = 0;
        #(20) MONTO_STB = 0; MONTO = 32'd0;
        #(20) DIGITO_STB = 0; MONTO = 32'd10000;
        #(20) MONTO_STB = 1;  TIPO_TRNANS = 0;
        #(20) MONTO_STB = 0; MONTO = 32'd0;


  







        #(100) $finish;
    end

    // Generación de reloj
    always begin
        #(10) clk = ~clk;
    end

endmodule
