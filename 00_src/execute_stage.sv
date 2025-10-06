module execute_stage(
  // Input Declaration
	input  logic        i_clk           , 
  input  logic        i_rst_n         , 
  input  logic        i_rd_wren_e     , 
  input  logic        i_op_b_sel_e    , 
  input  logic        i_mem_wren_e    ,  
  input  logic        i_op_a_sel_e    ,
  input  logic        i_pc_sel_e      ,
	input  logic        i_taken_e       ,
	input  logic [1:0]  i_wb_sel_e      ,
  input  logic [1:0]  i_foward_a_e    ,  
  input  logic [1:0]  i_foward_b_e    ,
	input  logic [2:0]  i_funct3        ,
	input  logic [4:0]  i_alu_op_e      ,
  input  logic [4:0]  i_rd_e          ,
	input  logic [31:0] i_predicted_pc_e,
  input  logic [31:0] i_instr_e       ,
	input  logic [31:0] i_rd1_e         , 
  input  logic [31:0] i_rd2_e         , 
  input  logic [31:0] i_imm_e         ,
	input  logic [31:0] i_pc_e          ,  
  input  logic [31:0] i_pc_four_e     , 
	input  logic [31:0] i_wb_data_w     ,
  // Output Declaration
	output logic        o_rd_wren_m     ,  
  output logic        o_mem_wren_m    , 
  output logic        o_pc_sel_final  ,
	output logic        o_taken_flush   ,
	output logic [1:0]  o_wb_sel_m      ,
	output logic [2:0]  o_funct3_e      ,
	output logic [4:0]  o_rd_m          ,
	output logic [31:0] o_pc_four_m     ,  
  output logic [31:0] o_st_data_m     , 
  output logic [31:0] o_alu_data_m    , 
  output logic [31:0] o_alu_data_e 
);
	// Declaration of Interim Logics
  logic        br_un              ;
  logic        br_less            ;
  logic        br_equal           ;
  logic        brc_ctrl_sel       ;
  logic        op_a_sel           ;
  logic        op_a_sel_final     ; 
  logic        pc_sel             ;
	logic [31:0] rs1_data_forwarding;
	logic [31:0] rs2_data_forwarding;
  logic [31:0] operand_a_e        ;
  logic [31:0] operand_b_e        ;
	logic [31:0] alu_data_e         ;
	
	// Declaration of Modules
  // branch comparison
  brc brc_comp(
    .i_rs1_data(rs1_data_forwarding),
    .i_rs2_data(rs2_data_forwarding),
    .i_br_un   (br_un              ),
    .o_br_less (br_less            ),
    .o_br_equal(br_equal           )
  );

  // branch control unit
  br_ctr_unit brctr (
    .i_instr_e     (i_instr_e   ),
    .i_br_less     (br_less     ),
    .i_br_equal    (br_equal    ),
		.o_br_un			 (br_un				),
    .o_brc_ctrl_sel(brc_ctrl_sel),
    .op_a_sel      (op_a_sel    ),
    .pc_sel        (pc_sel      )
  );

  // pc sel mux
  always_comb begin
    if  (brc_ctrl_sel) o_pc_sel_final = pc_sel    ;
    else               o_pc_sel_final = i_pc_sel_e;
  end

  // branch operand_a mux
  always_comb begin
    if  (brc_ctrl_sel) op_a_sel_final = op_a_sel    ;
    else               op_a_sel_final = i_op_a_sel_e;
  end

	// fowarding mux for operand a
	mux3_1 fowarding_operand_a_mux(
		.a(i_rd1_e            ),
		.b(i_wb_data_w        ),
		.c(o_alu_data_m       ),
		.s(i_foward_a_e       ),
		.d(rs1_data_forwarding)
	);

  // operand a mux
  mux2_1 operand_a_mux (
    .a(rs1_data_forwarding),
    .b(i_pc_e             ),
    .s(op_a_sel_final     ),
    .c(operand_a_e        )
  );
	
	// fowarding operand for source b
	mux3_1 src_b_mux(
		.a(i_rd2_e            ),
		.b(i_wb_data_w        ),
		.c(o_alu_data_m       ),
		.s(i_foward_b_e       ),
		.d(rs2_data_forwarding)
	);

	// operand b mux
	mux2_1 alu_src_mux(
		.a(rs2_data_forwarding),
		.b(i_imm_e            ),
		.s(i_op_b_sel_e       ),
		.c(operand_b_e        )
	);
	
	// alu unit
	alu alu_unit(
		.i_operand_a(operand_a_e),
		.i_operand_b(operand_b_e),	
		.i_alu_op   (i_alu_op_e ),
		.o_alu_data (alu_data_e )
	);

	// taken flush handling
	always_comb begin
		if (o_pc_sel_final == i_taken_e) begin
			o_taken_flush = 1'b0;
		end else begin
			o_taken_flush = 1'b1;
		end
	end
	
	// execute stage pipeline register logics
	always @(posedge i_clk or negedge i_rst_n) begin
		if(i_rst_n == 1'b0) begin
			o_rd_wren_m  <= 1'b0        ; 
			o_mem_wren_m <= 1'b0        ; 
			o_wb_sel_m   <= 2'b00       ;
			o_funct3_e   <= 3'b000      ;
			o_rd_m       <= 5'h00       ;
			o_pc_four_m  <= 32'h00000000; 
			o_st_data_m  <= 32'h00000000; 
			o_alu_data_m <= 32'h00000000;
		end
		else begin
			o_rd_wren_m  <= i_rd_wren_e        ; 
			o_mem_wren_m <= i_mem_wren_e       ; 
			o_wb_sel_m   <= i_wb_sel_e         ;
			o_funct3_e   <= i_funct3           ;
			o_rd_m       <= i_rd_e             ;
			o_pc_four_m  <= i_pc_four_e        ; 
			o_st_data_m  <= rs2_data_forwarding; 
			o_alu_data_m <= alu_data_e         ;
		end
	end
	
	// assign output statements
	assign o_alu_data_e = alu_data_e;

endmodule
