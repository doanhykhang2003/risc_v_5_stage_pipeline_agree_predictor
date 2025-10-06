module regfile(
  input  logic        i_clk     , 
  input  logic        i_rst     , 
  input  logic        i_rd_wren ,
  input  logic [4:0]  i_rs1_addr, 
  input  logic [4:0]  i_rs2_addr, 
  input  logic [4:0]  i_rd_addr ,
  input  logic [31:0] i_rd_data ,
  output logic [31:0] o_rs1_data, 
  output logic [31:0] o_rs2_data,
  output logic [31:0] x1        ,
  output logic [31:0] x2        ,
  output logic [31:0] x3        ,
  output logic [31:0] x4        ,
  output logic [31:0] x5        ,
  output logic [31:0] x6        ,
  output logic [31:0] x7        ,
  output logic [31:0] x8        ,
  output logic [31:0] x9        ,
  output logic [31:0] x10       ,
  output logic [31:0] x11       ,
  output logic [31:0] x12       ,
  output logic [31:0] x13       ,
  output logic [31:0] x14       ,
  output logic [31:0] x15        
);

  logic [31:0] register [31:0];
  integer i;

  always_ff @(posedge i_clk) begin : register_decoder
    if (!i_rst) begin
      // Reset all registers to zero
      for (i = 0; i < 32; i = i + 1) begin
        register[i] <= 32'b0;
      end
    end else if (i_rd_wren & (i_rd_addr != 5'h00)) begin
      register[i_rd_addr] <= i_rd_data;
    end
  end : register_decoder

  assign o_rs1_data = register[i_rs1_addr];
  assign o_rs2_data = register[i_rs2_addr];

  assign x1  = register[1] ;
  assign x2  = register[2] ;
  assign x3  = register[3] ;
  assign x4  = register[4] ;
  assign x5  = register[5] ;
  assign x6  = register[6] ;
  assign x7  = register[7] ;
  assign x8  = register[8] ;
  assign x9  = register[9] ;
  assign x10 = register[10];
  assign x11 = register[11];
  assign x12 = register[12];
  assign x13 = register[13];
  assign x14 = register[14];
  assign x15 = register[15];

endmodule : regfile
