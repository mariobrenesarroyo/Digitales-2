module cajero (
    clk,
    rst,
    TARJETA_RECIBIDA,
    TIPO_TRNANS,
    DIGITO,
    DIGITO_STB,
    PIN,
    MONTO,
    MONTO_STB,
    BALANCE_INICIAL,
    BALANCE_ACTUALIZADO,
    ENTREGAR_DINERO,
    PIN_INCORRECTO,
    ADVERTENCIA,
    BLOQUEO,
    FONDOS_INSUFICIENTES
);
    input  clk, rst, TARJETA_RECIBIDA, TIPO_TRNANS, DIGITO_STB, MONTO_STB;
    output reg ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO, FONDOS_INSUFICIENTES, BALANCE_ACTUALIZADO;
    input wire [3:0] DIGITO;
    input wire [15:0] PIN;
    input wire [31:0] MONTO;
    input wire [63:0] BALANCE_INICIAL;

    reg [1:0] contador_intentos, prox_contador_intentos;
    reg [15:0] pin_recibido;
    reg [2:0] EstPresente, ProxEstado;
    reg [63:0] Balance, Prox_Balance;
    
    // Nuevo registro para contar dígitos STB
    reg [3:0] contador_digito_stb, prox_contador_digito_stb;

    // Lógica de asignación de estados
    localparam Esperando_tarjeta = 3'b000;
    localparam Ingresando_pin = 3'b001;
    localparam E_Bloqueo = 3'b010;
    localparam Deposito = 3'b011;
    localparam Retiro = 3'b100;
    localparam Tipo_de_trans = 3'b101;

    // Memoria de estados y actualización de registros
    always @(posedge clk) begin
        if (~rst) begin
            EstPresente <= Esperando_tarjeta;
            contador_intentos <= 2'b00;
            pin_recibido <= 16'h0;
            Balance <= BALANCE_INICIAL;
            contador_digito_stb <= 4'b0000; // Inicializar contador de dígitos STB
        end 
        else begin
            EstPresente <= ProxEstado;
            contador_intentos <= prox_contador_intentos;
            contador_digito_stb <= prox_contador_digito_stb;
            Balance <= Prox_Balance;

            // Actualizar pin_recibido solo si DIGITO_STB es 1
            if (DIGITO_STB) begin
                pin_recibido <= {pin_recibido[11:0], DIGITO};
            end
        end
    end

    // Lógica combinacional para la siguiente lógica de estado y contadores
    always @(*) begin
        // Asignación por defecto de salidas (apagadas)
        ENTREGAR_DINERO = 1'b0;
        PIN_INCORRECTO = 1'b0;
        ADVERTENCIA = 1'b0;
        BLOQUEO = 1'b0;
        FONDOS_INSUFICIENTES = 1'b0;
        BALANCE_ACTUALIZADO = 1'b0;

        // Por defecto
        ProxEstado = EstPresente;
        prox_contador_intentos = contador_intentos;
        prox_contador_digito_stb = contador_digito_stb; // Nuevo contador por defecto
        Prox_Balance = Balance; 

        case (EstPresente)
        // Estado Esperando_tarjeta
        Esperando_tarjeta: begin
            if (TARJETA_RECIBIDA) begin
                ProxEstado = Ingresando_pin;
                prox_contador_intentos = 2'b00;
                prox_contador_digito_stb = 4'b0000; // Reiniciar contador de dígitos STB al recibir tarjeta
            end
            else begin
                ProxEstado = Esperando_tarjeta;
            end
        end
        
        // Estado Ingresando_pin
        Ingresando_pin: begin
            if (DIGITO_STB) begin
                prox_contador_digito_stb = contador_digito_stb + 1;
                if (contador_digito_stb == 4) begin
                    prox_contador_digito_stb = 4'b0001;  // Reiniciar el contador de dígitos
                    if (pin_recibido == PIN) begin
                        ProxEstado = Tipo_de_trans;
                        prox_contador_intentos = 2'b00;  // Reinicio de intentos
                    end
                    else begin
                        ProxEstado = Ingresando_pin;
                        contador_intentos = prox_contador_intentos + 1;
                    end
                end
                else begin
                    ProxEstado = Ingresando_pin;
                end
            end
            
            else begin
                if ((contador_intentos == 3)) begin
                    ProxEstado = E_Bloqueo;
                    BLOQUEO = 1'b1;
                end

                else if ((contador_intentos == 2) && (contador_digito_stb == 4)) begin
                    ADVERTENCIA = 1'b1;
                end

                else if ((contador_intentos == 1) && (contador_digito_stb == 4)) begin
                    PIN_INCORRECTO = 1'b1;
                end
                else if ((contador_digito_stb == 4) && (PIN == pin_recibido))begin
                    ProxEstado = Tipo_de_trans;
                end

                else begin
                    ProxEstado = Ingresando_pin;
                end
            end

        end



        // Estado Tipo_de_trans
        Tipo_de_trans: begin
            if (TIPO_TRNANS) begin
                ProxEstado = Retiro;
            end
            else begin
                ProxEstado = Deposito;
            end
        end

        // Estado Retiro
        Retiro: begin
            if (MONTO_STB) begin
                if (MONTO <= BALANCE_INICIAL) begin
                    Prox_Balance = Balance - MONTO;
                    BALANCE_ACTUALIZADO = 1'b1;
                    ENTREGAR_DINERO = 1'b1;
                    ProxEstado = Esperando_tarjeta;
                end
                else begin
                    FONDOS_INSUFICIENTES = 1'b1;
                    ProxEstado = Retiro;
                end
            end
            else begin
                ProxEstado = Retiro;
            end
        end

        // Estado Deposito
        Deposito: begin
            if (MONTO_STB) begin
                if (MONTO != 32'b0) begin
                    Prox_Balance = Balance + MONTO;
                    BALANCE_ACTUALIZADO = 1'b1;
                    ProxEstado = Esperando_tarjeta;
                end
                else begin
                    ProxEstado = Deposito;
                end
            end
            else begin
                ProxEstado = Deposito;
            end
        end

        // Estado E_Bloqueo
        E_Bloqueo: begin
            if (~rst) begin
                ProxEstado = Esperando_tarjeta;
            end
            else begin
                ProxEstado = E_Bloqueo;
                BLOQUEO = 1'b1;
            end
        end
        default: begin
            ProxEstado = Esperando_tarjeta;
        end
        
        endcase
    end
    
endmodule
