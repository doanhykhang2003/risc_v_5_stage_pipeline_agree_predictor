module data_memory(
  input               i_clk           , 
  input               i_wren          ,
  input        [31:0] i_addr          , 
  input        [31:0] i_st_data       ,
  output logic [31:0] o_dmem_load_data
);

  logic [31:0]   mem [2047:0]  ;                // Address range: 0x0000 - 0x1E0F
  logic [31:0]   addr_reg      ;                // Address storage

  // Write Operation
  always_ff @(posedge i_clk) begin : write_operation
    addr_reg <= i_addr;
    if(i_wren) begin
      mem[i_addr] <= i_st_data;
    end 
  end

  // Read Operation
  always_comb begin : read_operation
    o_dmem_load_data = mem[addr_reg];
  end 

endmodule : data_memory
