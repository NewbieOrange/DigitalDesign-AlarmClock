`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 12:25:12
// Design Name: 
// Module Name: test_test
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


module test_test(input clk100MHz, input enable, output speaker, output debug1, output debug2);

    // reg [0:63] count = 0;
    wire clk1, clk2, clk5;
    wire [31:0] hz;
    dyndivider div2(clk100MHz, hz, clk2);
    divider #(2) div1(clk100MHz, clk1);
    divider #(500) div5(clk100MHz, clk5);
    song song(clk1, enable, clk2, clk5, speaker, debug1, debug2, hz);
    // initial
    // begin
    // end

    // always @(posedge clk100MHz)
    // begin
    // if (count < 100000000)
    //     count <= count + 1;
    // else
    //     begin
    //     count <= 0;
    //     freq <= freq + 1;
    //     end
    // end
endmodule


