/* Generated by Yosys 0.44+20 (git sha1 5fb3c0b1d, g++ 11.4.0-1ubuntu1~22.04 -fPIC -O3) */

(* src = "control_de_acceso.v:1.1-71.10" *)
module control_acceso(llegado_vehiculo, paso_vehiculo, tercer_intento, boton_reset, clk, reset, clave_ingresada, abriendo_compuerta, cerrando_compuerta, alarm_bloqueo, alarm_pin_incorrecto);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire _21_;
  wire _22_;
  wire _23_;
  wire _24_;
  wire _25_;
  wire _26_;
  wire _27_;
  wire _28_;
  wire _29_;
  (* force_downto = 32'd1 *)
  (* src = "control_de_acceso.v:0.0-0.0|control_de_acceso.v:29.5-60.12|/usr/local/bin/../share/yosys/techmap.v:575.21-575.22" *)
  wire [1:0] _30_;
  (* src = "control_de_acceso.v:7.11-7.22" *)
  reg [1:0] EstPresente;
  (* src = "control_de_acceso.v:7.24-7.34" *)
  reg [1:0] ProxEstado;
  (* src = "control_de_acceso.v:4.16-4.34" *)
  output abriendo_compuerta;
  wire abriendo_compuerta;
  (* src = "control_de_acceso.v:4.56-4.69" *)
  output alarm_bloqueo;
  wire alarm_bloqueo;
  (* src = "control_de_acceso.v:4.71-4.91" *)
  output alarm_pin_incorrecto;
  wire alarm_pin_incorrecto;
  (* src = "control_de_acceso.v:2.65-2.76" *)
  input boton_reset;
  wire boton_reset;
  (* src = "control_de_acceso.v:4.36-4.54" *)
  output cerrando_compuerta;
  wire cerrando_compuerta;
  (* src = "control_de_acceso.v:3.23-3.38" *)
  input [15:0] clave_ingresada;
  wire [15:0] clave_ingresada;
  (* src = "control_de_acceso.v:2.78-2.81" *)
  input clk;
  wire clk;
  (* src = "control_de_acceso.v:7.36-7.53" *)
  wire [1:0] contador_intentos;
  (* src = "control_de_acceso.v:2.16-2.32" *)
  input llegado_vehiculo;
  wire llegado_vehiculo;
  (* src = "control_de_acceso.v:2.34-2.47" *)
  input paso_vehiculo;
  wire paso_vehiculo;
  (* src = "control_de_acceso.v:2.83-2.88" *)
  input reset;
  wire reset;
  (* src = "control_de_acceso.v:2.49-2.63" *)
  input tercer_intento;
  wire tercer_intento;
  assign _01_ = ~(EstPresente[1] & EstPresente[0]);
  assign _02_ = ~(_01_ | boton_reset);
  assign _03_ = EstPresente[0] & ~(EstPresente[1]);
  assign _04_ = ~(clave_ingresada[1] | clave_ingresada[0]);
  assign _05_ = clave_ingresada[3] | ~(clave_ingresada[2]);
  assign _06_ = _04_ & ~(_05_);
  assign _07_ = clave_ingresada[5] | ~(clave_ingresada[4]);
  assign _08_ = clave_ingresada[6] | ~(clave_ingresada[7]);
  assign _09_ = _08_ | _07_;
  assign _10_ = _06_ & ~(_09_);
  assign _11_ = clave_ingresada[9] | ~(clave_ingresada[8]);
  assign _12_ = clave_ingresada[11] | clave_ingresada[10];
  assign _13_ = _12_ | _11_;
  assign _14_ = clave_ingresada[13] | ~(clave_ingresada[12]);
  assign _15_ = clave_ingresada[15] | clave_ingresada[14];
  assign _16_ = _15_ | _14_;
  assign _17_ = _16_ | _13_;
  assign _18_ = _10_ & ~(_17_);
  assign _19_ = _03_ & ~(_18_);
  assign _20_ = _19_ | _02_;
  assign _21_ = ~(EstPresente[1] | EstPresente[0]);
  assign _22_ = _21_ & ~(llegado_vehiculo);
  assign _00_ = _22_ | _20_;
  assign alarm_bloqueo = ~_01_;
  assign abriendo_compuerta = _18_ & _03_;
  assign _23_ = EstPresente[1] & ~(EstPresente[0]);
  assign _24_ = llegado_vehiculo | ~(paso_vehiculo);
  assign cerrando_compuerta = _23_ & ~(_24_);
  assign _25_ = ~(paso_vehiculo & llegado_vehiculo);
  assign _26_ = _23_ & ~(_25_);
  assign _27_ = _26_ | _19_;
  assign _30_[0] = _27_ | _21_;
  assign _28_ = paso_vehiculo & ~(llegado_vehiculo);
  assign _29_ = _23_ & ~(_28_);
  assign _30_[1] = EstPresente[1] ? _29_ : EstPresente[0];
  (* src = "control_de_acceso.v:28.1-61.4" *)
  always @*
    if (!_00_) ProxEstado[0] = _30_[0];
  (* src = "control_de_acceso.v:28.1-61.4" *)
  always @*
    if (!_00_) ProxEstado[1] = _30_[1];
  (* src = "control_de_acceso.v:17.1-25.4" *)
  always @(posedge clk, posedge reset)
    if (reset) EstPresente[0] <= 1'h0;
    else EstPresente[0] <= ProxEstado[0];
  (* src = "control_de_acceso.v:17.1-25.4" *)
  always @(posedge clk, posedge reset)
    if (reset) EstPresente[1] <= 1'h0;
    else EstPresente[1] <= ProxEstado[1];
  assign alarm_pin_incorrecto = 1'h0;
  assign contador_intentos = 2'h0;
endmodule
