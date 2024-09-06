module provador_acceso (
    output reg clk,
    output reg reset,
    output reg llegado_vehiculo,        // Llegó vehículo (LV)
    output reg [15:0] clave_ingresada,  // Clave ingresada en BCD (clave)
    output reg paso_vehiculo,           // Pasó vehículo (CV)
    output reg boton_reset,             // Botón de reset (BR)
    input abriendo_compuerta,           // Abriendo compuerta (AC)
    input cerrando_compuerta,           // Cerrando compuerta (CP)
    input alarm_pin_incorrecto,         // Alarma de pin incorrecto (AI)
    input alarm_bloqueo               // Alarma de bloqueo (AB)
);

    // Definición de la clave correcta
    parameter CLAVE_CORRECTA = 16'h2468;   // Clave correcta de pruebas por defecto
    parameter CLAVE_CERO = 16'h0000; // Clave por inicial

    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 0;
        clave_ingresada = CLAVE_CERO;   // mi clave por defecto
        paso_vehiculo = 0;
        boton_reset = 0;
        llegado_vehiculo = 0;

        // Prueba #1: Funcionamiento normal básico
        // Llegada de un vehículo, ingreso del pin correcto y apertura de puerta
        // Sensor de fin de entrada y cierre de compuerta
        #(10) reset = 1;   // Activar reset
        #(10) reset = 0;   // Desactivar reset
        #(10) llegado_vehiculo = 1; clave_ingresada = CLAVE_CORRECTA;
        #(10) paso_vehiculo = 1; llegado_vehiculo = 0;
        #(40) paso_vehiculo = 0; // Fin de entrada

        // Prueba #2: Ingreso de pin incorrecto menos de 3 veces
        // Llegada de un vehículo, ingreso de pin incorrecto (una o dos veces)
        // Puerta permanece cerrada, ingreso de pin correcto, funcionamiento normal básico
        #(20) llegado_vehiculo = 1;
        #(10) clave_ingresada = 16'h1234; // Clave incorrecta
        #(10) clave_ingresada = 16'h5678; // Clave incorrecta
        #(10) clave_ingresada = CLAVE_CORRECTA; // Fin de llegada de vehículo
        #(10) paso_vehiculo = 1; llegado_vehiculo = 0;
        #(20) paso_vehiculo = 0; // Fin de entrada


        // Prueba #3: Ingreso de pin incorrecto 3 o más veces
        // Revisión de alarma de pin incorrecto y contador de intentos incorrectos
        // Ingreso de pin correcto, funcionamiento normal básico
        #(30) llegado_vehiculo = 1; clave_ingresada = 16'h1234;
        #(10) clave_ingresada = 16'h5678; // Clave incorrecta
        #(10) clave_ingresada = 16'h9876; // Clave incorrecta
        #(10) llegado_vehiculo = 0; // Fin de llegada de vehículo
        #(10) boton_reset = 1; // Presionar botón reset
        #(10) boton_reset = 0; // Liberar botón reset
        #(10) llegado_vehiculo = 1;
        #(10) clave_ingresada = CLAVE_CORRECTA;  // Usamos la clave correcta
        #(10) paso_vehiculo = 1; llegado_vehiculo = 0;
        #(10) paso_vehiculo = 0; // Fin de entrada


        // Prueba #4: Alarma de bloqueo
        // Ambos sensores encienden al mismo tiempo, encendido de alarma de bloqueo
        // Ingreso de clave incorrecta, bloqueo permanece, ingreso de clave correcta, desbloqueo
        #(20) llegado_vehiculo = 1;
        #(10) clave_ingresada = CLAVE_CORRECTA;  // Usamos la clave correcta
        #(10) paso_vehiculo = 1; llegado_vehiculo = 1; // se trató de colar
        #(10) boton_reset = 1; // Presionar botón reset
        #(10) boton_reset = 0; // Liberar botón reset
        #(10) llegado_vehiculo = 1;
        #(10) clave_ingresada = CLAVE_CORRECTA;  // Usamos la clave correcta
        #(10) paso_vehiculo = 1; llegado_vehiculo = 0;
        #(10) paso_vehiculo = 0; // Fin de entrada

        // Terminar la simulación
        #(30) $finish;
    end

    // Generación de reloj
    always begin
        #(10) clk = ~clk;
    end

endmodule
