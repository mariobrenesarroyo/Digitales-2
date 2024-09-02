
module provador_acceso #(
    parameter [15:0] CLAVE_CORRECTA = 16'h1194  // Clave correcta basada en los últimos cuatro dígitos de tu carné
)(
    output reg clk,
    output reg reset,
    output reg LV,          // Llegó vehículo
    output reg [15:0] clave,  // Clave ingresada en BCD
    output reg CV,          // Pasó vehículo
    output reg BR,          // Botón de reset
    input AC,               // Abriendo compuerta
    input CP,               // Cerrando compuerta
    input AI,               // Alarma de pin incorrecto
    input AB                // Alarma de bloqueo
);

    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 0;
        LV = 0;
        CV = 0;
        BR = 0;
        clave = 16'h0000; // Clave inicial (vacía)

        // Secuencia de prueba
        #5 reset = 1;   // Activar reset
        #10 reset = 0;  // Desactivar reset

        // Escenario 1: Vehículo llega, se intenta una clave incorrecta
        #10 LV = 1;
        #10 clave = 16'h1234;  // Clave incorrecta
        #10 LV = 0;

        // Escenario 2: Vehículo intenta nuevamente con otra clave incorrecta
        #10 clave = 16'h5678;  // Otra clave incorrecta


        // Escenario 3: Vehículo intenta con la clave correcta
        #10 clave = CLAVE_CORRECTA;  // Clave correcta (1194 en BCD)
        #10 CV = 0;  // Vehículo no ah pasado
        #10 CV = 1; LV = 0;  // vehiculo pasó y no ha llegado un vehiculo nuevo

        // Escenario 4: Intento de bloquear el sistema
        #10 LV = 1;
        #10 clave = 16'h1111;  // Clave incorrecta
        #10 clave = 16'h2222;  // Otra clave incorrecta
        #10 clave = 16'h3333;  // Tercer intento incorrecto
        // Escenario 5: Reset del sistema después de bloquear
        #10 BR = 0;   //no ha presionado el boton reset sigue bloqueado
        #10 BR = 1;   //presionó el botón de reset
        // Escenario 6: despues del reset viene otro vehiculo y otro se trata de colar 
        #10 LV = 1;            //llega vehiculo
        #10 clave = 16'h1111; //clave incorrecta
        #10 clave = 16'h1111; //clave incorrecta
        #10 clave = CLAVE_CORRECTA;
        #10 CV = 1;           //pasa vehiculo pero al mismo tiempo quiere colarse otro porque LV no se ha apagado
        #20 BR = 1;           // se reinicia el sistema 

        // Terminar la simulación
        #200 $finish;
    end

    // Generación de reloj
    always begin
        #5 clk = ~clk;
    end

endmodule
