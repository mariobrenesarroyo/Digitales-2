module BUF(A, Y);
  input A;
  output Y;
  assign Y = #0.1 A;
endmodule

module NOT(A, Y);
  input A;
  output Y;
  assign Y = #0.1 ~A;
endmodule

module NAND(A, B, Y);
  input A, B;
  output Y;
  assign Y = #0.2 ~(A & B);
endmodule

module NOR(A, B, Y);
  input A, B;
  output Y;
  assign Y = #0.2 ~(A | B);
endmodule

module DFF(C, D, Q);
  input C, D; 
  output reg Q;
  always @(posedge C) Q <= #0.2 D;
endmodule
