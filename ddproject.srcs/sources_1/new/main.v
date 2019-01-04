`timescale 1ns / 1ps

module main(input clk100MHz, input reset, input enHourAlarm, input enUserAlarm, input [3:0] row,
            output [3:0] col, output [7:0] enable, output [7:0] segment, output speaker);
    wire clk, clk2, clk1000, dyn_clk; // clk -> 1Hz, clk2 -> 2Hz, clk1000 -> 1000Hz, dyn_clk -> Dynamic Clock.
    divider #(1) div1(clk100MHz, clk); // 1 Hz divider.
    divider #(2) div2(clk100MHz, clk2); // 2 Hz divider.
    divider #(1000) div1000(clk100MHz, clk1000); // 1000 Hz divider.

    wire [5:0] countHour, countMin, countSec; // Current hour, minute and second.
    wire [7:0] blink; // Which digit to blink, bit 1 -> blink.
    display dis(clk1000, reset, blink, clk2, countHour, countMin, countSec, enable, segment);

    wire [31:0] freq; // The frequency for dynamic divider.
    wire enAlarm, alarmType; // The enable for alarm and the type of alarm.
    dyndivider dyndiv(clk100MHz, freq, dyn_clk); // The dynamic divider.
    song alarm(clk2, reset, enAlarm, alarmType, dyn_clk, clk1000, speaker, freq);

    wire key_pressed; // 1 when the keyboard is pressed.
    wire [3:0] keyboard_val; // The value of pressed key.
    keyboard kb(clk100MHz, reset, row, col, keyboard_val, key_pressed);
    controller ct(clk100MHz, reset, enHourAlarm, enUserAlarm, keyboard_val, key_pressed, blink,
                  countHour, countMin, countSec, enAlarm, alarmType);
endmodule
