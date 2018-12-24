`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 17:36:58
// Design Name: 
// Module Name: hour
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

module hour(
input clk,reset,
output reg enday,
output reg[0:5] count);
initial
begin
    enday = 0;
    count = 0;
end
always@(posedge clk or posedge reset)
begin
    if (reset) 
        count = 0;
    else begin
        if(enday==1)
            enday=0;
        count = count + 1;
        if(count==60) begin
            count=0;
            enday=1;
        end
    end
end
endmodule