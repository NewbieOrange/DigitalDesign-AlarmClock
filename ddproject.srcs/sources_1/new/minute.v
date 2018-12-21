`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 17:32:14
// Design Name: 
// Module Name: minute
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module minute(
input clk,reset,
output reg enhour,
output reg[0:5] count);
initial
begin
    enhour = 0;
    count = 0;
end
always@(posedge clk)
begin
    if(enhour==1)enhour=0;
    if(reset)count=0;
    else count=count+1;
    if(count==60)
    begin
        count=0;
        enhour=1;
    end
end
endmodule
