module mux_4x1_64bit_tb ();
    reg [1:0] S;
    reg [63:0] A, B, C, D;
    wire [63:0] X;
    
    integer errors = 0;

    task Check;
        input [127:0] expect;
        if (expect[127:64] != expect[63:0]) begin
            $display("Got %d, expected %d", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask

    mux_4x1_64bit UUT (.A(A), .B(B), .C(C), .D(D), .X(X), .S(S));

    initial begin
       #10
       S <= 2'b00; 
       A <= 64'd1; B <= 64'd2; C <= 64'd3; D <= 64'd4;
       
       #10

       $display("Test saida A");
       S <= 2'b00;
       #10
       Check({X, A});
       #10

       $display("Test saida B");
       S = 2'b01;
       #10
       Check({X, B});
       #10

       $display("Test saida C");
       S = 2'b10;
       #10
       Check({X, C});
       #10

       $display("Test saida D");
       S = 2'b11;
       #10
       Check({X, D});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule