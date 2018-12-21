`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 10:58:46
// Design Name: 
// Module Name: showtime
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


module showtime(output[0:5]hh,mm,ss);
    reg clk=0,reset=0;
    wire enmin;
    wire enhour;
    wire enday;
    wire[0:5]countsec,countmin,counthour;
    second sec(clk,reset,enmin,countsec);
    minute min(enmin,reset,enhour,countmin);
    hour hr(enhour,reset,enday,counthour);
    assign hh=counthour;
    endmodule
