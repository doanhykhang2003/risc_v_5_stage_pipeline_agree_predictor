module hazard_unit(
  // Declaration of I/Os
  input  logic       i_br_sel_e   ,
  input  logic       i_taken_flush,
  input  logic       i_rd_wren_e  , 
  input  logic       i_rd_wren_m  , 
  input  logic       i_rd_wren_w  , 
  input  logic [1:0] i_wb_sel_e   , 
  input  logic [4:0] i_rs1_d      , 
  input  logic [4:0] i_rs2_d      , 
  input  logic [4:0] i_rs1_e      , 
  input  logic [4:0] i_rs2_e      , 
  input  logic [4:0] i_rd_e       ,
  input  logic [4:0] i_rd_m       , 
  input  logic [4:0] i_rd_w       , 

  output logic       o_stall_f    , 
  output logic       o_stall_d    ,
  output logic       o_flush_d    , 
  output logic       o_flush_e    , 
  output logic       o_forward_a_d, 
  output logic       o_forward_b_d,
  output logic [1:0] o_forward_a_e, 
  output logic [1:0] o_forward_b_e
);

  logic lw_stall;

  always_comb begin
    if (i_rd_wren_m & (i_rd_m != 0) & (i_rd_m == i_rs1_e)) begin
      o_forward_a_e = 2'b10;
    end
    else if (i_rd_wren_w & (i_rd_w != 0) & !(i_rd_wren_m & (i_rd_m != 0) & (i_rd_m == i_rs1_e)) & (i_rd_w == i_rs1_e)) begin
      o_forward_a_e = 2'b01;
    end
    else begin
      o_forward_a_e = 2'b00;
    end
  end

  always_comb begin
    if (i_rd_wren_m & (i_rd_m != 0) & (i_rd_m == i_rs2_e)) begin
      o_forward_b_e = 2'b10;
    end
    else if (i_rd_wren_w & (i_rd_w != 0) & !(i_rd_wren_m & (i_rd_m != 0) & (i_rd_m == i_rs2_e)) & (i_rd_w == i_rs2_e)) begin
      o_forward_b_e = 2'b01;
    end
    else begin
      o_forward_b_e = 2'b00;
    end
  end

  always_comb begin
    if (i_rd_wren_m & (i_rs1_d != 0) & (i_rs1_d == i_rd_m)) begin
      o_forward_a_d = 1'b1;
    end
    else begin
      o_forward_a_d = 1'b0;
    end
  end

  always_comb begin
    if (i_rd_wren_m & (i_rs2_d != 0) & (i_rs2_d == i_rd_m)) begin
      o_forward_b_d = 1'b1;
    end
    else begin
      o_forward_b_d = 1'b0;
    end
  end

  always_comb begin
    lw_stall  = (i_wb_sel_e[0] & ((i_rs1_d == i_rd_e) | (i_rs2_d == i_rd_e)));
    o_stall_d = lw_stall                                                     ;
    o_flush_e = lw_stall | i_br_sel_e | i_taken_flush                        ;
    o_stall_f = lw_stall                                                     ;
    o_flush_d = i_br_sel_e | i_taken_flush                                   ;
  end

endmodule
