/*
    Módulo usado para arredondar a mantissa de um
    número de ponto flutuante com representação IEEE 753.
    Sinais: 
        -> mantissa
        -> mantissaRounded: Resultado do arredondamento segundo as expecificações.
        -> notNormalized: HIGH caso seja necessário normalizar o valor novamente.

    Fonte: 
        [1] https://www.youtube.com/watch?v=wbxSTxhTmrs
        [2] https://github.com/chadtopaz/computational-linear-algebra
*/
module rounder (
    input [22:0] mantissa,
    output [22:0] mantissaRounded,
    output notNormalized 
);
    wire [3:0] lastFourBitsMantissa;
    wire lastThreeBitsMantissaEqualToZero;

    /* instanciacao de cada um dos casos do arredondamento 
             Casos   Últimos 4 bits
             < 1/2        0xxx
             > 1/2        1xxx, mas xxx != 000
             = 1/2     (1)1000, quinto bit da mantissa == 1
             = 1/2     (0)1000, quinto bit da mantissa == 0
    */
    wire caseLastBitsLessThanHalf;
    wire caseLastBitsGreaterThanHalf;
    wire caseLastBitsEqualToHalf1;
    wire caseLastBitsEqualToHalf0;
    wire [22:0] mantissaCaseLastBitsLessThanHalf;
    wire [22:0] mantissaCaseLastBitsGreaterThanHalf;
    wire [22:0] mantissaCaseLastBitsEqualToHalf1;
    wire [22:0] mantissaCaseLastBitsEqualToHalf0;

    wire [63:0] resultAlu;
    wire [18:0] mantissa22to4AddedOne;


    assign mantissa22to4AddedOne = resultAlu[18:0];

    Adder64b_mod adder (.A({45'd0, mantissa[22:4]}), .B(64'd1), .SUB(1'b0), .S(resultAlu));

    assign lastFourBitsMantissa = mantissa[3:0];

    /* Sinal de que resultado não está normalizado
       -> Somente no caso que mantissa[22] == 1, mantissaRounded[22] == 0
          e caseLastBitsGreaterThanHalf == 1 or mantissaCaseLastBitsEqualToHalf1 == 1  */
    and (notNormalized, mantissa[22], ~mantissaRounded[22]);

    /* Lógica dos sinais para identificar cada um dos casos citados anteriormente */
    assign caseLastBitsLessThanHalf = ~lastFourBitsMantissa[3];
    nor (lastThreeBitsMantissaEqualToZero, lastFourBitsMantissa[2], lastFourBitsMantissa[1], lastFourBitsMantissa[0]);
    and (caseLastBitsGreaterThanHalf, lastFourBitsMantissa[3], ~lastThreeBitsMantissaEqualToZero);
    and (caseLastBitsEqualToHalf1, mantissa[4], lastFourBitsMantissa[3], lastThreeBitsMantissaEqualToZero);
    and (caseLastBitsEqualToHalf0, ~mantissa[4], lastFourBitsMantissa[3], lastThreeBitsMantissaEqualToZero);
    
    /* Possiveis arredondamentos para cada um dos casos */
    assign mantissaCaseLastBitsLessThanHalf = {mantissa[22:4], 4'b0000};
    assign mantissaCaseLastBitsGreaterThanHalf = {mantissa22to4AddedOne, 4'b0000};
    assign mantissaCaseLastBitsEqualToHalf1 = {mantissa22to4AddedOne, 4'b0000};
    assign mantissaCaseLastBitsEqualToHalf0 = {mantissa[22:4], 4'b0000};

    /* Mux que seleciona o resultado de acordo com o caso corrente de arredondamento */
    mux_4x1_23bit muxSelectRoundedMantissa (.A(mantissaCaseLastBitsLessThanHalf),
                                            .B(mantissaCaseLastBitsGreaterThanHalf),
                                            .C(mantissaCaseLastBitsEqualToHalf1),
                                            .D(mantissaCaseLastBitsEqualToHalf0),
                                            .S({caseLastBitsEqualToHalf0, caseLastBitsEqualToHalf1,
                                                caseLastBitsGreaterThanHalf, caseLastBitsLessThanHalf}),
                                            .X(mantissaRounded));
endmodule