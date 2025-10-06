module fetch_stage(
  // Input Declaration
	input  logic        i_clk           , 
  input  logic        i_rst_n         ,
	input  logic        i_pc_sel_e      , 
	input  logic        i_is_jump_e     ,
	input  logic        i_btb_valid_e   , 
  input  logic        i_stall_d       , 
  input  logic        i_stall_f       , 
  input  logic        i_flush_d       ,
	input  logic        i_taken_flush   ,
	input  logic [31:0] i_alu_data_e    ,
  // Output Declaration
	output logic        o_taken_d       ,
	output logic [31:0] o_predicted_pc_d,
	output logic [31:0] o_instr_d       ,
	output logic [31:0] o_pc_d          , 
  output logic [31:0] o_pc_four_d   
);
	//Declare interim Logics
	logic        taken_f       ;
	logic [31:0] pc_f     	   ;
  logic [31:0] pcf      	   ;
  logic [31:0] pc_four_f	   ;
	logic [31:0] instr_f  	   ;
	logic [31:0] predicted_pc_f;
	
	//Initiation of Modules
	// agree predictor
	agree_predictor predictor_inst(
		.i_clk          (i_clk         ),  // Global system clock
  	.i_rst_n        (i_rst_n       ),  // Negative edge reset
		.i_pc           (pcf           ),  // PC
		.i_is_jump      (i_is_jump_e   ),  // Detect jump instructions
		.i_taken_flush  (i_taken_flush ),  // Misprediction
		.i_is_branch    (i_btb_valid_e ),  // Detect branch instructions
		.i_valid_update (i_pc_sel_e    ),  // BTB valid update
		.i_actual_target(i_alu_data_e  ),  // branch target from execute stage
		.i_actual_taken (i_pc_sel_e    ),  // branch decision from execute stage
		.o_predicted_pc (predicted_pc_f),  // predict pc
		.o_taken        (taken_f       )
	);

	// program counter mux
	mux2_1 pc_mux(
		.a(pc_four_f     ), 
		.b(predicted_pc_f), 
		.s(taken_f       ), 
		.c(pc_f          )
	);
	
	// program counter
	PC program_counter(
		.i_clk    (i_clk    ),
		.i_rst_n  (i_rst_n  ),
		.i_stall_f(i_stall_f),
		.i_pc_next(pc_f     ),
		.o_pc     (pcf      )
	);
	
	// instruction memory
	instr_mem imem(
		.i_rst_n(i_rst_n),
		.i_pc   (pcf    ),
		.o_instr(instr_f)
	); 
	
	// pc four adder
	adder pc_adder(
		.a(pcf         ),
		.b(32'h00000004),
		.c(pc_four_f   )
	);
	
	// fetch stage pipeline register logics
	always @(posedge i_clk or negedge i_rst_n) begin
		if(i_rst_n == 1'b0) begin
			o_taken_d        <= 1'b0        ;
			o_instr_d        <= 32'h00000000;
			o_pc_d           <= 32'h00000000;
			o_predicted_pc_d <= 32'h00000000;	
			o_pc_four_d      <= 32'h00000000;
		end else if (i_stall_d) begin
      // No change during stall
    end else if (i_flush_d) begin
			o_taken_d        <= 1'b0        ;
			o_instr_d        <= 32'h00000000;
			o_pc_d           <= 32'h00000000;
			o_predicted_pc_d <= 32'h00000000;	
			o_pc_four_d      <= 32'h00000000;
    end else begin
			o_taken_d        <= taken_f       ;
			o_instr_d        <= instr_f       ;
			o_pc_d           <= pcf           ;
			o_predicted_pc_d <= predicted_pc_f;	
			o_pc_four_d      <= pc_four_f     ;
		end
	end

endmodule
