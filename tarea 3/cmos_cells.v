module BUF(A, Y);
  input A;
  output Y;
  assign #1Y = A; // Retardo de 1
endmodule

module NOT(A, Y);
  input A;
  output Y;
  assign #1Y = ~A; // Retardo de 1
endmodule

module NAND(A, B, Y);
  input A, B;
  output Y;
  assign #1Y = ~(A & B); // Retardo de 1
endmodule

module NOR(A, B, Y);
  input A, B;
  output Y;
  assign #1Y = ~(A | B); // Retardo de 1
endmodule

module DFF(C, D, Q);
  input C, D; 
  output reg Q;
  always @(posedge C) begin
    #1Q <= D; // Retardo de 1
  end
endmodule
