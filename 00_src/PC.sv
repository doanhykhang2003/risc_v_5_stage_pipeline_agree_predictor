module PC (
  input  logic        i_clk     , 
  input  logic        i_rst_n   ,
  input  logic        i_stall_f ,
  input  logic [31:0] i_pc_next ,
  output logic [31:0] o_pc
);

  always_ff @(posedge i_clk or negedge i_rst_n) begin : pc_ff
    if     (!i_rst_n)    o_pc <= 32'b0    ;
    else if(i_stall_f)   o_pc <= o_pc     ;
    else                 o_pc <= i_pc_next;
  end : pc_ff

endmodule : PC
