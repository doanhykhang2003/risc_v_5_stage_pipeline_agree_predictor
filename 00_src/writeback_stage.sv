module writeback_stage(
  // Input Declaration
	input  logic [1:0]  i_wb_sel_w  ,
	input  logic [31:0] i_pc_four_w , 
  input  logic [31:0] i_alu_data_w, 
  input  logic [31:0] i_ld_data_w ,
  // Output Declaration
	output logic [31:0] o_wb_data_w
);
	
	// Declaration of Module
	// writeback mux
	mux3_1 result_mux(
		.a(i_alu_data_w),
		.b(i_ld_data_w ),
		.c(i_pc_four_w ),
		.s(i_wb_sel_w  ),
		.d(o_wb_data_w )
	);

endmodule
