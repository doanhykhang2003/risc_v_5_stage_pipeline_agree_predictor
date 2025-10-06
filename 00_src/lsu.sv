module lsu(
  // Input Declaration
  input  logic         i_clk     ,
  input  logic         i_fast_clk,
  input  logic         i_rst     ,
  input  logic         i_lsu_wren,
  input  logic [2:0]   i_funct3  ,
  input  logic [3:0]   i_io_btn  ,              // Input from buttons
  input  logic [3:0]   i_io_sw   ,              // Input from sw_data 
  input  logic [31:0]  i_lsu_addr,              // Memory address
  input  logic [31:0]  i_st_data ,              // Write data
  // Output Declaration
  output logic [6:0]   o_io_hex0 ,              // HEX0 display output
  output logic [6:0]   o_io_hex1 ,              // HEX1 display output
  output logic [6:0]   o_io_hex2 ,              // HEX2 display output
  output logic [6:0]   o_io_hex3 ,              // HEX3 display output
  output logic [6:0]   o_io_hex4 ,              // HEX4 display output
  output logic [6:0]   o_io_hex5 ,              // HEX5 display output
  output logic [6:0]   o_io_hex6 ,              // HEX6 display output
  output logic [6:0]   o_io_hex7 ,              // HEX7 display output
  output logic [9:0]   o_io_ledr ,              // Red LEDs output
  output logic [9:0]   o_io_ledg ,              // Green LEDs output
  output logic [31:0]  o_io_lcd  ,              // LCD display output
  output logic [31:0]  o_ld_data                // Read data
);

  // Memory array
  logic        is_data_memory ;
  logic        is_output_peri ;
  logic        is_input_peri  ;
  logic [3:0]  mask_byte      ;
  logic [3:0]  sw_data        ;
  logic [3:0]  btn_data       ;
  logic [3:0]  hex_0_data     ;
  logic [3:0]  hex_1_data     ;
  logic [3:0]  hex_2_data     ;
  logic [3:0]  hex_3_data     ;
  logic [3:0]  hex_4_data     ;
  logic [3:0]  hex_5_data     ;
  logic [3:0]  hex_6_data     ;
  logic [3:0]  hex_7_data     ;
  logic [9:0]  ledg_data      ;
  logic [9:0]  ledr_data      ;
  logic [12:0] lcd_data       ;
  logic [31:0] dmem_load_data ;
  logic [31:0] dmem_store_data;

  // Data Mapping blocks
  always_comb begin : data_mapping
    is_data_memory = (i_lsu_addr >= 32'h00000800 && i_lsu_addr <= 32'h00000FFF); 
    is_output_peri = (i_lsu_addr >= 32'h00001C00 && i_lsu_addr <= 32'h00001C0F);
    is_input_peri  = (i_lsu_addr >= 32'h00001E00 && i_lsu_addr <= 32'h00001E0F);
  end

  //=========================Store_Unit=========================//
  always_comb begin : store_instr_sel
    case(i_funct3)
      3'b000:  dmem_store_data = {{24{i_st_data[7]}} , i_st_data[7:0]} ; // SB
      3'b001:  dmem_store_data = i_st_data                             ; // SW
      3'b010:  dmem_store_data = {{16{i_st_data[15]}}, i_st_data[15:0]}; // SH
      default: dmem_store_data = 32'b0                                 ;
    endcase
  end

  //=========================Data_Memory========================//
  data_memory dmem_block(
    .i_clk           (i_clk                      ), 
    .i_wren          (i_lsu_wren & is_data_memory),
    .i_addr          (i_lsu_addr                 ), 
    .i_st_data       (dmem_store_data            ),
    .o_dmem_load_data(dmem_load_data             )
  );
  
  //=======================Output_Buffer========================//
  always_ff @(posedge i_clk or negedge i_rst) begin : output_buffer
    if (!i_rst) begin
      hex_0_data <= 4'b0 ;
      hex_1_data <= 4'b0 ;
      hex_2_data <= 4'b0 ;
      hex_3_data <= 4'b0 ;
      hex_4_data <= 4'b0 ;
      hex_5_data <= 4'b0 ;
      hex_6_data <= 4'b0 ;
      hex_7_data <= 4'b0 ;
      ledg_data  <= 10'b0;
      lcd_data   <= 12'b0;
      ledr_data  <= 10'b0;
    end else if(is_output_peri & i_lsu_wren) begin
      case(i_lsu_addr)
        32'h00001C00: ledr_data <= i_st_data[9:0];
        32'h00001C04: ledg_data <= i_st_data[9:0];
        32'h00001C08: begin
          hex_0_data <= i_st_data[3:0]  ;
          hex_1_data <= i_st_data[7:4]  ;
          hex_2_data <= i_st_data[11:8] ;
          hex_3_data <= i_st_data[15:12];
        end
        32'h00001C09: begin
          hex_4_data <= i_st_data[3:0]  ;
          hex_5_data <= i_st_data[7:4]  ;
          hex_6_data <= i_st_data[11:8] ;
          hex_7_data <= i_st_data[15:12];
        end
        32'h00001C0C: begin
          lcd_data <= {i_st_data[31], i_st_data[11:0]};
        end
        default: begin
          hex_0_data <= 4'b0 ;
          hex_1_data <= 4'b0 ;
          hex_2_data <= 4'b0 ;
          hex_3_data <= 4'b0 ;
          hex_4_data <= 4'b0 ;
          hex_5_data <= 4'b0 ;
          hex_6_data <= 4'b0 ;
          hex_7_data <= 4'b0 ;
          ledg_data  <= 9'b0 ;
          lcd_data   <= 12'b0;
          ledr_data  <= 10'b0;
        end
      endcase
    end
  end

  assign o_io_ledr = ledr_data ;
  assign o_io_ledg = ledg_data ;
  assign o_io_lcd  = lcd_data  ;
  
  //======================Input_Buffer======================//
  always_ff @(posedge i_clk or negedge i_rst) begin : input_buffer
        if(!i_rst) begin
            sw_data  <= 4'b0   ;
            btn_data <= 4'b0    ;
        end else begin
          case (i_lsu_addr)
            32'h00001E00: sw_data  <= i_io_sw[3:0];
            32'h00001E04: btn_data <= i_io_btn    ;
          endcase
        end
    end

  //===================LSU_MUX_LOAD_DATA====================//
  always_comb begin: lsu_mux_load_data
    if (is_input_peri) begin
      case (i_lsu_addr)
        32'h00001E00: o_ld_data = {28'b0, sw_data [3:0]};
        32'h00001E04: o_ld_data = {28'b0, btn_data[3:0]};
        default:      o_ld_data = 32'b0                 ;
      endcase
    end else if(is_output_peri) begin
      case (i_lsu_addr)
        32'h00001C00: o_ld_data = {22'b0, ledr_data                                     };
        32'h00001C04: o_ld_data = {22'b0, ledg_data                                     };
        32'h00001C08: o_ld_data = {16'b0, hex_3_data, hex_2_data, hex_1_data, hex_0_data};
        32'h00001C09: o_ld_data = {16'b0, hex_7_data, hex_6_data, hex_5_data, hex_4_data};
        32'h00001C0C: o_ld_data = {19'b0, lcd_data                                      };
        default:      o_ld_data = 32'b0                                                  ;
      endcase
    end else if(is_data_memory) begin 
      case (i_funct3)
        3'b000:  o_ld_data  = {{24{dmem_load_data[7]} }, dmem_load_data[7:0] }; // LB
        3'b001:  o_ld_data  = {{16{dmem_load_data[15]}}, dmem_load_data[15:0]}; // LH
        3'b010:  o_ld_data  = dmem_load_data                                  ; // LW
        3'b100:  o_ld_data  = {24'b0                   , dmem_load_data[7:0] }; // LBU
        3'b101:  o_ld_data  = {16'b0                   , dmem_load_data[15:0]}; // LHU
        default: o_ld_data  = 32'b0                                           ; // Default case to avoid latches
      endcase
    end else begin
      o_ld_data  = 32'b0;
    end
  end

  //========================BCD_Converter========================//
  bcd7segment HEX0_CONVERTER(
    .in (hex_0_data),
    .out(o_io_hex0 )
  );

  bcd7segment HEX1_CONVERTER(
    .in (hex_1_data),
    .out(o_io_hex1 )
  );

  bcd7segment HEX2_CONVERTER(
    .in (hex_2_data),
    .out(o_io_hex2 )
  );

  bcd7segment HEX3_CONVERTER(
    .in (hex_3_data),
    .out(o_io_hex3 )
  );

  bcd7segment HEX4_CONVERTER(
    .in (hex_4_data),
    .out(o_io_hex4 )
  );

  bcd7segment HEX5_CONVERTER(
    .in (hex_5_data),
    .out(o_io_hex5 )
  );

  bcd7segment HEX6_CONVERTER(
    .in (hex_6_data),
    .out(o_io_hex6 )
  );

  bcd7segment HEX7_CONVERTER(
    .in (hex_7_data),
    .out(o_io_hex7 )
  );

endmodule : lsu
