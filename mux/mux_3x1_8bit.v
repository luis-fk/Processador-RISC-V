module mux_3x1_8bit (
    input [1:0] S,
    input [7:0] A, B, C,
    output reg [7:0] X
);

always @ (*) 
    begin
        if (S == 2'b00)
            X <= A;
        else if (S == 2'b01)
            X <= B;
        else if (S == 2'b10)
            X <= C;
    end
endmodule