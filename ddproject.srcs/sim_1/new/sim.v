`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 17:11:48
// Design Name: 
// Module Name: sim
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


module sim();
reg clk=0,reset=0;
wire enmin;
wire enhour;
wire enday;
wire[0:5]countsec,countmin,counthour;
second sec(clk,reset,enmin,countsec);
minute min(enmin,reset,enhour,countmin);
hour hr(enhour,reset,enday,counthour);
always@*
begin
    forever
    begin
        #1
        clk=~clk;
    end
    #1
    $finish(0);
end
endmodule
