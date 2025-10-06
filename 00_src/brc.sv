module brc (
  input  logic [31:0] i_rs1_data,   // Data from the first register
  input  logic [31:0] i_rs2_data,   // Data from the second register
  input  logic        i_br_un   ,   // Comparison mode: 1 if unsigned, 0 if signed
  output logic        o_br_less ,   // Output is 1 if rs1 < rs2
  output logic        o_br_equal    // Output is 1 if rs1 == rs2
);

  always_comb begin
    // Kiểm tra bằng nhau
    o_br_equal = (i_rs1_data == i_rs2_data);

    // Kiểm tra nhỏ hơn
    if (i_br_un) begin
      // So sánh kiểu UNSIGNED
      o_br_less = (i_rs1_data < i_rs2_data);
    end else begin
      // So sánh kiểu SIGNED
      o_br_less = ($signed(i_rs1_data) < $signed(i_rs2_data));
    end
  end

endmodule
