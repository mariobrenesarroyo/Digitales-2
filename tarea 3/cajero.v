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
    input wire clk, rst;
    input wire TARJETA_RECIBIDA, TIPO_TRNANS, DIGITO_STB, MONTO_STB;
    output reg ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO, FONDOS_INSUFICIENTES, BALANCE_ACTUALIZADO;
    input wire [3:0] DIGITO;
    input wire [15:0] PIN;
    input wire [31:0] MONTO;
    input wire [63:0] BALANCE_INICIAL ;

    reg [1:0] contador_intentos, prox_contador_intentos;
    reg [15:0] pin_recibido;
    reg [2:0] EstPresente, ProxEstado;
    reg [63:0] Balance;
     
    
    // Lógica de asignación de estados
    localparam Esperando_tarjeta = 3'b000;
    localparam Ingresando_pin = 3'b001;
    localparam E_Bloqueo = 3'b010;
    localparam Deposito = 3'b011;
    localparam Retiro = 3'b100;
    localparam Tipo_de_trans = 3'b101;

    // Memoria de estados
    always @(posedge clk) begin
        if (~rst) begin
            EstPresente <= Esperando_tarjeta;
            contador_intentos <= 2'b00;
            pin_recibido <= 16'h0;
        end else begin
            EstPresente <= ProxEstado;
            contador_intentos <= prox_contador_intentos;
            pin_recibido[3:0] <= DIGITO[3:0];
            pin_recibido[7:4] <= pin_recibido[3:0];
            pin_recibido[11:8] <= pin_recibido[7:4];
            pin_recibido[15:12] <= pin_recibido[11:8];
        end
    end

    always @(posedge clk) begin
        //por defecto
        prox_contador_intentos = contador_intentos;

        ProxEstado = EstPresente;
        case (EstPresente)
        Esperando_tarjeta: begin
            if (TARJETA_RECIBIDA) begin
                ProxEstado = Ingresando_pin;
                prox_contador_intentos = 2'b00;
            end
            else begin
                ProxEstado = Esperando_tarjeta;
            end
        end

        Ingresando_pin: begin
            if(DIGITO_STB)begin
                if (pin_recibido == PIN) begin
                    ProxEstado = Tipo_de_trans;
                    prox_contador_intentos = 2'b00;
                end
                else if (contador_intentos == 3) begin
                    BLOQUEO = 1'b1;
                    ProxEstado = E_Bloqueo;    
                end
                
                else if (contador_intentos == 2)begin
                    ADVERTENCIA = 1'b1;
                    ProxEstado = Ingresando_pin;
                    prox_contador_intentos = contador_intentos + 1;
                end

                else begin
                    PIN_INCORRECTO = 1'b1;
                    prox_contador_intentos = contador_intentos + 1;
                end
            end
            else begin
                ProxEstado = Ingresando_pin;
            end
        end

        Tipo_de_trans: begin
            if (TIPO_TRNANS)begin
                ProxEstado = Retiro;
            end
            else begin
                ProxEstado = Deposito;
            end
        end

        Retiro: begin
            if (MONTO_STB)begin
                if (MONTO <= BALANCE_INICIAL ) begin
                    Balance = BALANCE_INICIAL - MONTO;
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

        Deposito: begin
            if (MONTO_STB)begin
                if (MONTO != 64'b0)begin
                    Balance = BALANCE_INICIAL + MONTO;
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
        E_Bloqueo: begin
            if (~rst)begin
                ProxEstado = Esperando_tarjeta;
            end
            else begin
                ProxEstado = E_Bloqueo;
                BLOQUEO = 1'b1;
            end
        end

        endcase

    end

endmodule