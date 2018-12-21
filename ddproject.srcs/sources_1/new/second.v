`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 17:00:48
// Design Name: 
// Module Name: second
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


module second(
input clk,reset,
output reg enmin,
output reg[0:5] count);
initial
begin
    enmin = 0;
    count = 0;
end
always@(posedge clk)
begin
    if(enmin==1)enmin=0;
    if(reset)count=0;
    else count=count+1;
    if(count==60)
    begin
        count=0;
        enmin=1;
    end
end
endmodule
