module alu(
  // Input Declarations
  input  logic [4:0]  i_alu_op   ,
  input  logic [31:0] i_operand_a,
  input  logic [31:0] i_operand_b,
  // Output Declarations
  output logic [31:0] o_alu_data
);

  logic [63:0] mul_high                    ;
  logic [63:0] mul_high_signed_and_unsigned;
  logic [63:0] mul_high_unsigned           ;

  // Multiplication results
  always_comb begin : high_mul
    mul_high                     = $signed(i_operand_a) * $signed(i_operand_b)                         ;
    mul_high_signed_and_unsigned = $signed({{32{i_operand_a[31]}}, i_operand_a}) * {32'b0, i_operand_b};
    mul_high_unsigned            = i_operand_a * i_operand_b                                           ;
  end : high_mul

  // ALU operation selection
  always_comb begin : alu_op_sel
    case (i_alu_op)
      5'b00000:                   o_alu_data = i_operand_a +  i_operand_b                                                     ; // ADD 
	    5'b00001:			              o_alu_data = i_operand_a -  i_operand_b																	                    ; // SUB
      5'b00010:                   o_alu_data = i_operand_a &  i_operand_b                                                     ; // AND
      5'b00011:                   o_alu_data = i_operand_a |  i_operand_b                                                     ; // OR
      5'b00110:                   o_alu_data = i_operand_a ^  i_operand_b                                                     ; // XOR
      5'b00111:                   o_alu_data = i_operand_a << i_operand_b[4:0]                                                ; // SLL
      5'b01000:                   o_alu_data = i_operand_a >> i_operand_b[4:0]                                                ; // SRL
      5'b01001:                   o_alu_data = i_operand_a -  i_operand_b[4:0]                                                ; // SUB
      5'b01010:                   o_alu_data = i_operand_a >>> i_operand_b[4:0]                                               ; // SRA
      5'b01101:                   o_alu_data = ($signed(i_operand_a) < $signed(i_operand_b))                                  ; // SLT
      5'b01110:                   o_alu_data = i_operand_a < i_operand_b                                                      ; // SLTU
      5'b01111:                   o_alu_data = i_operand_b                                                                    ; // LUI operation
      // milstone 3 objection
      5'b10000:                   o_alu_data = $signed(i_operand_a) * $signed(i_operand_b)                                    ; // MUL
      5'b10001:                   o_alu_data = mul_high[63:32]                                                                ; // MULH
      5'b10010:                   o_alu_data = mul_high_signed_and_unsigned[63:32]                                            ; // MULHSU
      5'b10011:                   o_alu_data = mul_high_unsigned[63:32]                                                       ; // MULHU
      5'b10100: begin 
        if     (i_operand_b == 0) o_alu_data = 32'hFFFFFFFF                                                                   ; // DIV
        else if(i_operand_a == 32'h80000000 && i_operand_b == 32'hFFFFFFFF) o_alu_data = i_operand_a                          ; 
        else                      o_alu_data = $signed(i_operand_a) / $signed(i_operand_b)                                    ;
      end
      5'b10101: begin 
        if (i_operand_b != 0)     o_alu_data = i_operand_a / i_operand_b                                                      ; // DIVU
        else                      o_alu_data = 32'hFFFFFFFF                                                                   ;
      end   
      5'b10110: begin
        if     (i_operand_b == 0) o_alu_data = i_operand_a                                                                    ; // DIV
        else if(i_operand_a == 32'h80000000 && i_operand_b == 32'hFFFFFFFF) o_alu_data = 32'h00000000                         ; 
        else                      o_alu_data = $signed(i_operand_a) % $signed(i_operand_b)                                    ;
      end            
      5'b10111: begin
        if(i_operand_b != 0)  o_alu_data = i_operand_a % i_operand_b                                                          ;  // REMU
        else                  o_alu_data = i_operand_a                                                                        ; 
      end            
      default:                o_alu_data = 32'h00000000                                                                       ; // Default case
    endcase
  end : alu_op_sel

endmodule : alu
