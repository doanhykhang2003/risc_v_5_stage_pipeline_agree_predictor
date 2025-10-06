module br_ctr_unit(
  input  logic [31:0] i_instr_e     ,
  input  logic        i_br_less     ,
  input  logic        i_br_equal    ,
  output logic        o_br_un       ,
  output logic        o_brc_ctrl_sel,
  output logic        op_a_sel      ,
  output logic        pc_sel
);

  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;

  assign opcode = i_instr_e[6:0]  ;
  assign funct3 = i_instr_e[14:12];
  assign funct7 = i_instr_e[31:25];

  always_comb begin
	  o_brc_ctrl_sel = 1'b0;
    o_br_un        = 1'b0;
	  op_a_sel       = 1'b0;
	  pc_sel         = 1'b0;
    if (opcode == 7'b1100011) begin // Branch
      o_brc_ctrl_sel = 1;
      case (funct3)
        3'b000: begin
          o_br_un = 1'b0;
          if (i_br_equal) begin
            op_a_sel = 1'b1;
            pc_sel   = 1'b1;
          end else begin
            pc_sel   = 1'b0;
          end
        end
        3'b001: begin
          o_br_un = 1'b0;
          if (i_br_equal) begin
            pc_sel   = 1'b0;
          end else begin
            op_a_sel = 1'b1;
            pc_sel   = 1'b1;
          end
        end
        3'b100: begin
          o_br_un = 1'b0;
          if (i_br_less) begin
            op_a_sel = 1'b1;
            pc_sel   = 1'b1;
          end else begin
            pc_sel   = 1'b0;
          end
        end
        3'b101: begin
          o_br_un = 1'b0;
          if (i_br_equal || (!i_br_equal && !i_br_less)) begin
            op_a_sel = 1'b1;
            pc_sel   = 1'b1;
          end else begin
            pc_sel   = 1'b0;
          end
        end
        3'b110: begin
          o_br_un = 1'b1;
          if (i_br_less) begin
            op_a_sel = 1'b1;
            pc_sel   = 1'b1;
          end else begin
            pc_sel   = 1'b0;
          end
        end
        3'b111: begin
          o_br_un = 1'b1;
          if (i_br_equal || (!i_br_equal && !i_br_less)) begin
            op_a_sel = 1'b1;
            pc_sel   = 1'b1;
          end else begin
            pc_sel   = 1'b0;
          end
        end
        default: begin
          pc_sel    = 1'b0  ;
          op_a_sel  = 1'b0  ;
        end
      endcase
    end else begin
      o_brc_ctrl_sel = 0;
    end
  end
endmodule