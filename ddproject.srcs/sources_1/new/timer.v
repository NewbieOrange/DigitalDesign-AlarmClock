module timer(input enHour, input enable, input finish, output reg enSong);
    always @(posedge enHour or posedge finish) begin
        if (enHour && enable) begin
            enSong = 1;
        end else if (finish) begin
            enSong = 0;
        end
    end
endmodule