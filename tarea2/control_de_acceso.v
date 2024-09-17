//c11194
module control_acceso (
    input wire llegado_vehiculo, paso_vehiculo, tercer_intento, boton_reset, clk, reset,
    input wire [15:0] clave_ingresada,
    output reg abriendo_compuerta, cerrando_compuerta, alarm_bloqueo, alarm_pin_incorrecto
);

reg [1:0] EstPresente, ProxEstado, contador_intentos, prox_contador_intentos;
reg [15:0] CLAVE_CORRECTA = 16'h1194 ;

// ASIGNACIÓN DE ESTADOS Y PARÁMETRO DE CLAVE CORRECTA
localparam Esperando_vehiculo = 2'b00;    //esperando vehículo
localparam Esperando_clave = 2'b01;    //intentando clave  
localparam PASANDO_VEHICULO = 2'b10;    //Pasando Vehículo
localparam BLOQUEO = 2'b11;    //Estado de bloqueo


// Memoria de estados
always @(posedge clk or posedge reset) begin
    if (reset) begin
        EstPresente <= Esperando_vehiculo;
        contador_intentos <= 2'b00;

    end else
        EstPresente <= ProxEstado;
        contador_intentos <= prox_contador_intentos;

    
end

// Lógica de cálculo de próximo estado
always @(*) begin
    prox_contador_intentos = contador_intentos;
    ProxEstado = EstPresente;
    case (EstPresente)
        Esperando_vehiculo: begin
             if (llegado_vehiculo) begin
                ProxEstado = Esperando_clave;
                prox_contador_intentos = 2'b00;
            end
            else begin
                ProxEstado = Esperando_vehiculo;
            end
        end

        Esperando_clave: begin
            if (clave_ingresada == CLAVE_CORRECTA) begin
                ProxEstado = PASANDO_VEHICULO; 
                prox_contador_intentos = 2'b00;

            end
            else if (contador_intentos == 3) begin
                ProxEstado = BLOQUEO;
            end
            else begin
                prox_contador_intentos = contador_intentos + 1;
                ProxEstado = Esperando_clave;
            end

        end

        PASANDO_VEHICULO: begin 
            if (llegado_vehiculo == 1 && paso_vehiculo == 1)begin
                ProxEstado = BLOQUEO;
            end

            else if (paso_vehiculo) begin
                ProxEstado = Esperando_vehiculo;
            end

            else if(~paso_vehiculo)begin
             ProxEstado = PASANDO_VEHICULO;
            end
        end

        BLOQUEO: if (boton_reset) begin
                ProxEstado = Esperando_vehiculo;
                contador_intentos = 2'b00;
            end
            else begin
                ProxEstado = BLOQUEO;
            end
    endcase
end

// Lógica de cálculo de salidas
always @(*) begin
    abriendo_compuerta = (EstPresente == Esperando_clave) && (clave_ingresada == CLAVE_CORRECTA);
    cerrando_compuerta = (EstPresente == PASANDO_VEHICULO) && (paso_vehiculo && ~llegado_vehiculo);
    alarm_pin_incorrecto = (contador_intentos == 3);
    alarm_bloqueo = (EstPresente == BLOQUEO);
end

endmodule
