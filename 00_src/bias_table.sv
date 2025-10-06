module bias_table (
  input  logic        i_clk         ,
  input  logic        i_rst_n       ,
  input  logic        i_valid_update,
  input  logic [31:0] i_pc          ,
  input  logic        i_actual_taken,
  output logic        o_bias
);

  logic       bias_bits [0:255];
  logic [7:0] index            ;

  assign index = i_pc[9:2];

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      for (int i = 0; i < 256; i++) begin 
        bias_bits[i] <= 1'b0;
      end
    end
    else if (i_valid_update) begin
      bias_bits[index] <= i_actual_taken; // Update bias with actual taken
    end
  end

  assign o_bias = bias_bits[index] | i_actual_taken;

endmodule : bias_table
