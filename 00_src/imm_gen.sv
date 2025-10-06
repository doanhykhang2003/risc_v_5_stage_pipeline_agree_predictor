module imm_gen (
  // Input Declarations
  input  logic [2:0]  i_imm_src,    // Immediate source selector
  input  logic [31:0] i_instr  ,    // Input i_instruction
  // Output Declarations
  output logic [31:0] o_im          // Immediate output
);

  always_comb begin : imm_src_sel
    case (i_imm_src)
      3'b000:  o_im = {{20{i_instr[31]}}, i_instr[31:20]                                      };   // R-Type or I-Type
      3'b001:  o_im = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]                       };   // S-Type
      3'b010:  o_im = {{20{i_instr[31]}}, i_instr[7]    , i_instr[30:25], i_instr[11:8],  1'b0};   // B-Type
      3'b011:  o_im = {i_instr[31:12]   , 12'b0                                               };   // U-Type
      3'b100:  o_im = {{12{i_instr[31]}}, i_instr[19:12], i_instr[20]   , i_instr[30:21], 1'b0};   // J-Type
      default: o_im = 32'h00000000                                                             ;   // Default case
    endcase
  end : imm_src_sel

endmodule : imm_gen
