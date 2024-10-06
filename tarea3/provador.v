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
        rst = 0;
        BALANCE_INICIAL = 64'd20000; // Inicializar balance a 20,000
        PIN = 16'h1194; // Inicializar PIN a 1194
        TARJETA_RECIBIDA = 0; DIGITO_STB = 0; TIPO_TRNANS = 0; MONTO_STB = 0;

//Caso 1 deposito perfecto 
        #(10) rst = 0;                              
        #(10) rst = 1;                                


        #(20) TARJETA_RECIBIDA = 1'b1;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h9;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;                          
        #(20) DIGITO = 4'h4;
         
         //prox estado = tipo de transación 
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
  

        //estado presente tipo de transacción
        #(20) TARJETA_RECIBIDA = 0; DIGITO_STB = 0; TIPO_TRNANS = 0;

        //estado presente = deposito
        #(20) MONTO = 32'd15000; 
	    // proximo estado = esperando tarjeta
	    #(20) MONTO_STB = 1; 
        #(20) MONTO_STB = 0;


//caso 2 retiro perfecto
        //estado presente esperando tarjeta
        #(40) MONTO = 32'd0;

        //prox estado = esperando pin 
        #(20) TARJETA_RECIBIDA = 1'b1;

        //estado presente = esperando pin
        #(20) DIGITO = 4'h1;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0; 
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0; 
        #(20) DIGITO = 4'h4;


        //prox estado = tipo de transación
        #(20) DIGITO_STB = 1;

        //estado presente = tipo de transación
        #(20) TIPO_TRNANS = 1; DIGITO_STB = 0;

        //estado presente = retiro
        #(20) MONTO = 32'd15000;

        //prox estado = esperando tarjeta 
        #(20) MONTO_STB = 1;  TIPO_TRNANS = 0;
        #(20) MONTO_STB = 0; MONTO = 32'd0;

//caso 3 clave 3 veces incorrecta

        //prox estado = ingresando pin
        #(20) TARJETA_RECIBIDA = 1;
        //estado presente = ingresando pin
        //primer intento
        #(20) DIGITO = 4'h1; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h1; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h5; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        //segundo intento
        #(40) DIGITO = 4'h1; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h1; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h5; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        //tercer intento
        #(40) DIGITO = 4'h1; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h1; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h5; DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        
        //proximo estado = esperando tarjeta
        #(40) rst = 0;
        //estado presente = esperando tarjeta
        #(20) rst = 1;



        //caso 4 retiro fallido
        //proximo estado = ingresando pin
        #(20) TARJETA_RECIBIDA = 1'b1;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h1;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h9; TARJETA_RECIBIDA = 0;
        #(20) DIGITO_STB = 1;
        #(20) DIGITO_STB = 0;
        #(20) DIGITO = 4'h4;

        //proximo estado = tipo trans
        #(20) DIGITO_STB = 1;

        //proximo estado = retiro
        #(20) TIPO_TRNANS = 1; DIGITO_STB = 0;

        //estado presente = retiro
        #(20) MONTO = 32'd45000;

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
