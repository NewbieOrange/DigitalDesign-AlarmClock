`timescale 1ns / 1ps

module test(input clk100MHz, input reset, input [3:0] row, output [3:0] col, output [7:0] enable, output [7:0] segment, output speaker);
    wire clk, clk2, clk500, dyn_clk, enMin, enHour, enDay;
    wire [0:5] secCount, minCount, hourCount;
    divider #(1) div1(clk100MHz, clk);
    divider #(2) div2(clk100MHz, clk2);
    divider #(500) div500(clk100MHz, clk500);
    second sec(clk, reset, enMin, secCount);
    minute min(enMin, reset, enHour, minCount);
    hour hr(enHour, reset, enDay, hourCount);
    display dis(clk500, reset, hourCount, minCount, secCount, enable, segment);
    // keyboard kb(clk100MHz, reset, row, col, keyboard_val);

    wire [31:0] freq;
    wire enSong, finish;
    reg constTrue = 1;
    dyndivider dyndiv(clk100MHz, freq, dyn_clk);
    timer t(enMin, constTrue, finish, enSong);
    song s(clk2, enSong, dyn_clk, clk500, speaker, freq, finish);
endmodule
