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


module test_test(input clk100MHz, output speaker, output debug1, output debug2);

    // reg [0:63] count = 0;
    reg [0:31] freq = 440;
    song song(clk100MHz, freq, speaker, debug1, debug2);
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


