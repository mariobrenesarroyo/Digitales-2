module control_acceso (
    input llegado_vehiculo, paso_vehiculo, tercer_intento, boton_reset, clk, reset,
    input [15:0] clave_ingresada,
    output reg abriendo_compuerta, cerrando_compuerta, alarm_bloqueo, alarm_pin_incorrecto
);

reg [1:0] EstPresente, ProxEstado, contador_intentos;
reg alarm_pin_latch; // Nuevo latch para mantener la alarma activa

// ASIGNACIÓN DE ESTADOS Y PARÁMETRO DE CLAVE CORRECTA
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;
parameter CLAVE_CORRECTA = 16'h1194;

// Memoria de estados
always @(posedge clk or posedge reset) begin
    if (reset) begin
        EstPresente <= A;
        contador_intentos <= 2'b00;
        alarm_pin_latch <= 0;
        alarm_pin_incorrecto <= 0;
    end else begin
        EstPresente <= ProxEstado;
        if (ProxEstado == D && EstPresente == B) begin
            alarm_pin_latch <= 1; // Activa el latch al entrar en el estado D desde B
        end
        if (ProxEstado == A) begin
            alarm_pin_latch <= 0; // Resetea el latch al volver a A
        end
    end
end

// Lógica de cálculo de próximo estado
always @(*) begin
    ProxEstado = EstPresente; // Asignación por defecto
    case (EstPresente)
        A: if (llegado_vehiculo) begin
                ProxEstado = B;
                contador_intentos = 2'b00;
            end

        B: begin
            if (clave_ingresada == CLAVE_CORRECTA) begin
                ProxEstado = C; 
                contador_intentos = 2'b00;
                alarm_pin_latch = 0; // Desactivar alarma si se ingresa la clave correcta
            end else begin
                contador_intentos = contador_intentos + 1;
                if (contador_intentos == 3) begin
                    ProxEstado = D;
                end
            end
        end

        C: case ({paso_vehiculo, llegado_vehiculo})
            2'b10: ProxEstado = A;
            2'b11: ProxEstado = D;
            default: ProxEstado = C;
        endcase

        D: if (boton_reset) begin
                ProxEstado = A;
                contador_intentos = 2'b00;
                alarm_pin_latch = 0; // Reset de la alarma
            end
    endcase
end

// Lógica de cálculo de salidas
always @(*) begin
    abriendo_compuerta = (EstPresente == B) && (clave_ingresada == CLAVE_CORRECTA);
    cerrando_compuerta = (EstPresente == C) && (paso_vehiculo && ~llegado_vehiculo);
    alarm_pin_incorrecto = alarm_pin_latch; // Asignación a partir del latch
    alarm_bloqueo = (EstPresente == D);
end

endmodule
