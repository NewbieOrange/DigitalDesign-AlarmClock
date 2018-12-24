`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/02 11:01:06
// Design Name: 
// Module Name: key_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module keyboard(
  input           clk,
  input           rst,
  input      [3:0] row,
  output reg [3:0] col,
  output reg [0:5] sec,
  output reg [0:5] min,
  output reg [0:5] hour,
  output reg [3:0] keyboard_val   
);

reg [19:0] cnt;                   
wire key_clk;
 
always @ (posedge clk or posedge rst) begin
  if (rst)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;
  if (cnt % 60 == 0) begin
    if (rst)
      sec = 0;
    else begin
      sec = sec + 1;
      if (sec == 60) begin
        sec = 0;
      end
    end
  end
end
    
assign key_clk = cnt[19];                // (2^20/50M = 21)ms 

parameter NO_KEY_PRESSED = 6'b000_001; 
parameter SCAN_COL0      = 6'b000_010;  
parameter SCAN_COL1      = 6'b000_100; 
parameter SCAN_COL2      = 6'b001_000; 
parameter SCAN_COL3      = 6'b010_000;  
parameter KEY_PRESSED    = 6'b100_000; 

reg [5:0] current_state, next_state;   
 
always @ (posedge key_clk or posedge rst)
  if (rst)
    current_state <= NO_KEY_PRESSED;
  else
    current_state <= next_state;
 
always @ (*)
  case (current_state)
    NO_KEY_PRESSED :                 
        if (row != 4'hF)
          next_state = SCAN_COL0;
        else
          next_state = NO_KEY_PRESSED;
    SCAN_COL0 :                    
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL1;
    SCAN_COL1 :                       
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL2;    
    SCAN_COL2 :                
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL3;
    SCAN_COL3 :                      
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;
    KEY_PRESSED :                  
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;                      
  endcase
 
reg       key_pressed_flag;           
reg [3:0] col_val, row_val;          
 
always @ (posedge key_clk or posedge rst)
  if (rst)
  begin
    col              <= 4'h0;
    key_pressed_flag <=    0;
  end
  else
    case (next_state)
      NO_KEY_PRESSED :               
      begin
        col              <= 4'h0;
        key_pressed_flag <=    0;   
      end
      SCAN_COL0 :                      
        col <= 4'b1110;
      SCAN_COL1 :                   
        col <= 4'b1101;
      SCAN_COL2 :                     
        col <= 4'b1011;
      SCAN_COL3 :                      
        col <= 4'b0111;
      KEY_PRESSED :                   
      begin
        col_val          <= col;       
        row_val          <= row;     
        key_pressed_flag <= 1;        
      end
    endcase
 
always @ (posedge key_clk or posedge rst)
  if (rst)
    keyboard_val <= 4'h0;
  else
    if (key_pressed_flag)
      case ({col_val, row_val})
        8'b1110_1110 : keyboard_val <= 4'h1;
        8'b1110_1101 : keyboard_val <= 4'h4;
        8'b1110_1011 : keyboard_val <= 4'h7;
        8'b1110_0111 : keyboard_val <= 4'hE;
         
        8'b1101_1110 : keyboard_val <= 4'h2;
        8'b1101_1101 : keyboard_val <= 4'h5;
        8'b1101_1011 : keyboard_val <= 4'h8;
        8'b1101_0111 : keyboard_val <= 4'h0;
         
        8'b1011_1110 : keyboard_val <= 4'h3;
        8'b1011_1101 : keyboard_val <= 4'h6;
        8'b1011_1011 : keyboard_val <= 4'h9;
        8'b1011_0111 : keyboard_val <= 4'hF;
         
        8'b0111_1110 : keyboard_val <= 4'hA; 
        8'b0111_1101 : keyboard_val <= 4'hB;
        8'b0111_1011 : keyboard_val <= 4'hC;
        8'b0111_0111 : keyboard_val <= 4'hD;        
      endcase

reg [3:0] tempVal;

always @(keyboard_val) begin
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
end
//     vio_0 your_instance_name (
//  .clk(clk),                // input wire clk
//  .probe_out0(seg_out)  // output wire [7 : 0] probe_out0
//);
endmodule