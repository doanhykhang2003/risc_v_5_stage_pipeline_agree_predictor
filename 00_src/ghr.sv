module ghr #(
  parameter GHR_WIDTH = 8
)(
  input  logic                 i_clk         ,
  input  logic                 i_rst_n       ,
  input  logic                 i_valid_update,
  input  logic                 i_actual_taken,
  output logic [GHR_WIDTH-1:0] o_ghr
);

  logic [GHR_WIDTH-1:0] ghr_reg;

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)
      ghr_reg <= '0;
    else if (i_valid_update)
      ghr_reg <= {ghr_reg[GHR_WIDTH-2:0], i_actual_taken};
  end

  assign o_ghr = ghr_reg;

endmodule
