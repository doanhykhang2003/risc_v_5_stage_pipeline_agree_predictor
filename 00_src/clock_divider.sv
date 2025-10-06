module clock_divider(
  input  logic in,   // input clock signal
  output logic out   // divided clock signal
);
  logic [31 : 0] i = 0; // 25-bit counter to handle counts up to 25,000,000

  initial begin
    out <= 0;
  end

  always @(posedge in) begin
    i <= i + 1;
    if (i == 20 - 1) begin
      out <= ~out; // toggle the output clock
      i   <= 0   ; // reset the counter
    end
  end
endmodule