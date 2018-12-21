module display(input clk, input reset, input [0:5] sec, output reg [5:0] enable, output reg [7:0] segment);
	parameter ZERO = 8'b01000000, ONE = 8'b01111001, TWO = 8'b00100100, THREE = 8'b00110000;
	parameter FOUR = 8'b00011001, FIVE = 8'b00010010, SIX = 8'b00000010;
	parameter SEVEN = 8'b01111000, EIGHT = 8'b00000000, NINE = 8'b00010000;

	initial begin
	  enable = 6'b000001;
	  segment = ZERO;
	end

	always @(*) begin
	  if (enable == 6'b100000)
		enable <= 6'b000001;
	  else begin
		enable <= enable << 1;
	  end
	  segment <= FIVE;
	end
endmodule
