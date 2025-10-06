module agree_predictor (
  input  logic         i_clk          ,  // Global system clock
  input  logic         i_rst_n        ,  // Negative edge reset
  input  logic         i_is_jump      ,  // Dectect jump instructions
  input  logic         i_taken_flush  ,  // Misprediction signal
  input  logic         i_actual_taken ,  // True branch decision from EX stage
  input  logic         i_valid_update ,  // Valid update for BTB and PHT
  input  logic         i_is_branch    ,  // Is this instruction a branch?
  input  logic [31:0]  i_pc           ,  // Current i_pc
  input  logic [31:0]  i_actual_target,  // Branch target from execute stage
  output logic [31:0]  o_predicted_pc ,  // Predicted next i_pc
  output logic         o_taken           // 0 = Not Taken, 1 = Taken
);

  logic        misprediction   ;
  logic        hit             ;
  logic        predict_taken   ;
  logic        bias_bit        ;
  logic [7:0]  history_register;
  logic [31:0] btb_predicted_pc;

  // Branch Target Buffer
  btb branch_target_buffer(
    .i_clk				 (i_clk           ),
    .i_rst_n			 (i_rst_n         ),
    .i_is_jump     (i_is_jump       ),
    .i_pc					 (i_pc            ),
    .i_target_pc	 (i_actual_target ),
    .i_is_branch   (i_is_branch     ),
    .i_valid_update(i_valid_update  ),
    .o_predicted_pc(btb_predicted_pc),
    .o_hit         (hit             )
  );

  // Global History Register
  ghr #(.GHR_WIDTH(8)) global_history_register(
    .i_clk         (i_clk           ),
    .i_rst_n       (i_rst_n         ),
    .i_valid_update(i_valid_update  ),
    .i_actual_taken(i_actual_taken  ),
    .o_ghr         (history_register)
  );

  // Bias Bit Table
  bias_table bias_bit_table(
    .i_clk         (i_clk         ),
    .i_rst_n       (i_rst_n       ),
    .i_valid_update(i_valid_update),
    .i_pc          (i_pc          ),
    .i_actual_taken(i_actual_taken),
    .o_bias        (bias_bit      )
  );

  // Pattern History Table With Agree Bias Bit
  pht_agree pattern_history_table(
    .i_clk					(i_clk           ),
    .i_rst_n				(i_rst_n         ),
    .i_is_jump      (i_is_jump       ),
    .i_is_branch    (i_is_branch     ),
    .i_actual_taken (i_actual_taken  ),
    .i_valid_update (i_valid_update  ),
    .i_bias         (bias_bit        ),
    .i_ghr          (history_register),
    .i_pc					  (i_pc            ),
    .o_predict_taken(predict_taken   )            
  );

  // Misprediction mux
  mux2_1 mispredict_mux(
    .a(btb_predicted_pc),
    .b(i_actual_target ),
    .s(misprediction   ),
    .c(o_predicted_pc  )
  );

  assign misprediction = (i_taken_flush & i_is_branch) | i_is_jump;
  assign o_taken       = (hit | misprediction) & predict_taken    ;

endmodule : agree_predictor
