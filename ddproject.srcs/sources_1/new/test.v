`timescale 1ns / 1ps

module test(input clk100MHz, input reset, output [7:0] enable, output [7:0] segment);
wire clk, clk500, enMin, enHour, enDay;
wire [0:5] secCount, minCount, hourCount;
divider #(1) div1(clk100MHz, clk);
divider #(500) div500(clk100MHz, clk500);
second sec(clk, reset, enMin, secCount);
minute min(enMin, reset, enHour, minCount);
hour hr(enHour, reset, enDay, hourCount);
display dis(clk500, reset, hourCount, minCount, secCount, enable, segment);
endmodule
