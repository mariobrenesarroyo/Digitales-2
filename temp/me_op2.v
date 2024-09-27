// Declaración del módulo y parámetros
module det_sec #(parameter SECUENCIA = 5'b10100,
                 parameter SEC_REINICIO = 5'b00000) (clk,rst,s_in,valido);

// Declaración de entradas y salidas
input clk,rst,s_in;
output reg valido;

//Declaración de variables internas
reg [2:0] cnt_ceros;
reg [2:0] prox_cnt_ceros;
//Añadido para despulgar (hacer debug)
reg   [4:0] sec_recibida;
//Se usan dos bits para que sea un flip flop por estado (one-hot encoding) que elimina las carreras
//de estado (race conditions)
//INICIO = 6'b000001
//PRIMER DIGITO = 6'b000010
//SEGUNDO DIGITO =6'b000100
//ETC
reg   [5:0] estado_actual;  
reg   [5:0] prox_estado;   

//Definir todos los flip flops
always @(posedge clk) begin
	if (rst) begin 
	   estado_actual <= 6'b000001; 
	   cnt_ceros     <= 3'b000;
	   //Añadido para despulgar
	   sec_recibida  <= '0;
	end
	else begin
	   estado_actual   <= prox_estado;
           cnt_ceros       <= prox_cnt_ceros;
           //Añadido para despulgar
           sec_recibida[0] <= s_in;
	   sec_recibida[1] <= sec_recibida[0];
	   sec_recibida[2] <= sec_recibida[1];
           sec_recibida[3] <= sec_recibida[2];
	   sec_recibida[4] <= sec_recibida[3];
	end

end

//Definir lógica combinacional
//Case de los estados
always @(*) begin
  //Case de estados para definir:
  //1. Lógica de próximo estado
  //2. Lógica de salida
  valido = 0;
  prox_estado = estado_actual;
  prox_cnt_ceros = cnt_ceros;
  
  case (estado_actual)
    //Estado de inicio
  6'b000001:  begin
                if (s_in) prox_estado = 6'b000010;
                else prox_estado = 6'b000001;
              end
  6'b000010:  begin
                if (~s_in) prox_estado = 6'b000100;
                else prox_estado = 6'b000010;
              end
  6'b000100:  begin
                if (s_in) prox_estado = 6'b001000;
                else prox_estado = 6'b000001;
              end
  6'b001000:  begin
                if (~s_in) prox_estado = 6'b010000;
                else prox_estado = 6'b000010;
              end
  6'b010000:  begin
                if (~s_in) prox_estado = 6'b100000;
                else prox_estado = 6'b001000;
              end
  6'b100000:  begin
                valido = 1;
                if (~s_in) prox_cnt_ceros = cnt_ceros+1;
                else prox_cnt_ceros = 0;
                if (cnt_ceros == 4) prox_estado = 6'b000001;
                else prox_estado = 6'b100000;
              end
    //Cualquier otro caso
    default: begin 
               valido = 0;
             end
  endcase

end

endmodule

