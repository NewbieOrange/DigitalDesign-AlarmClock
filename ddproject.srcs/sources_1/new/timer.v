module timer(input enHour, input enable, input finish, output reg enSong);
    always @(posedge enHour or posedge finish)
        if (enHour && enable)
            enSong <= 1;
        else if (finish)
            enSong <= 0;
endmodule
