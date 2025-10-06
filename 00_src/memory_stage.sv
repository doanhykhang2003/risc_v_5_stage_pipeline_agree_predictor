module memory_stage(
  // Input Declaration
	input  logic        i_clk       , 
  input  logic        i_fast_clk  ,
  input  logic        i_rst_n     , 
  input  logic        i_rd_wren_m , 
  input  logic        i_mem_wren_m, 
	input  logic [1:0]  i_wb_sel_m  ,
	input  logic [2:0]  i_funct3    ,
	input  logic [4:0]  i_rd_m      ,
  input  logic [3:0]  i_io_btn    ,    // Input from buttons
  input  logic [3:0]  i_io_sw     ,    // Input from sw_data 
	input  logic [31:0] i_pc_four_m ,
  input  logic [31:0] i_st_data_m , 
  input  logic [31:0] i_alu_data_m,
  // Output Declaration
	output logic        o_rd_wren_w ,
	output logic [1:0]  o_wb_sel_w  ,
	output logic [4:0]  o_rd_w      ,
  output logic [6:0]  o_io_hex0   ,    // HEX0 display output
  output logic [6:0]  o_io_hex1   ,    // HEX1 display output
  output logic [6:0]  o_io_hex2   ,    // HEX2 display output
  output logic [6:0]  o_io_hex3   ,    // HEX3 display output
  output logic [6:0]  o_io_hex4   ,    // HEX4 display output
  output logic [6:0]  o_io_hex5   ,    // HEX5 display output
  output logic [6:0]  o_io_hex6   ,    // HEX6 display output
  output logic [6:0]  o_io_hex7   ,    // HEX7 display output
  output logic [9:0]  o_io_ledg   ,    // Green LEDs output
  output logic [9:0]  o_io_ledr   ,    // Red LEDs output
	output logic [31:0] o_pc_four_w , 
  output logic [31:0] o_alu_data_w, 
  output logic [31:0] o_ld_data_w ,
  output logic [31:0] o_io_lcd         // LCD display output
);
	
	// Declaration of Interim Logics 
	logic [31:0] ld_data_m;
	
	// Declaration of Modules Initiation
  lsu load_store_unit(
    // Input of lsu
    .i_clk     (i_clk       ),
    .i_fast_clk(i_fast_clk  ),
    .i_rst     (i_rst_n     ),
    .i_lsu_wren(i_mem_wren_m),
    .i_funct3  (i_funct3    ),  
    .i_lsu_addr(i_alu_data_m),        // Memory address
    .i_st_data (i_st_data_m ),        // Write data
    .i_io_btn  (i_io_btn    ),        // Input from buttons
    .i_io_sw   (i_io_sw     ),        // Input from switches (SW)
    // Output of lsu
    .o_ld_data (ld_data_m   ),        // Read data
    .o_io_lcd  (o_io_lcd    ),        // LCD display output
    .o_io_ledg (o_io_ledg   ),        // Green LEDs output
    .o_io_ledr (o_io_ledr   ),        // Red LEDs output
    .o_io_hex0 (o_io_hex0   ),        // HEX0 display output
    .o_io_hex1 (o_io_hex1   ),        // HEX1 display output
    .o_io_hex2 (o_io_hex2   ),        // HEX2 display output
    .o_io_hex3 (o_io_hex3   ),        // HEX3 display output
    .o_io_hex4 (o_io_hex4   ),        // HEX4 display output
    .o_io_hex5 (o_io_hex5   ),        // HEX5 display output
    .o_io_hex6 (o_io_hex6   ),        // HEX6 display output
    .o_io_hex7 (o_io_hex7   )         // HEX7 display output
  );

	// memory state pipeline register logics
	always @(posedge i_clk or negedge i_rst_n) begin
		if(i_rst_n == 1'b0) begin
			o_rd_wren_w  <= 1'b0        ;
			o_wb_sel_w   <= 2'b00       ;
			o_rd_w       <= 5'h00       ;
			o_pc_four_w  <= 32'h00000000; 
			o_alu_data_w <= 32'h00000000; 
			o_ld_data_w  <= 32'h00000000;
		end
		else begin
			o_rd_wren_w  <= i_rd_wren_m ;
			o_wb_sel_w   <= i_wb_sel_m  ;
			o_rd_w       <= i_rd_m      ;
			o_pc_four_w  <= i_pc_four_m ; 
			o_alu_data_w <= i_alu_data_m; 
			o_ld_data_w  <= ld_data_m   ;
		end
	end

endmodule
