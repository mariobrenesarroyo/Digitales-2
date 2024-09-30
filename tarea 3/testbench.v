`include "cajero.v"


module tb_pin_comparator;

// Declaración de señales
reg clk;
reg rst;
reg [15:0] PIN;          // PIN esperado
reg [3:0] DIGITO;        // Último dígito tecleado
reg DIGITO_STB;          // Señal strobe para cada dígito
wire valido;             // Salida que indica si el PIN es correcto
wire bloqueado;          // Señal de bloqueo después de 3 intentos fallidos

// Instancia del módulo pin_comparator
pin_comparator uut (
    .clk(clk),
    .rst(rst),
    .PIN(PIN),
    .DIGITO(DIGITO),
    .DIGITO_STB(DIGITO_STB),
    .valido(valido),
    .bloqueado(bloqueado)
);

// Generación de reloj (50MHz)
always #10 clk = ~clk;  // Ciclo de reloj de 20ns (50MHz)

// Procedimiento inicial para aplicar los estímulos
initial begin
    // Crear archivo de volcado de señales para visualización
    $dumpfile("pin_comparator_tb.vcd");  // Nombre del archivo de volcado
    $dumpvars(0, tb_pin_comparator);     // Volcar todas las variables del testbench

    // Monitoreo de las señales importantes
    $monitor("Tiempo=%0t | PIN=%h | DIGITO=%h | STB=%b | Valido=%b | Bloqueado=%b",
             $time, PIN, DIGITO, DIGITO_STB, valido, bloqueado);

    // Inicialización
    clk = 0;
    rst = 1;             // Reset activo
    PIN = 16'h1234;      // El PIN esperado es 1234
    DIGITO = 4'b0000;
    DIGITO_STB = 0;

    // Liberar el reset después de algunos ciclos
    #20 rst = 0;

    // Caso 1: Ingresar el PIN correcto (1234)
    ingresar_pin(4'h1);
    ingresar_pin(4'h2);
    ingresar_pin(4'h3);
    ingresar_pin(4'h4);

    #50;  // Esperar un poco para ver el resultado

    // Caso 2: Ingresar un PIN incorrecto (5678)
    ingresar_pin(4'h5);
    ingresar_pin(4'h6);
    ingresar_pin(4'h7);
    ingresar_pin(4'h8);

    #50;  // Esperar un poco para ver el resultado

    // Caso 3: Ingresar un segundo PIN incorrecto (9876)
    ingresar_pin(4'h9);
    ingresar_pin(4'h8);
    ingresar_pin(4'h7);
    ingresar_pin(4'h6);

    #50;  // Esperar un poco para ver el resultado

    // Caso 4: Ingresar un tercer PIN incorrecto (5555)
    ingresar_pin(4'h5);
    ingresar_pin(4'h5);
    ingresar_pin(4'h5);
    ingresar_pin(4'h5);

    #50;  // Esperar un poco para ver el resultado

    // Intentar ingresar otro PIN después de 3 intentos fallidos (bloqueado)
    ingresar_pin(4'h1);
    ingresar_pin(4'h2);
    ingresar_pin(4'h3);
    ingresar_pin(4'h4);

    #50;  // Esperar para ver si el sistema sigue bloqueado

    $finish;
end

// Tarea para simular el ingreso de un dígito
task ingresar_pin(input [3:0] digito);
begin
    DIGITO = digito;
    DIGITO_STB = 1;  // Activar la señal strobe
    #20 DIGITO_STB = 0;  // Desactivar la señal strobe después de un ciclo de reloj
    #40;  // Esperar algunos ciclos antes de ingresar el siguiente dígito
end
endtask

endmodule
