module decode_stage(
  // Input Declaration
	input  logic         i_clk           ,
  input  logic         i_rst_n         ,
  input  logic         i_rd_wren_w     , 
	input  logic         i_taken_d       ,
  input  logic         i_flush_e       , 
  input  logic         i_forward_a_d   , 
  input  logic         i_forward_b_d   ,
	input  logic [4:0]   i_rd_w          ,
	input  logic [31:0]  i_predicted_pc_d,
	input  logic [31:0]  i_instr_d       , 
  input  logic [31:0]  i_pc_d          , 
  input  logic [31:0]  i_pc_four_d     , 
  input  logic [31:0]  i_wb_data_w     ,  
  input  logic [31:0]  i_alu_data_m    , 
  // Output Declaration
  output logic         o_insn_vld_e    ,
	output logic         o_rd_wren_e     , 
  output logic         o_op_b_sel_e    , 
  output logic         o_op_a_sel_e    ,
  output logic         o_mem_wren_e    , 
	output logic         o_pc_sel_e		   ,
	output logic         o_taken_e       ,
	output logic         o_btb_valid_e   ,
	output logic         o_is_jump_e     ,
	output logic [1:0]   o_wb_sel_e      ,
	output logic [4:0]   o_alu_op_e      ,
	output logic [4:0]   o_rs1_e         , 
  output logic [4:0]   o_rs2_e         , 
  output logic [4:0]   o_rd_e          ,
	output logic [31:0]  o_predicted_pc_e,
	output logic [31:0]  o_instr_e		   ,
	output logic [31:0]  o_rd1_e         ,
  output logic [31:0]  o_rd2_e         , 
  output logic [31:0]  o_imm_e         ,
	output logic [31:0]  o_pc_e          , 
  output logic [31:0]  o_pc_four_e     ,
	output logic [31:0]  x1              ,
  output logic [31:0]  x2              ,
  output logic [31:0]  x3              ,
  output logic [31:0]  x4              ,
  output logic [31:0]  x5        		   ,
  output logic [31:0]  x6              ,
  output logic [31:0]  x7       	     ,
  output logic [31:0]  x8        	     ,
  output logic [31:0]  x9        		   ,
  output logic [31:0]  x10       		   ,
  output logic [31:0]  x11       		   ,
  output logic [31:0]  x12       		   ,
  output logic [31:0]  x13       		   ,
  output logic [31:0]  x14             ,
  output logic [31:0]  x15        
);
	
	// Declare Interim Logics
	logic        rd_wren_d    ;
  logic        insn_vld_d   ;
	logic        op_a_sel_d   ;
  logic        op_b_sel_d   ;
  logic        mem_wren_d   ;
  logic 			 pc_sel_d     ;
	logic        btb_valid_d	;
	logic        is_jump_d    ;
  logic        forward_a_fix;
  logic        forward_b_fix;
	logic [1:0]  wb_sel_d     ;
	logic [2:0]  imm_src_d    ;
	logic [4:0]  alu_op_d     ;
	logic [31:0] rd1_d        ;
  logic [31:0] rd1_d_src    ;
  logic [31:0] rd2_d        ;
  logic [31:0] rd2_d_src    ;
  logic [31:0] imm_d        ;
	
	// Initiate the modules
	// control unit
	ctrl_unit control_unit(
    // input of ctrl_unit
    .i_instr    (i_instr_d       ), 
    // output of ctrl_unit
    .o_insn_vld (insn_vld_d      ),
    .o_pc_sel   (pc_sel_d        ),  
		.o_rd_wren  (rd_wren_d       ),
		.o_btb_valid(btb_valid_d		 ),
		.o_is_jump  (is_jump_d       ),
		.o_imm_src  (imm_src_d       ),
    .o_op_a_sel (op_a_sel_d      ),
		.o_op_b_sel (op_b_sel_d      ),
		.o_mem_wren (mem_wren_d      ),
		.o_wb_sel   (wb_sel_d        ),
		.o_alu_op   (alu_op_d        )
	);
	
	// register file
	regfile regiter_file(
    // input of regfile
		.i_clk     (i_clk           ),
		.i_rst     (i_rst_n         ),
		.i_rd_wren (i_rd_wren_w     ),
		.i_rd_data (i_wb_data_w     ),
		.i_rs1_addr(i_instr_d[19:15]),
		.i_rs2_addr(i_instr_d[24:20]),
		.i_rd_addr (i_rd_w          ),
    // output of regfile
		.o_rs1_data(rd1_d           ),
		.o_rs2_data(rd2_d						),
		// Registers content check
		.x1        (x1          		),
    .x2        (x2          		),
    .x3        (x3          		),
    .x4        (x4          		),
    .x5        (x5          		),
    .x6        (x6          		),
    .x7        (x7          		),
    .x8        (x8          		),
    .x9        (x9          		),
    .x10       (x10         		),
    .x11       (x11         		),
    .x12       (x12         		),
    .x13       (x13         		),
    .x14       (x14         		),
    .x15       (x15         		) 
	);

	// Update Fixing Fowarding Blocks
	// detecting fowarding forth case
	always_comb begin
		if(i_rd_wren_w & (i_rd_w == i_instr_d[19:15])) begin
			forward_a_fix = 1'b1;
		end else begin
			forward_a_fix = 1'b0;
		end
	end

	always_comb begin
		if(i_rd_wren_w & (i_rd_w == i_instr_d[24:20])) begin
			forward_b_fix = 1'b1;
		end else begin
			forward_b_fix = 1'b0;
		end
	end

	// update value based on fowarding cases
	always_comb begin
		if((i_instr_d[19:15] == 5'b00000)) begin
			rd1_d_src   = 32'h00000000;
		end else begin
			if (forward_a_fix) begin
				rd1_d_src = i_wb_data_w ;
			end else if(i_forward_a_d) begin
				rd1_d_src = i_alu_data_m;
			end else begin
				rd1_d_src = rd1_d       ;
			end
		end
	end

	always_comb begin
		if((i_instr_d[24:20] == 5'b00000)) begin
			rd2_d_src   = 32'h00000000;
		end else begin
			if (forward_b_fix) begin
				rd2_d_src = i_wb_data_w ;
			end else if(i_forward_b_d) begin
				rd2_d_src = i_alu_data_m;
			end else begin
				rd2_d_src = rd2_d       ;
			end
		end
	end

	// immediate generator
	imm_gen immediate_generator(
		// input of imm_gen
		.i_instr  (i_instr_d),
    .i_imm_src(imm_src_d),
		// output of imm_gen
		.o_im     (imm_d    )
	);
	
	// decode stage pipeline register logics
  // check new ctrl unit signal 
	always @(posedge i_clk or negedge i_rst_n) begin
		if(i_rst_n == 1'b0) begin
			o_rd_wren_e      <= 1'b0        ;
      o_insn_vld_e     <= 1'b0        ;
			o_op_b_sel_e     <= 1'b0        ;
			o_mem_wren_e     <= 1'b0        ;
			o_op_a_sel_e     <= 1'b0        ;
			o_pc_sel_e	     <= 1'b0	  		;
			o_taken_e        <= 1'b0        ;
			o_btb_valid_e    <= 1'b0        ;
			o_is_jump_e      <= 1'b0        ;
			o_wb_sel_e       <= 2'b00       ;
			o_alu_op_e       <= 3'b000      ;
			o_instr_e        <= 32'h00000000;
			o_rd1_e          <= 32'h00000000;
			o_rd2_e          <= 32'h00000000;
			o_imm_e          <= 32'h00000000;
			o_rd_e           <= 5'h00       ;
			o_pc_e           <= 32'h00000000;
			o_predicted_pc_e <= 32'h00000000;
			o_pc_four_e      <= 32'h00000000;
			o_rs1_e          <= 5'h00       ;
			o_rs2_e          <= 5'h00       ;
		end else if(i_flush_e) begin
			o_rd_wren_e      <= 1'b0        ;
      o_insn_vld_e     <= 1'b0        ;
			o_op_b_sel_e     <= 1'b0        ;
			o_mem_wren_e     <= 1'b0        ;
			o_op_a_sel_e     <= 1'b0        ;
			o_pc_sel_e	     <= 1'b0	  		;
			o_taken_e        <= 1'b0        ;
			o_btb_valid_e    <= 1'b0        ;
			o_is_jump_e      <= 1'b0        ;
			o_wb_sel_e       <= 2'b00       ;
			o_alu_op_e       <= 3'b000      ;
			o_instr_e        <= 32'h00000000;
			o_rd1_e          <= 32'h00000000;
			o_rd2_e          <= 32'h00000000;
			o_imm_e          <= 32'h00000000;
			o_rd_e           <= 5'h00       ;
			o_pc_e           <= 32'h00000000;
			o_predicted_pc_e <= 32'h00000000;
			o_pc_four_e      <= 32'h00000000;
			o_rs1_e          <= 5'h00       ;
			o_rs2_e          <= 5'h00       ;
		end else begin
			o_rd_wren_e      <= rd_wren_d       ;
      o_insn_vld_e     <= insn_vld_d      ;
			o_op_b_sel_e     <= op_b_sel_d      ;
			o_mem_wren_e     <= mem_wren_d      ;
			o_op_a_sel_e     <= op_a_sel_d      ;
			o_pc_sel_e	     <= pc_sel_d				;
			o_btb_valid_e    <= btb_valid_d     ;
			o_is_jump_e      <= is_jump_d       ;
			o_taken_e        <= i_taken_d       ;
			o_wb_sel_e       <= wb_sel_d        ;
			o_alu_op_e       <= alu_op_d        ;
			o_instr_e        <= i_instr_d			  ;
			o_rd1_e          <= rd1_d_src       ;
			o_rd2_e          <= rd2_d_src       ;
			o_imm_e          <= imm_d           ;
			o_rd_e           <= i_instr_d[11:7] ;
			o_pc_e           <= i_pc_d          ;
			o_predicted_pc_e <= i_predicted_pc_d;
			o_pc_four_e      <= i_pc_four_d     ;
			o_rs1_e          <= i_instr_d[19:15];
			o_rs2_e          <= i_instr_d[24:20];
		end
	end

endmodule
