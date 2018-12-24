`timescale 1ns / 1ps

module test(input clk100MHz, input reset, input [3:0] row, output [3:0] col, output [7:0] enable, output [7:0] segment, output speaker, output [5:0] debug);
    wire clk, clk2, clk500, dyn_clk;
    wire key_pressed;
    wire [3:0] keyboard_val;
    divider #(1) div1(clk100MHz, clk);
    divider #(2) div2(clk100MHz, clk2);
    divider #(500) div500(clk100MHz, clk500);
    
    reg [5:0] counthour = 0;
    reg [5:0] countmin = 0;
    reg [5:0] countsec = 0;
    display dis(clk500, reset, counthour, countmin, countsec, enable, segment);

    wire [31:0] freq;
    wire enSong, finish;
    reg constTrue = 1;
    dyndivider dyndiv(clk100MHz, freq, dyn_clk);
    song s(clk2, constTrue, dyn_clk, clk500, speaker, freq, finish);
    keyboard kb(clk100MHz, reset, row, col, keyboard_val, key_pressed);
    
    parameter clockstate  = 6'b000000;
    parameter setsec2     = 6'b000001;   
    parameter setsec1     = 6'b000010; 
    parameter setmin2     = 6'b000100; 
    parameter setmin1     = 6'b001000;  
    parameter sethour2    = 6'b010000;  
    parameter sethour1    = 6'b100000;
    parameter outstate    = 6'b111111;
    
    reg [5:0] current_state = clockstate;
    reg [5:0] next_state = clockstate;
    reg [2:0] hour1 = 0;
    reg [3:0] hour2 = 0;
    reg [2:0] min1 = 0;
    reg [3:0] min2 = 0;
    reg [2:0] sec1 = 0;
    reg [3:0] sec2 = 0;
    reg [31:0] cnt = 0;
    assign debug = current_state;
    
    always @(posedge clk100MHz or posedge reset or posedge key_pressed)
    begin
        if (reset) begin
            counthour <= 0;
            countmin <= 0;
            countsec <= 0;
            next_state <= clockstate;
        end
        else if (key_pressed)
        case(current_state)
            clockstate:
                next_state <= keyboard_val == 4'ha ? sethour1 : clockstate;
            sethour1:
            if(keyboard_val < 3)
                begin
                hour1 <= keyboard_val;
                next_state <= sethour2;
                end
            else
                begin
                next_state <= sethour1;
                end
            sethour2:
            if(hour1 == 2 && keyboard_val > 3)
                begin
                next_state <= sethour2;
                end
            else
                begin
                hour2 <= keyboard_val;
                next_state <= setmin1;
                end
            setmin1:
                if(keyboard_val < 6)
                   begin
                   min1 <= keyboard_val;
                   next_state <= setmin2;
                end
            setmin2: begin
                   min2 <= keyboard_val;
                   next_state <= setsec1;
                   end
            setsec1:
                if(keyboard_val < 6)
                   begin
                   sec1 <= keyboard_val;
                   next_state <= setsec2;
                   end
            setsec2: begin
                   sec2 <= keyboard_val;
                   next_state <= outstate;
                   end
            default:
                next_state <= clockstate;
        endcase
        else begin
            if (current_state == outstate) begin
                counthour <= 10* hour1 + hour2;
                countmin <= 10 * min1 + min2;
                countsec <= 10 * sec1 + sec2;
                current_state <= clockstate;
                next_state <= clockstate;
            end else begin
                cnt <= cnt + 1;
                if (cnt == 100000000) begin
                    countsec <= countsec + 1;
                    cnt <= 0;
                end
                if (countsec == 60) begin
                    countsec <= 0;
                    countmin <= countmin + 1;
                end
                if (countmin == 60) begin
                    countmin <= 0;
                    counthour <= counthour + 1;
                end
                if (counthour == 24) begin
                    counthour <= 0;
                end
                current_state <= next_state;
            end
        end
        end
endmodule
