`include "cajero_synth.v"
`include "provador.v"
`include "cmos_cells.v"

module cajero_tb;
    // Declaración de señales
    wire clk, rst;
    wire TARJETA_RECIBIDA, TIPO_TRNANS, DIGITO_STB, MONTO_STB;
    wire ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO, FONDOS_INSUFICIENTES, BALANCE_ACTUALIZADO;
    wire [3:0] DIGITO;
    wire [15:0] PIN;
    wire [31:0] MONTO;
    wire [63:0] BALANCE_INICIAL;

    // Instancia del módulo cajero
    cajero U0 (
        .clk(clk),
        .rst(rst),
        .TARJETA_RECIBIDA(TARJETA_RECIBIDA),
        .TIPO_TRNANS(TIPO_TRNANS),
        .DIGITO_STB(DIGITO_STB),
        .MONTO_STB(MONTO_STB),
        .ENTREGAR_DINERO(ENTREGAR_DINERO),
        .PIN_INCORRECTO(PIN_INCORRECTO),
        .ADVERTENCIA(ADVERTENCIA),
        .BLOQUEO(BLOQUEO),
        .FONDOS_INSUFICIENTES(FONDOS_INSUFICIENTES),
        .BALANCE_ACTUALIZADO(BALANCE_ACTUALIZADO),
        .DIGITO(DIGITO),
        .PIN(PIN),
        .MONTO(MONTO),
        .BALANCE_INICIAL(BALANCE_INICIAL)
    );

    // Instancia del módulo provador
    provador P0 (
        .clk(clk),
        .rst(rst),
        .TARJETA_RECIBIDA(TARJETA_RECIBIDA),
        .TIPO_TRNANS(TIPO_TRNANS),
        .DIGITO_STB(DIGITO_STB),
        .MONTO_STB(MONTO_STB),
        .ENTREGAR_DINERO(ENTREGAR_DINERO),
        .PIN_INCORRECTO(PIN_INCORRECTO),
        .ADVERTENCIA(ADVERTENCIA),
        .BLOQUEO(BLOQUEO),
        .FONDOS_INSUFICIENTES(FONDOS_INSUFICIENTES),
        .BALANCE_ACTUALIZADO(BALANCE_ACTUALIZADO),
        .DIGITO(DIGITO),
        .PIN(PIN),
        .MONTO(MONTO),
        .BALANCE_INICIAL(BALANCE_INICIAL)
    );

     // Bloque inicial para la simulación
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1, U0);
        // Monitorización de todas las señales
        $monitor("clk=%b rst=%b TARJETA_RECIBIDA=%b TIPO_TRNANS=%b DIGITO_STB=%b MONTO_STB=%b ENTREGAR_DINERO=%b PIN_INCORRECTO=%b ADVERTENCIA=%b BLOQUEO=%b FONDOS_INSUFICIENTES=%b BALANCE_ACTUALIZADO=%b DIGITO=%b PIN=%b MONTO=%b BALANCE_INICIAL=%b",
                 clk, rst, TARJETA_RECIBIDA, TIPO_TRNANS, DIGITO_STB, MONTO_STB, ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO, FONDOS_INSUFICIENTES, BALANCE_ACTUALIZADO, DIGITO, PIN, MONTO, BALANCE_INICIAL);
    end
endmodule
