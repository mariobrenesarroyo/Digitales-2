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
  assign #2Y = ~(A & B); // Retardo de 2
endmodule

module NOR(A, B, Y);
  input A, B;
  output Y;
  assign #1Y = ~(A | B); // Retardo de 2
endmodule

module DFF(C, D, Q);
  input C, D; 
  output reg Q;
  always @(posedge C) begin
    #2Q <= D; // Retardo de 2
  end
endmodule
