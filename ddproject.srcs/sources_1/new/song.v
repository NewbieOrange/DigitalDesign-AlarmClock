`timescale 1ns / 1ps

module song(input clk, reset, enable, which, clk2, clk5, output reg speaker, output reg [31:0] freq);
    parameter DO=522,RE=586,MI=659,FA=698,SO=784,LA=880,SI=988,DO2=1047,RE2=1172,MI2=1318,DLA=440;
    parameter SI1=494, BMI=1241,LA1=440,SO1=392;

    reg [10:0] stat = 0;
    reg [31:0] count = 0;

    initial begin
        speaker = 0;
        stat = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stat <= 0;
        end else if (enable) begin
            case (which)
                0:  
                    case(stat)
                        0: freq = LA;
                        1: freq = LA;
                        2: freq = MI;
                        3: freq = RE;
                        4: freq = MI;
                        5: freq = MI;
                        6: freq = MI;
                        7: freq = MI;
                        8: freq = RE;
                        9: freq = MI;
                        10: freq = RE;
                        11: freq = DO;
                        12: freq = DO;
                        13: freq = RE;
                        14: freq = RE;
                        15: freq = RE;
                        16: freq = SO;
                        17: freq = SO;
                        18: freq = SO;
                        19: freq = MI;
                        20: freq = SO;
                        21: freq = SO;
                        22: freq = SO;
                        23: freq = MI;
                        24: freq = LA;
                        25: freq = MI;
                        26: freq = MI;
                        27: freq = RE;
                        28: freq = RE;
                        29: freq = MI;
                        30: freq = MI;
                        31: freq = MI;
                        32: freq = LA;
                        33: freq = LA;
                        34: freq = MI;
                        35: freq = RE;
                        36: freq = RE;
                        37: freq = MI;
                        38: freq = MI;
                        39: freq = MI;
                        40: freq = RE;
                        41: freq = MI;
                        42: freq = RE;
                        43: freq = DO;
                        44: freq = DO;
                        45: freq = RE;
                        46: freq = RE;
                        47: freq = RE;
                        48: freq = SO;
                        49: freq = SO;
                        50: freq = MI;
                        51: freq = MI;
                        52: freq = SO;
                        53: freq = SO;
                        54: freq = MI;
                        55: freq = MI;
                        56: freq = SI;
                        57: freq = SO;
                        58: freq = MI;
                        59: freq = MI;
                        60: freq = LA;
                        61: freq = LA;
                        62: freq = LA;
                        63: freq = LA;
                        64: freq = MI;
                        65: freq = LA;
                        66: freq = DO2;
                        67: freq = DO2;
                        68: freq = MI;
                        69: freq = LA;
                        70: freq = DO2;
                        71: freq = DO2;
                        72: freq = SI;
                        73: freq = LA;
                        74: freq = LA;
                        75: freq = SO;
                        76: freq = RE;
                        77: freq = MI;
                        78: freq = MI;
                        79: freq = MI;
                        80: freq = RE;
                        81: freq = RE;
                        82: freq = RE;
                        83: freq = DLA;
                        84: freq = RE;
                        85: freq = MI;
                        86: freq = SO;
                        87: freq = SO;
                        88: freq = MI;
                        89: freq = SI;
                        90: freq = SI;
                        91: freq = SO;
                        92: freq = RE;
                        93: freq = MI;
                        94: freq = MI;
                        95: freq = MI;
                        96: freq = MI;
                        97: freq = LA;
                        98: freq = DO2;
                        99: freq = DO2;
                        100: freq = MI;
                        101: freq = LA;
                        102: freq = DO2;
                        103: freq = DO2;
                        104: freq = MI2;
                        105: freq = MI2;
                        106: freq = RE2;
                        107: freq = DO2;
                        108: freq = DO2;
                        109: freq = RE2;
                        110: freq = RE2;
                        111: freq = RE2;
                        112: freq = MI2;
                        113: freq = MI2;
                        114: freq = RE2;
                        115: freq = DO2;
                        116: freq = RE2;
                        117: freq = RE2;
                        118: freq = DO2;
                        119: freq = SI;
                        120: freq = SO;
                        121: freq = MI;
                        122: freq = SO;
                        123: freq = LA;
                        124: freq = LA;
                        125: freq = LA;
                        126: freq = LA;
                        127: freq = LA;
                    endcase
                1:
                    case (stat)
                        0: freq = LA1;
                        1: freq = LA1;
                        2: freq = LA1;
                        3: freq = SO1;
                        4: freq = LA1;
                        5: freq = LA1;
                        6: freq = LA1;
                        7: freq = DO;
                        8: freq = DO;
                        9: freq = DO;
                        10: freq = RE;
                        11: freq = DO;
                        12: freq = LA1;
                        13: freq = LA1;
                        14: freq = LA1;
                        15: freq = LA1;
                        16: freq = DO;
                        17: freq = DO;
                        18: freq = DO;
                        19: freq = SO1;
                        20: freq = DO;
                        21: freq = RE;
                        22: freq = MI;
                        23: freq = SO;
                        24: freq = SO;
                        25: freq = MI;
                        26: freq = RE;
                        27: freq = RE;
                        28: freq = MI;
                        29: freq = MI;
                        30: freq = MI;
                        31: freq = MI;
                        32: freq = LA;
                        33: freq = LA;
                        34: freq = LA;
                        35: freq = SO;
                        36: freq = MI;
                        37: freq = MI;
                        38: freq = DO;
                        39: freq = DO;
                        40: freq = LA1;
                        41: freq = LA1;
                        42: freq = LA1;
                        43: freq = MI;
                        44: freq = RE;
                        45: freq = MI;
                        46: freq = RE;
                        47: freq = RE;
                        48: freq = MI;
                        49: freq = MI;
                        50: freq = SO;
                        51: freq = MI;
                        52: freq = RE;
                        53: freq = MI;
                        54: freq = RE;
                        55: freq = DO;
                        56: freq = LA1;
                        57: freq = LA1;
                        58: freq = SO1;
                        59: freq = SO1;
                        60: freq = LA1;
                        61: freq = LA1;
                        62: freq = LA1;
                        63: freq = LA1;
                    endcase
                endcase
                stat = stat + 1;
                case (which) // Reset when the song reaches the end.
                    0:
                        if(stat>127)
                            stat=0;
                    1:
                        if (stat > 63)
                            stat = 0;
            endcase
        end else begin
            stat = 0;
        end
    end

    always @(posedge clk5 or posedge reset) begin
        if (reset) count <= 0;
        else begin
            count = count + 1;
            if (count >= 500) count = 0;
        end
    end

    always @(posedge clk2 or posedge reset) begin
        if (reset) speaker <= 0;
        else if (enable && count != 0 && count != 250) begin
            speaker <= ~speaker;
        end
    end
endmodule

