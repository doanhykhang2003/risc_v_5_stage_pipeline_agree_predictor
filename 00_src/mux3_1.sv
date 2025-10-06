module mux3_1(
  input  logic [31:0] a, 
  input  logic [31:0] b, 
  input  logic [31:0] c,
  input  logic [1:0]  s,
  output logic [31:0] d
);

  assign d = (s == 2'b00) ? a : (s == 2'b01) ? b : (s == 2'b10) ? c : 32'h00000000; 

endmodule : mux3_1
