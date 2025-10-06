module instr_mem(
  input  logic        i_rst_n     ,
  input  logic [31:0] i_pc        ,
  output logic [31:0] o_instr
);

  parameter MEM_SIZE = 2048;
  logic [31:0] mem [MEM_SIZE-1:0];

  // o_instruction fetch logic
  always_comb begin : next_pc_ff
    if      (!i_rst_n)             o_instr <= 32'b0          ;  // Reset o_instruction to zero if i_rst_n is low
    else                           o_instr <= mem[i_pc[31:2]];  // Fetch o_instruction from memory based on the i_pc value
  end : next_pc_ff

  // Initialize memory with values from hex file
  initial begin
    integer i;
    for (i = 0; i < MEM_SIZE; i++) begin
      mem[i] = 32'b0; // Initialize memory to zero
    end
    // Load memory content from a hex file
    $readmemh("D:/BK_University_Courses/Senior_Design_Project/risc_v_pipeline_agree/02_test/dump/mem.dump", mem);
  end

endmodule : instr_mem
