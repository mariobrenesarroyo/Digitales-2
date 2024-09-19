module BUF(A, Y);
  input A;
  output Y;
<<<<<<< HEAD
  assign #1Y = A; // Retardo de 1
=======
  assign #1Y = A;
>>>>>>> origin/main
endmodule

module NOT(A, Y);
  input A;
  output Y;
<<<<<<< HEAD
  assign #1Y = ~A; // Retardo de 1
=======
  assign #1Y = ~A;
>>>>>>> origin/main
endmodule

module NAND(A, B, Y);
  input A, B;
  output Y;
<<<<<<< HEAD
  assign #2Y = ~(A & B); // Retardo de 2
=======
  assign #2Y = ~(A & B);
>>>>>>> origin/main
endmodule

module NOR(A, B, Y);
  input A, B;
  output Y;
<<<<<<< HEAD
  assign #1Y = ~(A | B); // Retardo de 2
=======
  assign #2Y = ~(A | B);
>>>>>>> origin/main
endmodule

module DFF(C, D, Q);
  input C, D; 
  output reg Q;
<<<<<<< HEAD
  always @(posedge C) begin
    #2Q <= D; // Retardo de 2
  end
=======
  always @(posedge C) #2Q <= D;
>>>>>>> origin/main
endmodule
