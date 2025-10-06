module bcd7segment(
	// Input Declaration
	input  logic [3:0] in,
	// Output Declaration
	output logic [6:0] out
);
	
	always_comb begin : bcd_data_decoder	
	  case(in)	
			4'b0000: out = 7'b1000000;	//when bcd = 0
			4'b0001: out = 7'b1111001;	//when bcd = 1
			4'b0010: out = 7'b0100100;	//when bcd = 2
			4'b0011: out = 7'b0110000;	//when bcd = 3
			4'b0100: out = 7'b0011001;	//when bcd = 4
			4'b0101: out = 7'b0010010;	//when bcd = 5
			4'b0110: out = 7'b0000010;	//when bcd = 6
			4'b0111: out = 7'b1111000;	//when bcd = 7
			4'b1000: out = 7'b0000000;	//when bcd = 8
			4'b1001: out = 7'b0010000;	//when bcd = 9
			4'b1010: out = 7'b0001000;	//when bcd = A
			4'b1011: out = 7'b0000011;	//when bcd = B
			4'b1100: out = 7'b1000110;	//when bcd = C
			4'b1101: out = 7'b0100001;	//when bcd = D
			4'b1110: out = 7'b0000110;	//when bcd = E
			4'b1111: out = 7'b0001110;	//when bcd = F
	  	default: out = 7'b1111111;	//any other value
	  endcase
	end : bcd_data_decoder

endmodule
