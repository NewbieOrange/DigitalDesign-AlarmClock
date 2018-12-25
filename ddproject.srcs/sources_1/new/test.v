`timescale 1ns / 1ps

module test(input clk100MHz, input reset, input [3:0] row, output [3:0] col, output [7:0] enable, output [7:0] segment, output speaker, output [6:0] debug);
    wire clk, clk2, clk500, clk1000, dyn_clk;
    wire [5:0] counthour, countmin, countsec;
    wire key_pressed;
    wire [3:0] keyboard_val;
    divider #(1) div1(clk100MHz, clk);
    divider #(2) div2(clk100MHz, clk2);
    divider #(500) div500(clk100MHz, clk500);
    divider #(1000) div1000(clk100MHz, clk1000);
    display dis(clk1000, reset, counthour, countmin, countsec, enable, segment);

    reg [31:0] which = 1;
    wire [31:0] freq;
    wire enAlarm, finish;
    dyndivider dyndiv(clk100MHz, freq, dyn_clk);
    song s(clk2, enAlarm, which, dyn_clk, clk500, speaker, freq);
    keyboard kb(clk100MHz, reset, row, col, keyboard_val, key_pressed);
    controller ct(clk100MHz, reset, keyboard_val, key_pressed, counthour, countmin, countsec, enAlarm, debug);
endmodule
