module pipeline_agree_predictor(
  // Input Declaration
  input  logic         i_clk     , 
  input  logic         i_rst_n   ,
  input  logic [3:0]   i_io_btn  ,               // Input from buttons
  input  logic [3:0]   i_io_sw   ,               // Input from switches 
  // Output Declaration
  output logic         o_insn_vld,
  output logic [6:0]   o_io_hex0 ,               // HEX0 display output
  output logic [6:0]   o_io_hex1 ,               // HEX1 display output
  output logic [6:0]   o_io_hex2 ,               // HEX2 display output
  output logic [6:0]   o_io_hex3 ,               // HEX3 display output
  output logic [6:0]   o_io_hex4 ,               // HEX4 display output
  output logic [6:0]   o_io_hex5 ,               // HEX5 display output
  output logic [6:0]   o_io_hex6 ,               // HEX6 display output
  output logic [6:0]   o_io_hex7 ,               // HEX7 display output
  output logic [9:0]   o_io_ledr ,               // Red LEDs output
  output logic [9:0]   o_io_ledg ,               // Green LEDs output
  output logic [31:0]  o_io_lcd  ,               // LCD display output
  output logic [31:0]  o_pc_debug,               // Debug output test
  output logic [31:0]  o_wb_data ,
  output logic [31:0]  x1        ,
  output logic [31:0]  x2        ,
  output logic [31:0]  x3        ,
  output logic [31:0]  x4        ,
  output logic [31:0]  x5      	 ,
  output logic [31:0]  x6        ,
  output logic [31:0]  x7    	   ,
  output logic [31:0]  x8        ,
  output logic [31:0]  x9        ,
  output logic [31:0]  x10       ,
  output logic [31:0]  x11       ,
  output logic [31:0]  x12       ,
  output logic [31:0]  x13       ,
  output logic [31:0]  x14       ,
  output logic [31:0]  x15        
);

  // Declaration of Interim logics
  //========================Fetch_Stage_Logics========================//
  logic        stall_f       ;
  logic        taken_d       ;
  logic [31:0] predicted_pc_d;

  //========================Decode_Stage_Logics=======================//
  logic        pc_sel_final  ;
  logic        taken_e       ;
  logic        btb_valid_e   ;
  logic        is_jump_e     ;
  logic        stall_d       ;
  logic        flush_d       ;
  logic        forward_a_d   ;
  logic        forward_b_d   ;
  logic        br_equal_e    ;
  logic        br_less_e     ;
  logic        br_un_e       ;
  logic        pc_sel_e      ;
  logic [31:0] instr_e       ;
  logic [31:0] pc_d          ;
  logic [31:0] predicted_pc_e;
  logic [31:0] pc_four_d     ;
  logic [31:0] instr_d       ;

  //========================Execute_Stage_Logics======================//
  logic        flush_e    ;
  logic        taken_flush;
  logic        insn_vld_e ;
  logic        rd_wren_e  ;
  logic        op_a_sel_e ;
  logic        op_b_sel_e ;
  logic        mem_wren_e ;
  logic [1:0]  wb_sel_e   ;
  logic [1:0]  forward_a_e;
  logic [1:0]  forward_b_e;
  logic [4:0]  alu_op_e   ;
  logic [4:0]  rs1_e      ;
  logic [4:0]  rs2_e      ;    
  logic [4:0]  rd_e       ; 
  logic [31:0] rd1_e      ;
  logic [31:0] rd2_e      ;
  logic [31:0] imm_e      ;
  logic [31:0] pc_e       ;
  logic [31:0] pc_four_e  ;

  //=======================Memory_Stage_Logics========================//
  logic        rd_wren_m  ;
  logic        mem_wren_m ;
  logic [1:0]  wb_sel_m   ;
  logic [2:0]  funct3_e   ;
  logic [4:0]  rd_m       ;
  logic [31:0] alu_data_e ;
  logic [31:0] pc_target_e;
  logic [31:0] pc_four_m  ;
  logic [31:0] st_data_m  ;

  //======================Writeback_Stage_Logics======================//
  logic        rd_wren_w  ;
  logic [1:0]  wb_sel_w   ;
  logic [4:0]  rd_w       ;
  logic [31:0] pc_four_w  ;
  logic [31:0] alu_data_w ;
  logic [31:0] alu_data_m ;
  logic [31:0] ld_data_w  ;
  logic [31:0] wb_data_w  ;

  // Clock divider
  logic clk_div;
  clock_divider clk_divi(
    .in (i_clk  ),  // input clock signal
    .out(clk_div)   // divided clock signal
  );

  //==================Module Declaration==================//
  fetch_stage FETCH_STAGE(
    // input of fetch stage
	  .i_clk           (i_clk         ), 
    .i_rst_n         (i_rst_n       ),
	  .i_pc_sel_e      (pc_sel_final  ), 
    .i_btb_valid_e   (btb_valid_e   ),
    .i_is_jump_e     (is_jump_e     ),
    .i_taken_flush   (taken_flush   ),
    .i_stall_d       (stall_d       ), 
    .i_stall_f       (stall_f       ), 
    .i_flush_d       (flush_d       ),
    .i_alu_data_e    (alu_data_e    ),
    // output of fetch stage
    .o_taken_d       (taken_d       ),
    .o_instr_d       (instr_d       ),
    .o_pc_d          (pc_d          ), 
    .o_predicted_pc_d(predicted_pc_d),
    .o_pc_four_d     (pc_four_d     )  
  ); 

  decode_stage DECODE_STAGE(
    // input of decode stage
    .i_clk           (i_clk         ),
    .i_rst_n         (i_rst_n       ),
    .i_rd_wren_w     (rd_wren_w     ),
    .i_taken_d       (taken_d       ), 
    .i_flush_e       (flush_e       ), 
    .i_forward_a_d   (forward_a_d   ), 
    .i_forward_b_d   (forward_b_d   ),
    .i_rd_w          (rd_w          ),
    .i_instr_d       (instr_d       ), 
    .i_pc_d          (pc_d          ), 
    .i_pc_four_d     (pc_four_d     ), 
    .i_predicted_pc_d(predicted_pc_d),
    .i_wb_data_w     (wb_data_w     ), 
    .i_alu_data_m    (alu_data_m    ), 
    // output of decode stage
    .o_insn_vld_e    (insn_vld_e    ),
    .o_rd_wren_e     (rd_wren_e     ), 
    .o_op_a_sel_e    (op_a_sel_e    ),
    .o_op_b_sel_e    (op_b_sel_e    ), 
    .o_mem_wren_e    (mem_wren_e    ), 
	  .o_pc_sel_e		   (pc_sel_e      ),
    .o_taken_e       (taken_e       ),
    .o_btb_valid_e   (btb_valid_e   ),
    .o_is_jump_e     (is_jump_e     ),
    .o_wb_sel_e      (wb_sel_e      ),
    .o_alu_op_e      (alu_op_e      ),
    .o_instr_e       (instr_e       ),
    .o_rs1_e         (rs1_e         ), 
    .o_rs2_e         (rs2_e         ), 
    .o_rd_e          (rd_e          ),
    .o_rd1_e         (rd1_e         ),
    .o_rd2_e         (rd2_e         ), 
    .o_imm_e         (imm_e         ),
    .o_pc_e          (pc_e          ), 
    .o_predicted_pc_e(predicted_pc_e),
    .o_pc_four_e     (pc_four_e     ),
    // Registers content check
		.x1              (x1            ),
    .x2              (x2          	),
    .x3              (x3          	),
    .x4              (x4          	),
    .x5              (x5          	),
    .x6              (x6          	),
    .x7              (x7          	),
    .x8              (x8          	),
    .x9              (x9          	),
    .x10             (x10         	),
    .x11             (x11         	),
    .x12             (x12         	),
    .x13             (x13         	),
    .x14             (x14         	),
    .x15             (x15         	) 
  );

  execute_stage EXECUTE_STAGE(
    // input of execute stage
    .i_clk           (i_clk         ),
    .i_rst_n         (i_rst_n       ),
    .i_rd_wren_e     (rd_wren_e     ),
    .i_op_a_sel_e    (op_a_sel_e    ),
    .i_op_b_sel_e    (op_b_sel_e    ),
    .i_pc_sel_e      (pc_sel_e      ),
    .i_taken_e       (taken_e       ),
    .i_mem_wren_e    (mem_wren_e    ),
    .i_wb_sel_e      (wb_sel_e      ),
    .i_foward_a_e    (forward_a_e   ),
    .i_foward_b_e    (forward_b_e   ),
    .i_funct3        (instr_d[14:12]),
    .i_alu_op_e      (alu_op_e      ),
    .i_instr_e       (instr_e       ),
    .i_rd_e          (rd_e          ),
    .i_rd1_e         (rd1_e         ),
    .i_rd2_e         (rd2_e         ),
    .i_imm_e         (imm_e         ),
    .i_predicted_pc_e(predicted_pc_e),
    .i_pc_e          (pc_e          ),
    .i_pc_four_e     (pc_four_e     ),
    .i_wb_data_w     (wb_data_w     ),
    // output of execute stage
    .o_rd_wren_m     (rd_wren_m     ),
    .o_mem_wren_m    (mem_wren_m    ),
    .o_pc_sel_final  (pc_sel_final  ),
    .o_taken_flush   (taken_flush   ),
    .o_wb_sel_m      (wb_sel_m      ),
    .o_funct3_e      (funct3_e      ),
    .o_rd_m          (rd_m          ),
    .o_pc_four_m     (pc_four_m     ),
    .o_st_data_m     (st_data_m     ),
    .o_alu_data_m    (alu_data_m    ),
    .o_alu_data_e    (alu_data_e    )
  );

  memory_stage MEMORY_STAGE(
    // input of memory stage
    .i_clk       (i_clk         ), 
    .i_fast_clk  (i_clk         ),
    .i_rst_n     (i_rst_n       ), 
    .i_rd_wren_m (rd_wren_m     ), 
    .i_mem_wren_m(mem_wren_m    ), 
    .i_wb_sel_m  (wb_sel_m      ),
    .i_funct3    (instr_d[14:12]),
    .i_rd_m      (rd_m          ),
    .i_io_btn    (i_io_btn      ),    // Input from buttons
    .i_io_sw     (i_io_sw       ),    // Input from switches 
    .i_pc_four_m (pc_four_m     ),
    .i_st_data_m (st_data_m     ), 
    .i_alu_data_m(alu_data_m    ),
    // output of memory stage
    .o_rd_wren_w (rd_wren_w     ),
    .o_wb_sel_w  (wb_sel_w      ),
    .o_rd_w      (rd_w          ), 
    .o_io_hex0   (o_io_hex0     ),    // HEX0 display output
    .o_io_hex1   (o_io_hex1     ),    // HEX1 display output
    .o_io_hex2   (o_io_hex2     ),    // HEX2 display output
    .o_io_hex3   (o_io_hex3     ),    // HEX3 display output
    .o_io_hex4   (o_io_hex4     ),    // HEX4 display output
    .o_io_hex5   (o_io_hex5     ),    // HEX5 display output
    .o_io_hex6   (o_io_hex6     ),    // HEX6 display output
    .o_io_hex7   (o_io_hex7     ),    // HEX7 display output
    .o_pc_four_w (pc_four_w     ), 
    .o_alu_data_w(alu_data_w    ), 
    .o_ld_data_w (ld_data_w     ),
    .o_io_ledg   (o_io_ledg     ),    // Green LEDs output
    .o_io_lcd    (o_io_lcd      ),    // LCD display output
    .o_io_ledr   (o_io_ledr     )     // Red LEDs output
  );

  writeback_stage WRITEBACK_STAGE(
    // input of writeback stage
    .i_wb_sel_w  (wb_sel_w      ),
    .i_pc_four_w (pc_four_w     ), 
    .i_alu_data_w(alu_data_w    ), 
    .i_ld_data_w (ld_data_w     ),
    // output of writeback stage
    .o_wb_data_w (wb_data_w     )
  );

  hazard_unit HAZARD_UNIT(
    // input of hazard unit
    .i_br_sel_e   (pc_sel_final  ), 
    .i_taken_flush(taken_flush   ),
    .i_rd_wren_e  (rd_wren_e     ), 
    .i_rd_wren_m  (rd_wren_m     ), 
    .i_rd_wren_w  (rd_wren_w     ), 
    .i_wb_sel_e   (wb_sel_e      ), 
    .i_rs1_d      (instr_d[19:15]), 
    .i_rs2_d      (instr_d[24:20]), 
    .i_rs1_e      (rs1_e         ), 
    .i_rs2_e      (rs2_e         ), 
    .i_rd_e       (rd_e          ),
    .i_rd_m       (rd_m          ), 
    .i_rd_w       (rd_w          ), 
    // output of hazard unit
    .o_stall_f    (stall_f       ), 
    .o_stall_d    (stall_d       ),
    .o_flush_d    (flush_d       ), 
    .o_flush_e    (flush_e       ), 
    .o_forward_a_d(forward_a_d   ), 
    .o_forward_b_d(forward_b_d   ),
    .o_forward_a_e(forward_a_e   ), 
    .o_forward_b_e(forward_b_e   )
  );

  assign o_pc_debug = pc_four_d ;
  assign o_wb_data  = wb_data_w ;
  assign o_insn_vld = insn_vld_e;

endmodule
