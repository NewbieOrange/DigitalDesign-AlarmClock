module display(input clk, input reset, input [7:0] blink, input blink_clk, input [5:0] hour, input [5:0] min, input [5:0] sec,
			   output reg [7:0] enable, output reg [7:0] segment);
	// Parameters for digit display from 0 to 9.
	parameter ZERO = 8'b11000000, ONE = 8'b11111001, TWO = 8'b10100100, THREE = 8'b10110000;
	parameter FOUR = 8'b10011001, FIVE = 8'b10010010, SIX = 8'b10000010;
	parameter SEVEN = 8'b11111000, EIGHT = 8'b10000000, NINE = 8'b10010000;

	// Parameters for digit positions.
	parameter SEC_0 = 8'b00000001, SEC_1 = 8'b00000010;
	parameter MIN_0 = 8'b00000100, MIN_1 = 8'b00001000;
	parameter HOUR_0 = 8'b00010000, HOUR_1 = 8'b00100000;
	
	reg [7:0] reverseEnable; // The bit 1 represents which digit to refresh.
	reg [7:0] tempSegment; // The temporary variable for segment. 
	reg [3:0] digit; // The value of current digit.
	
	initial begin
	  	enable = 8'b11111111;
	  	reverseEnable = 8'b10000000;
	  	segment = ZERO;
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			enable <= 8'b11111111;
			reverseEnable <= 8'b10000000;
			segment <= 8'b11111111;
		end else begin
			if (reverseEnable == 8'b10000000) begin
				reverseEnable <= 8'b00000001; // Reach the end of the line, reset.
			end else begin
				reverseEnable <= reverseEnable << 1; // Move to the next digit.
			end
			case (reverseEnable)
				SEC_0: digit <= sec % 10;
				SEC_1: digit <= sec / 10;
				MIN_0: digit <= min % 10;
				MIN_1: digit <= min / 10;
				HOUR_0: digit <= hour % 10;
				HOUR_1: digit <= hour / 10;
			endcase
			enable <= ~(reverseEnable >> 2); // The hardware's enable is reversed.
			case (digit)
				1: tempSegment <= ONE;
				2: tempSegment <= TWO;
				3: tempSegment <= THREE;
				4: tempSegment <= FOUR;
				5: tempSegment <= FIVE;
				6: tempSegment <= SIX;
				7: tempSegment <= SEVEN;
				8: tempSegment <= EIGHT;
				9: tempSegment <= NINE;
				default: tempSegment <= ZERO;
			endcase
			// The following line does: Add the dots for the corresponding digit (01010000)
			//                          and blink i-th digits where blink[i] is 1.
			segment <= tempSegment & (reverseEnable & 8'b01010000 ? 8'b01111111 : 8'b11111111) 
						| ((blink & reverseEnable) && blink_clk ? 8'b01111111 : 8'b00000000);
		end
	end
endmodule
