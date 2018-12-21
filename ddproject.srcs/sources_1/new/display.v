module display(input clk, input reset, input [0:5] hour, input [0:5] min, input [0:5] sec,
				 output reg [7:0] enable, output reg [7:0] segment);
	parameter ZERO = 8'b11000000, ONE = 8'b11111001, TWO = 8'b10100100, THREE = 8'b10110000;
	parameter FOUR = 8'b10011001, FIVE = 8'b10010010, SIX = 8'b10000010;
	parameter SEVEN = 8'b11111000, EIGHT = 8'b10000000, NINE = 8'b10010000;
	parameter SEC_0 = 8'b00000001, SEC_1 = 8'b00000010;
	parameter MIN_0 = 8'b00000100, MIN_1 = 8'b00001000;
	parameter HOUR_0 = 8'b00010000, HOUR_1 = 8'b00100000;
	reg [7:0] reverseEnable;
	reg [0:3] digit; 
	initial begin
	  	enable = 8'b11111111;
	  	reverseEnable = SEC_0;
	  	segment = ZERO;
	end

	always @(posedge clk) begin
		if (reverseEnable == 8'b01000000) begin
			reverseEnable <= 8'b00000001;
		end else begin
			reverseEnable <= reverseEnable << 1;
		end
		case (reverseEnable)
			SEC_0: digit <= sec % 10;
			SEC_1: digit <= sec / 10;
			MIN_0: digit <= min % 10;
			MIN_1: digit <= min / 10;
			HOUR_0: digit <= hour % 10;
			HOUR_1: digit <= hour / 10;
		endcase
		enable <= ~(reverseEnable >> 1);
		case (digit)
			1: segment <= ONE;
			2: segment <= TWO;
			3: segment <= THREE;
			4: segment <= FOUR;
			5: segment <= FIVE;
			6: segment <= SIX;
			7: segment <= SEVEN;
			8: segment <= EIGHT;
			9: segment <= NINE;
			default: segment <= ZERO;
		endcase
		// if (reverseEnable == MIN_1) begin
		// 	segment <= segment & 8'b01111111;
		// end
	end
endmodule
