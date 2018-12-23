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
    output reg speaker,
    output reg debug1,debug2
    );
    reg [0:31] counter = 0;
    reg [0:31] freeeeq = 0;
    reg [0:10] stat = 0;
    initial
    begin
    speaker = 0;
    //freq=freeeeq;
    //freeeeq = freq;
    //freeeeq = 440;
    stat = 0;
    end
    always @(posedge clk100MHz)
    begin
    if (counter < 100000000/freeeeq)//8e5
        counter <= counter + 1;
    else
        begin
        counter <= 0;
        speaker <= ~speaker;
        stat <= stat + 1;
        freeeeq <= stat>1000?800:440;
        debug1 = freeeeq==440?1:0;
        debug2 = freeeeq==800?1:0;
        //freeeeq <= freeeeq==440?800:440;
        //if(freeeeq<
        // freeeeq <= freeeeq + 2; 
        end
    //freq=freeeeq;
    end
endmodule

