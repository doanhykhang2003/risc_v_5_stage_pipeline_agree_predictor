`timescale 1ps/1ps

module pipeline_agree_predictor_tb;

  // Inputs
  logic        i_clk   ; 
  logic        i_rst_n ;
  logic [3:0]  i_io_btn;
  logic [3:0]  i_io_sw ;

  // Outputs
  logic        o_insn_vld;
  logic [6:0]  o_io_hex0 ;
  logic [6:0]  o_io_hex1 ;
  logic [6:0]  o_io_hex2 ;
  logic [6:0]  o_io_hex3 ;
  logic [6:0]  o_io_hex4 ;
  logic [6:0]  o_io_hex5 ;
  logic [6:0]  o_io_hex6 ;
  logic [6:0]  o_io_hex7 ;              	
  logic [9:0]  o_io_ledg ; 
  logic [9:0]  o_io_ledr ; 
  logic [31:0] o_pc_debug; 
  logic [31:0] o_wb_data ;
  logic [31:0] o_io_lcd  ;
  logic [31:0] x1        ;
  logic [31:0] x2        ;
  logic [31:0] x3        ;
  logic [31:0] x4        ;
  logic [31:0] x5        ;
  logic [31:0] x6        ;
  logic [31:0] x7        ;
  logic [31:0] x8        ;
  logic [31:0] x9        ;
  logic [31:0] x10       ;
  logic [31:0] x11       ;
  logic [31:0] x12       ;
  logic [31:0] x13       ;
  logic [31:0] x14       ;
  logic [31:0] x15       ;  

  // Instantiate the singlecycle module
  pipeline_agree_predictor dut (
    // Input of dut
    .i_clk     (i_clk     ),
    .i_rst_n   (i_rst_n   ),
    .i_io_sw   (i_io_sw   ),
    .i_io_btn  (i_io_btn  ),
    // Output of dut
    .o_insn_vld(o_insn_vld),
    .o_pc_debug(o_pc_debug),
    .o_wb_data (o_wb_data ),
    .o_io_lcd  (o_io_lcd  ),
    .o_io_ledg (o_io_ledg ),
    .o_io_ledr (o_io_ledr ),
    .o_io_hex0 (o_io_hex0 ),				
		.o_io_hex1 (o_io_hex1 ),       
  	.o_io_hex2 (o_io_hex2 ),        
		.o_io_hex3 (o_io_hex3 ),        
		.o_io_hex4 (o_io_hex4 ),       
		.o_io_hex5 (o_io_hex5 ),        
		.o_io_hex6 (o_io_hex6 ),       
		.o_io_hex7 (o_io_hex7 ),
    // Registers content check
    .x1        (x1        ),
    .x2        (x2        ),
    .x3        (x3        ),
    .x4        (x4        ),
    .x5        (x5        ),
    .x6        (x6        ),
    .x7        (x7        ),
    .x8        (x8        ),
    .x9        (x9        ),
    .x10       (x10       ),
    .x11       (x11       ),
    .x12       (x12       ),
    .x13       (x13       ),
    .x14       (x14       ),
    .x15       (x15       ) 
  );

  // Clock generation: 10ns period (5ns high, 5ns low)
  always #1 i_clk = ~i_clk;

  // Testbench stimulus
  initial begin
    // Initialize inputs
           i_clk    = 0           ;
           i_rst_n  = 0           ;
           i_io_sw  = 32'h00000000;
           i_io_btn = 32'h00000001;

    // //===============HEX_TO_DEC================//
    // // Testcase 1: input_hex_data = 32'hff
    // #40    i_rst_n  = 1           ;
    // #50    i_io_sw  = 32'hff      ;

    // #100   i_io_btn = 0           ;

    // #80000 i_rst_n  = 0           ;
    //        i_io_btn = 1           ;

    // // Testcase 2: input_hex_data = 32'h7E
    // #500   i_rst_n  = 1           ;
    // #50    i_io_sw  = 32'h7E      ;

    // #100   i_io_btn = 0           ;

    // ===============STOP_WATCH================//
    #40    i_rst_n  = 1           ;
           i_io_sw  = 32'd1       ;

    #50000  i_io_sw  = 32'd0      ;

    #50000  i_io_sw  = 32'd1      ;

    #80000 i_rst_n  = 0           ;
           i_io_btn = 1           ;  

    // //===============Manual_Test================//
    // #40       i_rst_n = 1            ;
    // #5000     i_rst_n = 0            ;
    
    $stop;
  end

  // Monitor output signals (optional)
  initial begin
    $monitor("Time: %0t | PC: %h | WB Data: %h", $time, o_pc_debug, o_wb_data);
  end

endmodule : pipeline_agree_predictor_tb
