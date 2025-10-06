module btb (
  input  logic 				i_clk					,
  input  logic 				i_rst_n				,
  input  logic        i_is_jump     ,
  input  logic 				i_valid_update,
  input  logic        i_is_branch   ,
  input  logic [31:0] i_pc					,
  input  logic [31:0] i_target_pc		,
  output logic [31:0] o_predicted_pc,
  output logic 				o_hit
);

  logic [31:0] btb_table   [0:255];
  logic [19:0] tag_table   [0:255];
  logic 		   valid_table [0:31] ;
  logic [7:0]  index              ;
  logic [19:0] tag                ;
	 
	assign index = i_pc[9:2]	;
	assign tag   = i_pc[31:12];
	 
  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      for (int i = 0; i < 256; i = i + 1) begin
        btb_table[i]   <= 32'b0;
        tag_table[i]   <= 20'b0;
        valid_table[i] <= 1'b0 ;
      end
    end else begin
			if (i_valid_update) begin
				btb_table[index]   <= i_target_pc;
				tag_table[index]   <= tag				 ;
				valid_table[index] <= 1'b1			 ;
			end
		end
  end

  always_comb begin: check_tag
		o_hit = 0;
    if ((valid_table[index] && (tag_table[index] == tag) && i_is_branch) | i_is_jump) begin
      o_predicted_pc = btb_table[index];
      o_hit 				 = 1							 ;
    end else begin
      o_predicted_pc = 32'b0;
      o_hit          = 0    ;
    end
  end

endmodule: btb
