module controller(input clk, input reset, input enHourAlarm, input enUserAlarm, input [3:0] keyboard_val, input key_pressed,
                    output reg [7:0] blink, output reg [5:0] displayHour, output reg [5:0] displayMin, output reg [5:0] displaySec, output reg enAlarm, output reg alarmType);
    parameter clockState    = 7'b0000000;
    parameter setsec2       = 7'b0000001;   
    parameter setsec1       = 7'b0000010; 
    parameter setmin2       = 7'b0000100; 
    parameter setmin1       = 7'b0001000;  
    parameter sethour2      = 7'b0010000;
    parameter sethour1      = 7'b0100000;
    parameter b_setsec2     = 7'b1000001;   
    parameter b_setsec1     = 7'b1000010; 
    parameter b_setmin2     = 7'b1000100; 
    parameter b_setmin1     = 7'b1001000;  
    parameter b_sethour2    = 7'b1010000;
    parameter b_sethour1    = 7'b1100000;
    parameter b_outState    = 7'b1111111;
    parameter outState      = 7'b0111111;
    parameter setAlarmLen   = 7'b0000111;
    parameter setAlarmLen_2 = 7'b0001111;
    parameter waitState     = 7'b0101010;
    parameter outAlarmLen   = 7'b0011111;
    
    reg [6:0] currentState = clockState;
    reg [6:0] nextState = clockState;
    reg [5:0] countHour = 0, countMin = 0, countSec = 0;
    reg [5:0] alarmHour = 0, alarmMin = 0, alarmSec = 0;
    reg [2:0] hour1 = 0;
    reg [3:0] hour2 = 0;
    reg [2:0] min1 = 0;
    reg [3:0] min2 = 0;
    reg [2:0] sec1 = 0;
    reg [3:0] sec2 = 0;
    reg [31:0] cnt = 0;

    reg settingAlarm = 0;
    reg [31:0] alarmLen = 5; // The initial time of alarm, in seconds.
    reg [31:0] alarmLeft = 0; // The remaining time of alarm, in seconds.

    initial begin
        blink = 8'b00000000; // Blink the digit whose bit is 1.
        displayHour = 0;
        displayMin = 0;
        displaySec = 0;
        enAlarm = 0;
        alarmType = 0; // 0 -> Hour Alarm, 1 -> User Alarm.
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            displayHour <= 0; displayMin <= 0; displaySec <= 0;
            countHour <= 0; countMin <= 0; countSec <= 0;
            alarmHour <= 0; alarmMin <= 0; alarmSec <= 0;
            settingAlarm <= 0; enAlarm <= 0; alarmType <= 0;
            alarmLeft <= 0; alarmLen <= 5;
            blink <= 8'b00000000;
            cnt <= 0;
            nextState <= clockState;
        end else begin
            if (key_pressed) begin
                case(currentState)
                    clockState: begin
                        case (keyboard_val)
                            4'ha: begin
                                hour1 <= countHour / 10; hour2 <= countHour % 10;
                                min1 <= countMin / 10; min2 <= countMin % 10;
                                sec1 <= countSec / 10; sec2 <= countSec % 10;
                                blink <= 8'b10000000;
                                settingAlarm <= 0;
                                nextState <= sethour1;
                            end
                            4'hb: begin
                                hour1 <= alarmHour / 10; hour2 <= alarmHour % 10;
                                min1 <= alarmMin / 10; min2 <= alarmMin % 10;
                                sec1 <= alarmSec / 10; sec2 <= alarmSec % 10;
                                blink <= 8'b10000000;
                                settingAlarm <= 1;
                                nextState <= b_sethour1;
                            end
                            4'hc: begin
                                hour1 <= alarmLen / 100000; hour2 <= alarmLen % 100000 / 10000;
                                min1 <= alarmLen % 10000 / 1000; min2 <= alarmLen % 1000 / 100;
                                sec1 <= alarmLen % 100 / 10; sec2 <= alarmLen % 10;
                                blink <= 8'b00001000;
                                settingAlarm <= 0;
                                nextState <= setAlarmLen;
                            end
                            default: begin
                                blink <= 8'b00000000;
                                settingAlarm <= 0;
                                nextState <= clockState;
                            end
                        endcase
                    end
                    setAlarmLen: begin
                        if (keyboard_val < 6) begin
                            sec1 <= keyboard_val;
                            blink <= 8'b00000100;
                            nextState <= setAlarmLen_2;
                        end else if (keyboard_val == 4'hc) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00000000;
                            nextState <= outAlarmLen;
                        end else begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00001000;
                            nextState <= setAlarmLen;
                        end
                    end
                    setAlarmLen_2: begin
                        if (keyboard_val < 10) begin
                            sec2 <= keyboard_val;
                            blink <= 8'b00000000;
                            nextState <= waitState;
                        end else if (keyboard_val == 4'hc) begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00000000;
                            nextState <= outAlarmLen;
                        end else begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00000100;
                            nextState <= setAlarmLen_2;
                        end
                    end
                    waitState: begin
                        if (keyboard_val == 4'hc)
                            nextState <= outAlarmLen;
                        else
                            nextState <= waitState;
                    end
                    sethour1: begin
                        if(keyboard_val < 3) begin
                            hour1 <= keyboard_val;
                            blink <= 8'b01000000;
                            nextState <= sethour2;
                        end else if (keyboard_val == 4'ha) begin
                            hour1 <= displayHour / 10;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'hf) begin
                            hour1 <= displayHour / 10;
                            blink <= 8'b01000000;
                            nextState <= sethour2;
                        end else begin
                            hour1 <= displayHour / 10;
                            blink <= 8'b10000000;
                            nextState <= sethour1;
                        end
                    end
                    sethour2: begin
                        if(keyboard_val < 4) begin
                            hour2 <= keyboard_val;
                            blink <= 8'b00100000;
                            nextState <= setmin1;
                        end else if (keyboard_val < 10) begin
                            hour2 <= hour1 == 2 ? displayHour % 10 : keyboard_val;
                            blink <= hour1 == 2 ? 8'b01000000 : 8'b00100000;
                            nextState <= hour1 == 2 ? sethour2 : setmin1;
                        end else if (keyboard_val == 4'ha) begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'he) begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b10000000;
                            nextState <= sethour1;
                        end else if (keyboard_val == 4'hf) begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b00100000;
                            nextState <= setmin1;
                        end else begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b01000000;
                            nextState <= sethour2;
                        end
                    end
                    setmin1:
                        if(keyboard_val < 6) begin
                            min1 <= keyboard_val;
                            blink <= 8'b00010000;
                            nextState <= setmin2;
                        end else if (keyboard_val == 4'ha) begin
                            min1 <= displayMin / 10;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'he) begin
                            min1 <= displayMin / 10;
                            blink <= 8'b01000000;
                            nextState <= sethour2;
                        end else if (keyboard_val == 4'hf) begin
                            min1 <= displayMin / 10;
                            blink <= 8'b00001000;
                            nextState <= setmin2;
                        end else begin
                            min1 <= displayMin / 10;
                            blink <= 8'b00100000;
                            nextState <= setmin1;
                        end
                    setmin2:
                        if (keyboard_val < 10) begin
                            min2 <= keyboard_val;
                            blink <= 8'b00001000;
                            nextState <= setsec1;
                        end else if (keyboard_val == 4'ha) begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'he) begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00100000;
                            nextState <= setmin1;
                        end else if (keyboard_val == 4'hf) begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00001000;
                            nextState <= setsec1;
                        end else begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00010000;
                            nextState <= setmin2;
                        end
                    setsec1:
                        if(keyboard_val < 6) begin
                            sec1 <= keyboard_val;
                            blink <= 8'b00000100;
                            nextState <= setsec2;
                        end else if (keyboard_val == 4'ha) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'he) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00010000;
                            nextState <= setmin2;
                        end else if (keyboard_val == 4'hf) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00000100;
                            nextState <= setsec2;
                        end else begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00001000;
                            nextState <= setsec1;
                        end
                    setsec2:
                        if (keyboard_val < 10) begin
                            sec2 <= keyboard_val;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'ha) begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00000000;
                            nextState <= outState;
                        end else if (keyboard_val == 4'he) begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00001000;
                            nextState <= setsec1;
                        end else begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00000100;
                            nextState <= setsec2;
                        end
                    b_sethour1: begin
                        if(keyboard_val < 3) begin
                            hour1 <= keyboard_val;
                            blink <= 8'b01000000;
                            nextState <= b_sethour2;
                        end else if (keyboard_val == 4'hb) begin
                            hour1 <= displayHour / 10;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'hf) begin
                            hour1 <= displayHour / 10;
                            blink <= 8'b01000000;
                            nextState <= b_sethour2;
                        end else begin
                            hour1 <= displayHour / 10;
                            blink <= 8'b10000000;
                            nextState <= b_sethour1;
                        end
                    end
                    b_sethour2: begin
                        if(keyboard_val < 4) begin
                            hour2 <= keyboard_val;
                            blink <= 8'b00100000;
                            nextState <= b_setmin1;
                        end else if (keyboard_val < 10) begin
                            hour2 <= hour1 == 2 ? displayHour % 10 : keyboard_val;
                            blink <= hour1 == 2 ? 8'b01000000 : 8'b00100000;
                            nextState <= hour1 == 2 ? b_sethour2 : b_setmin1;
                        end else if (keyboard_val == 4'hb) begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'he) begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b10000000;
                            nextState <= b_sethour1;
                        end else if (keyboard_val == 4'hf) begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b00100000;
                            nextState <= b_setmin1;
                        end else begin
                            hour2 <= displayHour % 10;
                            blink <= 8'b01000000;
                            nextState <= b_sethour2;
                        end
                    end
                    b_setmin1:
                        if(keyboard_val < 6) begin
                            min1 <= keyboard_val;
                            blink <= 8'b00010000;
                            nextState <= b_setmin2;
                        end else if (keyboard_val == 4'hb) begin
                            min1 <= displayMin / 10;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'he) begin
                            min1 <= displayMin / 10;
                            blink <= 8'b01000000;
                            nextState <= b_sethour2;
                        end else if (keyboard_val == 4'hf) begin
                            min1 <= displayMin / 10;
                            blink <= 8'b00001000;
                            nextState <= b_setmin2;
                        end else begin
                            min1 <= displayMin / 10;
                            blink <= 8'b00100000;
                            nextState <= b_setmin1;
                        end
                    b_setmin2:
                        if (keyboard_val < 10) begin
                            min2 <= keyboard_val;
                            blink <= 8'b00001000;
                            nextState <= b_setsec1;
                        end else if (keyboard_val == 4'hb) begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'he) begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00100000;
                            nextState <= b_setmin1;
                        end else if (keyboard_val == 4'hf) begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00001000;
                            nextState <= b_setsec1;
                        end else begin
                            min2 <= displayMin % 10;
                            blink <= 8'b00010000;
                            nextState <= b_setmin2;
                        end
                    b_setsec1:
                        if(keyboard_val < 6) begin
                            sec1 <= keyboard_val;
                            blink <= 8'b00000100;
                            nextState <= b_setsec2;
                        end else if (keyboard_val == 4'hb) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'he) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00010000;
                            nextState <= b_setmin2;
                        end else if (keyboard_val == 4'hf) begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00000100;
                            nextState <= b_setsec2;
                        end else begin
                            sec1 <= displaySec / 10;
                            blink <= 8'b00001000;
                            nextState <= b_setsec1;
                        end
                    b_setsec2:
                        if (keyboard_val < 10) begin
                            sec2 <= keyboard_val;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'hb) begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00000000;
                            nextState <= b_outState;
                        end else if (keyboard_val == 4'he) begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00001000;
                            nextState <= b_setsec1;
                        end else begin
                            sec2 <= displaySec % 10;
                            blink <= 8'b00000100;
                            nextState <= b_setsec2;
                        end
                    default:
                        nextState <= clockState;
                endcase
            end else begin
                currentState <= nextState; // Only execute when the key is not pressed.
            end

            if (currentState == outState) begin
                countHour <= 10 * hour1 + hour2;
                countMin <= 10 * min1 + min2;
                countSec <= 10 * sec1 + sec2;
                blink <= 8'b00000000;
                cnt <= 0;
                currentState <= clockState;
                nextState <= clockState;
            end else if (currentState == b_outState) begin
                alarmHour <= 10 * hour1 + hour2;
                alarmMin <= 10 * min1 + min2;
                alarmSec <= 10 * sec1 + sec2;
                blink <= 8'b00000000;
                settingAlarm <= 0;
                currentState <= clockState;
                nextState <= clockState;
            end else if (currentState == outAlarmLen) begin
                alarmLen <= sec1 * 10 + sec2;
                currentState <= clockState;
                nextState <= clockState;
            end else if (currentState == clockState) begin
                displayHour <= countHour;
                displayMin <= countMin;
                displaySec <= countSec;
            end else begin
                displayHour <= 10 * hour1 + hour2;
                displayMin <= 10 * min1 + min2;
                displaySec <= 10 * sec1 + sec2;
            end

            cnt <= cnt + 1;
            if (cnt == 100000000) begin
                countSec <= countSec + 1;
                cnt <= 0;
                alarmLeft <= alarmLeft - 1;
                if (alarmLeft == 0) enAlarm <= 0;
            end
            if (countSec == 60) begin
                countSec <= 0;
                countMin <= countMin + 1;
            end
            if (countMin == 60) begin
                countMin <= 0;
                countHour <= countHour + 1;
                alarmLeft <= enHourAlarm ? alarmLen : 0;
                enAlarm <= enHourAlarm ? 1 : 0;
                alarmType <= enHourAlarm ? 0 : alarmType;
            end
            if (countHour == 24) begin
                countHour <= 0;
            end
            if (countSec == alarmSec && countMin == alarmMin && countHour == alarmHour) begin
                alarmLeft <= enUserAlarm ? alarmLen : 0;
                enAlarm <= enUserAlarm ? 1 : 0;
                alarmType <= enUserAlarm ? 1 : alarmType;
            end
        end
    end
endmodule
