`timescale 1ns / 1ps

module song(input clk,
    input enable, input [31:0] which,
    input clk2,clk5,
    output reg speaker,
    output reg [31:0] freq
    );
    parameter DO=522,RE=586,MI=659,FA=698,SO=784,LA=880,SI=988,DO2=1047,RE2=1172,MI2=1318,DLA=440;
    parameter SI1=494, BMI=1241,LA1=440,SO1=392;
    reg [31:0] freeeeq = 0;
    reg [10:0] stat = 0;
    reg [31:0] count = 0;
    initial
    begin
    speaker = 0;
    stat = 0;
    end

    always @(posedge clk)
    begin

    if(enable)begin
        case (which)
            0:  
                case(stat)
                    0: freeeeq = LA;
                    1: freeeeq = LA;
                    2: freeeeq = MI;
                    3: freeeeq = RE;
                    4: freeeeq = MI;
                    5: freeeeq = MI;
                    6: freeeeq = MI;
                    7: freeeeq = MI;
                    8: freeeeq = RE;
                    9: freeeeq = MI;
                    10: freeeeq = RE;
                    11: freeeeq = DO;
                    12: freeeeq = DO;
                    13: freeeeq = RE;
                    14: freeeeq = RE;
                    15: freeeeq = RE;
                    16: freeeeq = SO;
                    17: freeeeq = SO;
                    18: freeeeq = SO;
                    19: freeeeq = MI;
                    20: freeeeq = SO;
                    21: freeeeq = SO;
                    22: freeeeq = SO;
                    23: freeeeq = MI;
                    24: freeeeq = LA;
                    25: freeeeq = MI;
                    26: freeeeq = MI;
                    27: freeeeq = RE;
                    28: freeeeq = RE;
                    29: freeeeq = MI;
                    30: freeeeq = MI;
                    31: freeeeq = MI;
                    32: freeeeq = LA;
                    33: freeeeq = LA;
                    34: freeeeq = MI;
                    35: freeeeq = RE;
                    36: freeeeq = RE;
                    37: freeeeq = MI;
                    38: freeeeq = MI;
                    39: freeeeq = MI;
                    40: freeeeq = RE;
                    41: freeeeq = MI;
                    42: freeeeq = RE;
                    43: freeeeq = DO;
                    44: freeeeq = DO;
                    45: freeeeq = RE;
                    46: freeeeq = RE;
                    47: freeeeq = RE;
                    48: freeeeq = SO;
                    49: freeeeq = SO;
                    50: freeeeq = MI;
                    51: freeeeq = MI;
                    52: freeeeq = SO;
                    53: freeeeq = SO;
                    54: freeeeq = MI;
                    55: freeeeq = MI;
                    56: freeeeq = SI;
                    57: freeeeq = SO;
                    58: freeeeq = MI;
                    59: freeeeq = MI;
                    60: freeeeq = LA;
                    61: freeeeq = LA;
                    62: freeeeq = LA;
                    63: freeeeq = LA;
                    64: freeeeq = MI;
                    65: freeeeq = LA;
                    66: freeeeq = DO2;
                    67: freeeeq = DO2;
                    68: freeeeq = MI;
                    69: freeeeq = LA;
                    70: freeeeq = DO2;
                    71: freeeeq = DO2;
                    72: freeeeq = SI;
                    73: freeeeq = LA;
                    74: freeeeq = LA;
                    75: freeeeq = SO;
                    76: freeeeq = RE;
                    77: freeeeq = MI;
                    78: freeeeq = MI;
                    79: freeeeq = MI;
                    80: freeeeq = RE;
                    81: freeeeq = RE;
                    82: freeeeq = RE;
                    83: freeeeq = DLA;
                    84: freeeeq = RE;
                    85: freeeeq = MI;
                    86: freeeeq = SO;
                    87: freeeeq = SO;
                    88: freeeeq = MI;
                    89: freeeeq = SI;
                    90: freeeeq = SI;
                    91: freeeeq = SO;
                    92: freeeeq = RE;
                    93: freeeeq = MI;
                    94: freeeeq = MI;
                    95: freeeeq = MI;
                    96: freeeeq = MI;
                    97: freeeeq = LA;
                    98: freeeeq = DO2;
                    99: freeeeq = DO2;
                    100: freeeeq = MI;
                    101: freeeeq = LA;
                    102: freeeeq = DO2;
                    103: freeeeq = DO2;
                    104: freeeeq = MI2;
                    105: freeeeq = MI2;
                    106: freeeeq = RE2;
                    107: freeeeq = DO2;
                    108: freeeeq = DO2;
                    109: freeeeq = RE2;
                    110: freeeeq = RE2;
                    111: freeeeq = RE2;
                    112: freeeeq = MI2;
                    113: freeeeq = MI2;
                    114: freeeeq = RE2;
                    115: freeeeq = DO2;
                    116: freeeeq = RE2;
                    117: freeeeq = RE2;
                    118: freeeeq = DO2;
                    119: freeeeq = SI;
                    120: freeeeq = SO;
                    121: freeeeq = MI;
                    122: freeeeq = SO;
                    123: freeeeq = LA;
                    124: freeeeq = LA;
                    125: freeeeq = LA;
                    126: freeeeq = LA;
                    127: freeeeq = LA;
                endcase
            1:
                case (stat)
                    0: freeeeq = LA1;
                    1: freeeeq = LA1;
                    2: freeeeq = LA1;
                    3: freeeeq = SO1;
                    4: freeeeq = LA1;
                    5: freeeeq = LA1;
                    6: freeeeq = LA1;
                    7: freeeeq = DO;
                    8: freeeeq = DO;
                    9: freeeeq = DO;
                    10: freeeeq = RE;
                    11: freeeeq = DO;
                    12: freeeeq = LA1;
                    13: freeeeq = LA1;
                    14: freeeeq = LA1;
                    15: freeeeq = LA1;
                    16: freeeeq = DO;
                    17: freeeeq = DO;
                    18: freeeeq = DO;
                    19: freeeeq = SO1;
                    20: freeeeq = DO;
                    21: freeeeq = RE;
                    22: freeeeq = MI;
                    23: freeeeq = SO;
                    24: freeeeq = SO;
                    25: freeeeq = MI;
                    26: freeeeq = RE;
                    27: freeeeq = RE;
                    28: freeeeq = MI;
                    29: freeeeq = MI;
                    30: freeeeq = MI;
                    31: freeeeq = MI;
                    32: freeeeq = LA;
                    33: freeeeq = LA;
                    34: freeeeq = LA;
                    35: freeeeq = SO;
                    36: freeeeq = MI;
                    37: freeeeq = MI;
                    38: freeeeq = DO;
                    39: freeeeq = DO;
                    40: freeeeq = LA1;
                    41: freeeeq = LA1;
                    42: freeeeq = LA1;
                    43: freeeeq = MI;
                    44: freeeeq = RE;
                    45: freeeeq = MI;
                    46: freeeeq = RE;
                    47: freeeeq = RE;
                    48: freeeeq = MI;
                    49: freeeeq = MI;
                    50: freeeeq = SO;
                    51: freeeeq = MI;
                    52: freeeeq = RE;
                    53: freeeeq = MI;
                    54: freeeeq = RE;
                    55: freeeeq = DO;
                    56: freeeeq = LA1;
                    57: freeeeq = LA1;
                    58: freeeeq = SO1;
                    59: freeeeq = SO1;
                    60: freeeeq = LA1;
                    61: freeeeq = LA1;
                    62: freeeeq = LA1;
                    63: freeeeq = LA1;
                endcase
        endcase
        stat=stat+1;
        freq=freeeeq;
        case (which)
            0:
                if(stat>127)
                    stat=0;
            1:
                if (stat > 63)
                    stat = 0;
        endcase
    end
    else begin
        stat=0;
    end
    end
    always @(posedge clk5)
    begin
        count=count+1;
        if(count>=500)count=0;
    end
    always @(posedge clk2)
    begin
        if (enable&&count!=0&&count!=250)begin
            speaker <= ~speaker;
        end
    end
endmodule

