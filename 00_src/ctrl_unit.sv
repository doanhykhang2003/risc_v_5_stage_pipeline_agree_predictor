module ctrl_unit(
  // Input Declarations
  input  logic [31:0] i_instr    ,
  // Output Declarations
  output logic        o_pc_sel   ,
  output logic        o_is_jump  ,
  output logic        o_rd_wren  ,
  output logic        o_insn_vld ,
  output logic        o_btb_valid,
  output logic [2:0]  o_imm_src  ,
  output logic        o_op_a_sel ,
  output logic        o_op_b_sel ,
  output logic [4:0]  o_alu_op   ,
  output logic        o_mem_wren ,
  output logic [1:0]  o_wb_sel  
);

  logic [1:0] alu_op_data  ;
  logic       is_mul_inst  ; // Indicates if instruction is MUL-type from M-extension
  logic       is_shift_inst; // Indicates if instruction is SRL/SRA type

  always_comb begin : main_decoder
  o_pc_sel    = 1'b0  ;
  o_rd_wren   = 1'b0  ;
  o_btb_valid = 1'b0  ;
  o_is_jump   = 1'b0  ;
  o_insn_vld  = 1'b0  ;
  o_imm_src   = 3'b000;
  o_op_a_sel  = 1'b0  ;
  o_op_b_sel  = 1'b0  ;
  alu_op_data = 2'b00 ;
  o_mem_wren  = 1'b0  ;
  o_wb_sel    = 2'b00 ;
    case(i_instr[6:0])
      7'b0110011: begin // R-type instruction
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b000;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b0  ;
        alu_op_data = 2'b10 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b00 ;
      end
      7'b0010011: begin // I-type instruction (Operation Instruction)
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b000;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b10 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b00 ;
      end
      7'b0000011: begin // I-type instruction (Load Instruction)
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b000;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b00 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b01 ;
      end
      7'b1100111: begin // I-type instruction (JALR Instruction)
        o_pc_sel    = 1'b1  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b1  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b000;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b00 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b10 ;
      end
      7'b0100011: begin // S-type instruction
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b0  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b001;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b00 ;
        o_mem_wren  = 1'b1  ;
        o_wb_sel    = 2'b00 ;
      end
      7'b1100011: begin // B-type instruction
        o_insn_vld  = 1'b1  ;
        o_btb_valid = 1'b1  ;
        o_is_jump   = 1'b0  ;
        alu_op_data = 2'b00 ;
        o_op_b_sel  = 1'b1  ;
        o_imm_src   = 3'b010;
      end
      7'b1101111: begin // J-type instruction
        o_pc_sel    = 1'b1  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b1  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b100;
        o_op_a_sel  = 1'b1  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b00 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b10 ;
      end
      7'b0110111: begin // LUI instruction
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b011;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b01 ; 
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b00 ;
      end
      7'b0010111: begin // AUIPC instruction
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b1  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b1  ;
        o_imm_src   = 3'b011;
        o_op_a_sel  = 1'b1  ;
        o_op_b_sel  = 1'b1  ;
        alu_op_data = 2'b00 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b00 ;
      end
      default begin
        o_pc_sel    = 1'b0  ;
        o_rd_wren   = 1'b0  ;
        o_btb_valid = 1'b0  ;
        o_is_jump   = 1'b0  ;
        o_insn_vld  = 1'b0  ;
        o_imm_src   = 3'b000;
        o_op_a_sel  = 1'b0  ;
        o_op_b_sel  = 1'b0  ;
        alu_op_data = 2'b00 ;
        o_mem_wren  = 1'b0  ;
        o_wb_sel    = 2'b00 ;
      end
    endcase 
  end

  always_comb begin : alu_decoder
    // Default values
    o_alu_op      = 5'b00000                                                     ;
    is_mul_inst   = (i_instr[31:25] == 7'b0000001) & (i_instr[6:0] == 7'b0110011);    // Check for M-extension (MUL/DIV)
    is_shift_inst = (i_instr[31:25] == 7'b0100000)                               ;    // Shift right logical or arithmetic
    // Decode ALU operation based on alu_op_data and i_funct3
    case (alu_op_data)
      2'b01:   o_alu_op = 5'b01111;         // LUI (U-type instruction)
      2'b10: begin
      	case (i_instr[14:12])
          3'b000:  o_alu_op = is_shift_inst ? 5'b00001 : 5'b00000;  // ADD/SUB | ADDI
          3'b001:  o_alu_op = 5'b00111                           ;  // SLL | SLLI
          3'b010:  o_alu_op = 5'b01101                           ;  // SLT | SLTI
          3'b011:  o_alu_op = 5'b01110                           ;  // SLTU | SLTUI
          3'b100:  o_alu_op = 5'b00110                           ;  // XOR | XORI
          3'b101:  o_alu_op = is_shift_inst ? 5'b01010 : 5'b01000;  // SRL/SRA | SRLI/SRAI
          3'b110:  o_alu_op = 5'b00011                           ;  // OR | ORI
          3'b111:  o_alu_op = 5'b00010                           ;  // AND | ANDI
          default: o_alu_op = 5'b00000                           ;
        endcase
        // Handle M extension (MUL/DIV instructions)
        if (is_mul_inst) begin
          case (i_instr[14:12])
            3'b000:  o_alu_op = 5'b10000;  // MUL
            3'b001:  o_alu_op = 5'b10001;  // MULH
            3'b010:  o_alu_op = 5'b10010;  // MULHSU
            3'b011:  o_alu_op = 5'b10011;  // MULHU
            3'b100:  o_alu_op = 5'b10100;  // DIV
            3'b101:  o_alu_op = 5'b10101;  // DIVU
            3'b110:  o_alu_op = 5'b10110;  // REM
            3'b111:  o_alu_op = 5'b10111;  // REMU
            default: o_alu_op = 5'b00000;
          endcase
        end
      end
      2'b00:   o_alu_op = 5'b00000;         // U-type instruction (default to NOP)
      default: o_alu_op = 5'b00000;
  	endcase
  end : alu_decoder

endmodule : ctrl_unit
