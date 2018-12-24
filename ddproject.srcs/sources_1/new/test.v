`timescale 1ns / 1ps

module test(input clk100MHz, input reset, input [3:0] row, output [3:0] col, output [7:0] enable, output [7:0] segment, output speaker);
    wire clk, clk2, clk500, dyn_clk, enMin, enHour, enDay;
    wire key_pressed;
    wire [0:5] secCount, minCount, hourCount;
    wire [3:0] keyboard_val;
    divider #(1) div1(clk100MHz, clk);
    divider #(2) div2(clk100MHz, clk2);
    divider #(500) div500(clk100MHz, clk500);
    second sec(clk, reset, enMin, secCount);
    minute min(enMin, reset, enHour, minCount);
    hour hr(enHour, reset, enDay, hourCount);
    
    reg [5:0] counthour = 0;
    reg [5:0] countmin = 0;
    reg [5:0] countsec = 0;
    display dis(clk500, reset, counthour, countmin, countsec, enable, segment);

    wire [31:0] freq;
    wire enSong, finish;
    reg constTrue = 1;
    dyndivider dyndiv(clk100MHz, freq, dyn_clk);
    timer t(enMin, constTrue, finish, enSong);
    song s(clk2, enSong, dyn_clk, clk500, speaker, freq, finish);
    keyboard kb(clk100MHz, reset, row, col, keyboard_val, key_pressed);

    
    parameter setsec2     = 6'b000001;   
    parameter setsec1     = 6'b000010; 
    parameter setmin2     = 6'b000100; 
    parameter setmin1     = 6'b001000;  
    parameter sethour2    = 6'b010000;  
    parameter sethour1    = 6'b100000;
    parameter outstate    = 6'b111111;
    
    reg [5:0] current_state;
    reg [5:0] next_state; 
    reg [2:0] hour1;
    reg [3:0] hour2;
    reg [2:0] min1;
    reg [3:0] min2;
    reg [2:0] sec1;
    reg [3:0] sec2;
    
    always@(posedge clk100MHz, posedge reset)
      if (reset)
        begin
        hour1 <= 3'b000;
        min1 <= 3'b000;
        sec1 <= 3'b000;
        hour2 <= 4'b0000;
        min2 <= 4'b0000;
        sec2 <= 3'b0000;
        current_state <= sethour1;
        next_state <= sethour1;
        end
      else
        current_state <= next_state;
    
    always @(posedge key_pressed)
    begin
        case(current_state)
            sethour1:
            if(keyboard_val < 3'b111)
                begin
                hour1 <= keyboard_val;
                next_state <= sethour2;
                end
            else
                begin
                next_state <= sethour1;
                end
            sethour2:
            if(hour1 == 6 && keyboard_val > 0)
                begin
                next_state <= sethour2;
                end
            else if (hour1 < 6)
                begin
                hour2 <= keyboard_val;
                next_state <= setmin1;
                end
            setmin1:
                if(keyboard_val < 7)
                   begin
                   min1 = keyboard_val;
                   next_state <= setmin2;
                end
            setmin2:
                if(min1 == 6 && keyboard_val > 0)
                   begin
                   next_state <= setmin2;
                   end
                else if (min1 < 6)
                   begin
                   min2 <= keyboard_val;
                   next_state <= setsec1;
                   end   
            setsec1:
                if(keyboard_val < 7)
                   begin
                   sec1 = keyboard_val;
                   next_state <= setsec2;
                   end
            setsec2:
                 if(sec1 == 6 && keyboard_val > 0)
                   begin
                   next_state <= setsec1;
                   end
                 else if (sec1 < 6)
                   begin
                   sec2 <= keyboard_val;
                   next_state <= outstate;
                 end 
            default:
                next_state <= 6'b000000;                
        endcase
        end
    
    always@(current_state)
            if(current_state == outstate)
                begin
                    counthour = 10* hour1 + hour2;
                    countmin = 10 * min1 + min2;
                    countsec = 10 * sec1 + sec2;
                end
endmodule
