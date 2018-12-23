`timescale 1ns / 1ps

module test(input clk100MHz, input reset, input [3:0] row, output [3:0] col, output [7:0] enable, output [7:0] segment, output [3:0] debug);
    wire clk, clk500, enMin, enHour, enDay;
    reg [0:5] newSec = 6'b000000, newMin = 6'b000000, newHour = 6'b000000;
    wire [0:5] secCount, minCount, hourCount;
    wire [3:0] keyboard_val;
    divider #(1) div1(clk100MHz, clk);
    divider #(500) div500(clk100MHz, clk500);
    second sec(clk, reset, enMin, secCount);
    minute min(enMin, reset, enHour, minCount);
    hour hr(enHour, reset, newHour, enDay, hourCount);
    display dis(clk500, reset, hourCount, minCount, secCount, enable, segment);
    keyboard kb(clk100MHz, reset, row, col, keyboard_val);

    reg state = 0; // 0 -> Clock, 1 -> Set time
    reg [5:0] setPosition = 6'b000000;
    reg [3:0] tempVal;

    assign debug = keyboard_val;

    always @(keyboard_val) begin
        if (state == 0) begin
            state <= 1;
            setPosition <= 6'b100000;
        end else if (state == 1) begin
            if (setPosition == 6'b000000) begin
                state <= 0;
            end else begin
                case (keyboard_val)
                    4'h0: tempVal <= 0;
                    4'h1: tempVal <= 1;
                    4'h2: tempVal <= 2;
                    4'h3: tempVal <= 3;
                    4'h4: tempVal <= 4;
                    4'h5: tempVal <= 5;
                    4'h6: tempVal <= 6;  
                    4'h7: tempVal <= 7;
                    4'h8: tempVal <= 8;
                    4'h9: tempVal <= 9;
                endcase
                case (setPosition)
                    6'b100000: newHour <= tempVal * 10 + hourCount % 10;
                    6'b010000: newHour <= hourCount - hourCount % 10 + tempVal;
                    // 6'b001000: tempMin = tempVal * 10 + minCount % 10;
                    // 6'b000100: tempMin = minCount - minCount % 10 + tempVal;
                    // 6'b000010: tempSec = tempVal * 10 + secCount % 10;
                    // 6'b000001: tempSec = secCount - secCount % 10 + tempVal;
                endcase
                setPosition <= setPosition >> 1;
            end
        end
    end
endmodule
