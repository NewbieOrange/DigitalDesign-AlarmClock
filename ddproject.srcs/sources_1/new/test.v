`timescale 1ns / 1ps

module test(input clk100MHz, output led);
div1Hz div(clk100MHz, led);
endmodule
