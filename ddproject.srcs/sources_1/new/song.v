`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 12:47:50
// Design Name: 
// Module Name: song
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


module song(input clk100MHz,
    input [0:31] freq,
    output reg speaker
    );
        reg [0:31] counter = 0;
reg [0:31] freeeeq = 0;
    initial
    begin
    speaker = 0;

    // freeeeq = freq;
    freeeeq = 440;
    end

    always @(posedge clk100MHz)
    begin
    // if (freeeeq > 700)
    //     freeeeq <= 400;
    if (counter < 100000000/freeeeq)
        counter <= counter + 1;
    else
        begin
        counter <= 0;
        speaker <= ~speaker;
        // freeeeq <= freeeeq + 2; 
        end
    end

    
endmodule

