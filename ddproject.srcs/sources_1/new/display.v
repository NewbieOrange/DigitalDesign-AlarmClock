module display(clk,reset_n,select,segment,clk_slow);
	input clk;
	input reset_n;
	output	wire 	[5:0] 	select;
	output 	reg	[7:0] 	segment;
	output clk_slow;
	
	reg	[16:0]	counter;
	reg	clk_slow;
	reg	[5:0] 	temp_select;
	
	//计数模块
	always @(posedge clk or negedge reset_n)
	begin
		if (!reset_n)
			counter <= 0;
		else 
			counter <= counter + 16'b1;
	end 
	
	//分频模块
	always @(posedge clk)
	begin 
		clk_slow <=	counter[12];
	end
	
	//分配单个数码管上的显示模式
	//assign segment = 8'b11111001;
	always @(*)//posedge select
		begin 
			if(!reset_n)
				segment <= 8'b11111111;
			else 
				begin 
					case(temp_select)
					6'b000_001:segment <= 8'b1111_1001;
					6'b000_010:segment <= 8'b1010_0100;
					6'b000_100:segment <= 8'b1011_0000;
					6'b001_000:segment <= 8'b1001_1001;
					6'b010_000:segment <= 8'b1001_0010;
					6'b100_000:segment <= 8'b1000_0010;
					default:   segment <= 8'b1111_0000;
					endcase 
				end
		end
		
	//扫描
	always @(posedge clk_slow or negedge reset_n)
	begin		
		if (!reset_n)
				temp_select <= 0;
		else if(temp_select == 6'b000_000)
				temp_select <= 6'b000_001;
		else if(temp_select == 6'b100_000)
				temp_select <= 6'b000_001;
		else 
				temp_select <= temp_select<<1;
	end 
	assign select = ~temp_select;
endmodule
