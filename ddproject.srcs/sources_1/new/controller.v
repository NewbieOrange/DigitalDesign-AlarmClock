module controller(input clk, input reset, input [3:0] keyboard_val, input key_pressed, output reg [5:0] displayHour, output reg [5:0] displayMin, output reg [5:0] displaySec, output reg enAlarm, output [6:0] debug);
    parameter clockstate  = 7'b0000000;
    parameter setsec2     = 7'b0000001;   
    parameter setsec1     = 7'b0000010; 
    parameter setmin2     = 7'b0000100; 
    parameter setmin1     = 7'b0001000;  
    parameter sethour2    = 7'b0010000;  
    parameter sethour1    = 7'b0100000;
    parameter toggleAlarm = 7'b1111111;
    parameter outstate    = 7'b0111111;
    
    reg [6:0] current_state = clockstate;
    reg [6:0] next_state = clockstate;
    reg [5:0] counthour = 0, countmin = 0, countsec = 0;
    reg [2:0] hour1 = 0;
    reg [3:0] hour2 = 0;
    reg [2:0] min1 = 0;
    reg [3:0] min2 = 0;
    reg [2:0] sec1 = 0;
    reg [3:0] sec2 = 0;
    reg [31:0] cnt = 0;
    assign debug = current_state;

    reg enHourAlarm = 0;
    reg enUserAlarm = 0;
    reg [31:0] alarmLeft = 0;

    initial begin
        displayHour = 0;
        displayMin = 0;
        displaySec = 0;
        enAlarm = 0;
    end
    
    always @(posedge clk or posedge reset or posedge key_pressed) begin
        if (reset) begin
            counthour <= 0;
            countmin <= 0;
            countsec <= 0;
            cnt <= 0;
            next_state <= clockstate;
        end else if (key_pressed)
            case(current_state)
                clockstate: begin
                    case (keyboard_val)
                        4'ha: begin
                            hour1 <= counthour / 10; hour2 <= counthour % 10;
                            min1 <= countmin / 10; min2 <= countmin % 10;
                            sec1 <= countsec / 10; sec2 <= countsec % 10;
                            next_state <= sethour1;
                        end
                        4'hb: begin
                            hour1 <= enHourAlarm; hour2 <= enHourAlarm;
                            min1 <= enHourAlarm; min2 <= enHourAlarm;
                            sec1 <= enHourAlarm; sec2 <= enHourAlarm;
                            next_state <= toggleAlarm;
                        end
                        default: next_state <= clockstate;
                    endcase
                end
                toggleAlarm: begin
                    case (keyboard_val)
                        4'h1: begin
                            enHourAlarm <= 0;
                            next_state <= clockstate;
                        end
                        4'h2: begin
                            enHourAlarm <= 1;
                            next_state <= clockstate;
                        end
                        4'hb: next_state <= clockstate;
                        default: next_state <= toggleAlarm;
                    endcase
                end
                sethour1:
                    if(keyboard_val < 3) begin
                        hour1 <= keyboard_val;
                        next_state <= sethour2;
                    end else if (keyboard_val == 4'ha) begin
                        hour1 <= displayHour / 10;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'hf) begin
                        hour1 <= displayHour / 10;
                        next_state <= sethour2;
                    end else begin
                        hour1 <= displayHour / 10;
                        next_state <= sethour1;
                    end
                sethour2:
                    if(keyboard_val < 4) begin
                        hour2 <= keyboard_val;
                        next_state <= setmin1;
                    end else if (keyboard_val < 10) begin
                        hour2 <= hour1 == 2 ? displayHour % 10 : keyboard_val;
                        next_state <= hour1 == 2 ? sethour2 : setmin1;
                    end else if (keyboard_val == 4'ha) begin
                        hour2 <= displayHour % 10;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'he) begin
                        hour2 <= displayHour % 10;
                        next_state <= sethour1;
                    end else if (keyboard_val == 4'hf) begin
                        hour2 <= displayHour % 10;
                        next_state <= setmin1;
                    end else begin
                        hour2 <= displayHour % 10;
                        next_state <= sethour2;
                    end
                setmin1:
                    if(keyboard_val < 6) begin
                        min1 <= keyboard_val;
                        next_state <= setmin2;
                    end else if (keyboard_val == 4'ha) begin
                        min1 <= displayMin / 10;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'he) begin
                        min1 <= displayMin / 10;
                        next_state <= sethour2;
                    end else if (keyboard_val == 4'hf) begin
                        min1 <= displayMin / 10;
                        next_state <= setmin2;
                    end else begin
                        min1 <= displayMin / 10;
                        next_state <= setmin1;
                    end
                setmin2:
                    if (keyboard_val < 10) begin
                        min2 <= keyboard_val;
                        next_state <= setsec1;
                    end else if (keyboard_val == 4'ha) begin
                        min2 <= displayMin % 10;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'he) begin
                        min2 <= displayMin % 10;
                        next_state <= setmin1;
                    end else if (keyboard_val == 4'hf) begin
                        min2 <= displayMin % 10;
                        next_state <= setsec1;
                    end else begin
                        min2 <= displayMin % 10;
                        next_state <= setmin2;
                    end
                setsec1:
                    if(keyboard_val < 6) begin
                        sec1 <= keyboard_val;
                        next_state <= setsec2;
                    end else if (keyboard_val == 4'ha) begin
                        sec1 <= displaySec / 10;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'he) begin
                        sec1 <= displaySec / 10;
                        next_state <= setmin2;
                    end else if (keyboard_val == 4'hf) begin
                        sec1 <= displaySec / 10;
                        next_state <= setsec2;
                    end else begin
                        sec1 <= displaySec / 10;
                        next_state <= setsec1;
                    end
                setsec2:
                    if (keyboard_val < 10) begin
                        sec2 <= keyboard_val;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'ha) begin
                        sec2 <= displaySec % 10;
                        next_state <= outstate;
                    end else if (keyboard_val == 4'he) begin
                        sec2 <= displaySec % 10;
                        next_state <= setsec1;
                    end else begin
                        sec2 <= displaySec % 10;
                        next_state <= setsec2;
                    end
                default:
                    next_state <= clockstate;
            endcase
        else begin
            if (current_state == outstate) begin
                counthour <= 10 * hour1 + hour2;
                countmin <= 10 * min1 + min2;
                countsec <= 10 * sec1 + sec2;
                cnt <= 0;
                current_state <= clockstate;
                next_state <= clockstate;
            end else if (current_state == clockstate) begin
                displayHour <= counthour;
                displayMin <= countmin;
                displaySec <= countsec;
            end else begin
                displayHour <= 10 * hour1 + hour2;
                displayMin <= 10 * min1 + min2;
                displaySec <= 10 * sec1 + sec2;
            end

            current_state <= next_state;
            cnt <= cnt + 1;
            if (cnt == 100000000) begin
                countsec <= countsec + 1;
                cnt <= 0;
                alarmLeft <= alarmLeft - 1;
                if (alarmLeft == 0) enAlarm <= 0;
            end
            if (countsec == 60) begin
                countsec <= 0;
                countmin <= countmin + 1;
            end
            if (countmin == 60) begin
                countmin <= 0;
                counthour <= counthour + 1;
                alarmLeft <= enHourAlarm ? 5 : 0;
                enAlarm <= enHourAlarm ? 1 : 0;
            end
            if (counthour == 24) begin
                counthour <= 0;
            end
        end
        end
endmodule