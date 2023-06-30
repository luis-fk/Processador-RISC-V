module fpu_tb ();
    reg clk, rst;
    reg [31:0] A, B;
    reg [1:0] op;
    reg start;
    wire [31:0] R;
    wire done;

    fpu fpu (.clk(clk), .rst(rst), .A(A), .B(B), .R(R), .op(op), .start(start), .done(done));

    integer errors;

    task Check;
        input [31:0] expect;
        if (expect !== R) begin
            $display("Got %b, expected %b", R, expect);
            errors = errors + 1;
        end
    endtask

    initial begin
        clk = 0;
        rst = 1'b0;
        start = 0;
        errors = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Somas com dois positivos");
        $display("Teste 1");
        /* adicao 24 + 6 = 30 */
        A = 32'b01000001110000000000000000000000; // 24
        B = 32'b01000000110000000000000000000000; // 6
        op = 2'b00;
        #10
        rst = 1'b1;
        #10
        rst = 1'b0;
        start = 1'b1;
        #135
        Check(32'b01000001111100000000000000000000); // 30

        $display("Teste 2");
        /* adicao 1.75 + 1.15 = 2.9 */
        A = 32'b00111111111000000000000000000000; // 1.75
        B = 32'b00111111100100110011001100110011; // 1.15 
        op = 2'b00;
        #10
        rst = 1'b1;
        #10
        rst = 1'b0;
        start = 1'b1;
        #135
        Check(32'b01000000001110011001100110011010); // 2.9

        $display("Teste 3");
        /* adicao 0.75 + 2.25 = 3 */
        A = 32'b0_01111110_10000000000000000000000; // 0.75 
        B = 32'b0_10000000_00100000000000000000000; // 2.25
        op = 2'b00;
        #10
        rst = 1'b1;
        #10
        rst = 1'b0;
        start = 1'b1;
        #135
        Check(32'b01000000010000000000000000000000); // 3

        $display("Teste 4");
        /* adicao 10.75 + 1.15 = 11.9 */
        A = 32'b01000001001011000000000000000000; // 10.75
        B = 32'b00111111100100110011001100110011; // 1.15 
        op = 2'b00;
        #10
        rst = 1'b1;
        #10
        rst = 1'b0;
        start = 1'b1;
        #135
        Check(32'b01000001001111100110011001100110); // 11.9

        $display("Teste 5");
        /* adicao 3.15 + 4.25 = 7.40 */
        A = 32'b0_10000000_10010011001100110011010; // 3.15
        B = 32'b0_10000001_00010000000000000000000; // 4.25
        op = 2'b00;
        #10
        rst = 1'b1;
        #10
        rst = 1'b0;
        start = 1'b1;
        #135
        Check(32'b01000000111011001100110011001101); // 7.40

        $display("Teste 6");
        /* adicao 32000.2 + 1.1 = 32001.3 */
        A = 32'b01000110111110100000000001100110; // 32000.2
        B = 32'b00111111100011001100110011001101; // 1.1
        op = 2'b00;
        #10
        rst = 1'b1;
        #10
        rst = 1'b0;
        start = 1'b1;
        #135
        Check(32'b01000110111110100000001010011001); // aprox 32001.2988281
        #1000

        rst = 1'b1;
        $display("Errors: %d", errors);
        $finish;
    end

endmodule