module control_acceso #(
    parameter [15:0] CLAVE_CORRECTA = 16'h2468  // Clave por defecto (BCD para 2468)
)(
    input clk,
    input reset,
    input LV,          // Llegó vehículo
    input [15:0] clave,  // Clave ingresada en BCD
    input CV,          // Pasó vehículo
    input BR,          // Botón de reset
    output reg AC,     // Abriendo compuerta
    output reg CP,     // Cerrando compuerta
    output reg AI,     // Alarma de pin incorrecto
    output reg AB      // Alarma de bloqueo
);

    // Definición de los estados
    reg [1:0] state, next_state;
    reg [1:0] contador_intentos;  // Contador de intentos fallidos
    reg entrar_b_desde_a; // Indicador de si se entra al estado B desde A

    // Estados codificados
    localparam A = 2'b00;  // Esperando vehículo
    localparam B = 2'b01;  // Intentando clave
    localparam C = 2'b10;  // Pasando vehículo
    localparam D = 2'b11;  // Sistema bloqueado

    // Lógica de transición de estados
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;  // Estado inicial
            contador_intentos <= 0;  // Reiniciar contador de intentos
            entrar_b_desde_a <= 1'b0; // Inicializar indicador
        end else begin
            state <= next_state;
        end
    end

    // Lógica de la máquina de estados
    always @(*) begin
        // Valores predeterminados
        AC = 1'b0;
        CP = 1'b0;
        AI = 1'b0;
        AB = 1'b0;
        next_state = state; // Default case: stay in the current state

        case (state)
            A: begin
                if (LV && !CV) begin
                    next_state = B;
                    entrar_b_desde_a = 1'b1; // Marcar que se entra a B desde A
                end else if (LV && CV) begin
                    next_state = D;
                    entrar_b_desde_a = 1'b0;
                end else begin
                    next_state = A;
                    entrar_b_desde_a = 1'b0;
                end
            end

            B: begin
                if (entrar_b_desde_a) begin
                    contador_intentos = 0;  // Reiniciar contador al entrar desde A
                end

                if (clave == CLAVE_CORRECTA) begin
                    AC = 1'b1;  // Abriendo compuerta
                    next_state = C;
                    contador_intentos = 0;  // Limpiar contador de intentos al ingresar la clave correcta
                end else if (contador_intentos == 2) begin
                    AI = 1'b1;  // Alarma de pin incorrecto
                    next_state = D;
                end else begin
                    next_state = B;
                    contador_intentos = contador_intentos + 1;
                end
                entrar_b_desde_a = 1'b0; // Restablecer indicador después de entrar a B
            end

            C: begin
                if (CV && LV) begin
                    AB = 1'b1;       // Activar alarma de bloqueo
                    next_state = D;  // Ir al estado de bloqueo
                end else if (CV) begin
                    CP = 1'b1;       // Cerrando compuerta
                    next_state = A;  // Volver al estado de espera
                end else begin
                    next_state = C;  // Permanecer en el estado C
                end
            end

            D: begin
                if (BR) begin
                    next_state = A; //si presiono el botón de reinicio, se reinicia el sistema 
                end else begin
                    AB = 1'b1;  // Alarma de bloqueo
                    next_state = D;
                end
            end

            default: next_state = A;
        endcase
    end
endmodule
