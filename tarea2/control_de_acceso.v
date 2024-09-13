module control_acceso #(parameter CLAVE_CORRECTA = 16'h2468)(
    input wire llegado_vehiculo, paso_vehiculo, tercer_intento, boton_reset, clk, reset,
    input wire [15:0] clave_ingresada,
    output reg abriendo_compuerta, cerrando_compuerta, alarm_bloqueo, alarm_pin_incorrecto
);

reg [1:0] EstPresente, ProxEstado, contador_intentos;

// ASIGNACIÓN DE ESTADOS Y PARÁMETRO DE CLAVE CORRECTA
parameter A = 2'b00;    //esperando vehículo
parameter B = 2'b01;    //intentando clave  
parameter C = 2'b10;    //Pasando Vehículo
parameter D = 2'b11;    //Estado de bloqueo


// Memoria de estados
always @(posedge clk or posedge reset) begin
    if (reset) begin
        EstPresente <= A;
        contador_intentos <= 2'b00;

    end else
        EstPresente <= ProxEstado;
    
end

// Lógica de cálculo de próximo estado
always @(*) begin
    case (EstPresente)
        A: if (llegado_vehiculo) begin
                ProxEstado = B;
                contador_intentos = 2'b00;
            end

        B: begin
            if (clave_ingresada == CLAVE_CORRECTA) begin
                ProxEstado = C; 
                contador_intentos = 2'b00;
            end else begin
                contador_intentos = contador_intentos + 1;
                if (contador_intentos == 3) begin
                    ProxEstado = D;
                end
            end
        end

        C: begin 
            if (llegado_vehiculo == 1 && paso_vehiculo == 1)
                ProxEstado = D;
            else if (paso_vehiculo)
                ProxEstado = A;
            else if(~paso_vehiculo)
             ProxEstado = C;
        end

        D: if (boton_reset) begin
                ProxEstado = A;
                contador_intentos = 2'b00;
            end
    endcase
end

// Lógica de cálculo de salidas
always @(*) begin
    abriendo_compuerta = (EstPresente == B) && (clave_ingresada == CLAVE_CORRECTA);
    cerrando_compuerta = (EstPresente == C) && (paso_vehiculo && ~llegado_vehiculo);
    alarm_pin_incorrecto = (contador_intentos == 3);
    alarm_bloqueo = (EstPresente == D);
end

endmodule