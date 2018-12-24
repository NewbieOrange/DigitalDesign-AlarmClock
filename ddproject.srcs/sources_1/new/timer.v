module timer(input enHour, input enable, output reg enSong);
    always @(posedge enHour) begin
        if (enable) begin
            enSong = 1;
        end
    end
endmodule