module Memory(input clk,      
                   input mem_read,
                   input mem_write,
                   input [63:0] endereco, //saida da ula
                   input [63:0] write_data, //data out b
                   output [63:0] read_data // write data
                   );
   reg [63:0] endereco_atual;
   reg [7:0] Memory [2047:0];

   /*
    Memoria 64x32
    Neste caso, foi instanciado em bytes, por isso sao 256 posicoes
   */
   initial begin
     /*
      Data Memory
     */
     Memory[0] = 8'd0;
     Memory[1] = 8'd0;
     Memory[2] = 8'd0;
     Memory[3] = 8'd0;
     Memory[4] = 8'd0;
     Memory[5] = 8'd0;
     Memory[6] = 8'd0;
     Memory[7] = 8'd8;
     
     Memory[8] = 8'd0;
     Memory[9] = 8'd0;
     Memory[10] = 8'd0;
     Memory[11] = 8'd0;
     Memory[12] = 8'd0;
     Memory[13] = 8'd0;
     Memory[14] = 8'd0;
     Memory[15] = 8'd6;
     
     Memory[16] = 8'd0;
     Memory[17] = 8'd0;
     Memory[18] = 8'd0;
     Memory[19] = 8'd0;
     Memory[20] = 8'd0;
     Memory[21] = 8'd0;
     Memory[22] = 8'd0;
     Memory[23] = 8'd16;

     Memory[24] = 8'd0;
     Memory[25] = 8'd0;
     Memory[26] = 8'd0;
     Memory[27] = 8'd0;
     Memory[28] = 8'd0;
     Memory[29] = 8'd0;
     Memory[30] = 8'd0;
     Memory[31] = 8'd16;
    
     /* 
      Instruction Memory
      */
      /* teste load da memoria, reg x1 deve valer 8  */
     // ld x1, 0(x0)
     Memory[1026] = 8'b1_0000011;
     Memory[1025] = 8'b0_011_0000;
     Memory[1024] = 8'b0000_0000;
     Memory[1023] = 8'b00000000;
     
      /* teste load da memoria, reg x2 deve valer 6  */
     // ld x2, 8(x0)
     Memory[1030] = 8'b0_0000011;
     Memory[1029] = 8'b0_011_0001;
     Memory[1028] = 8'b1000_0000;
     Memory[1027] = 8'b00000000;

      /* teste soma entre regs, reg x3 deve valer 14  */
     // add x3, x2, x1
     Memory[1034] = 8'b1_0110011;
     Memory[1033] = 8'b1_000_0001;
     Memory[1032] = 8'b0010_0000;
     Memory[1031] = 8'b0000000_0;

     /* teste subtracao entre regs, reg x4 deve valer 6  */
     // sub x4, x3, x1
     Memory[1038] = 8'b0_0110011;
     Memory[1037] = 8'b1_000_0010;
     Memory[1036] = 8'b0001_0001;
     Memory[1035] = 8'b0100000_0;

     /* teste de storage na memoria, posicao 24 da memoria de dados
        deve valer 14  */
     // sw x3, 24(x0)
     Memory[1042] = 8'b0_0100011;
     Memory[1041] = 8'b0_010_1100;
     Memory[1040] = 8'b0011_0000;
     Memory[1039] = 8'b0000000_0;

     /* recupera o valor do storage anterior no registrador 8,
        que deve valer 14 agora  */
     // ld x8, 24(x0)
     Memory[1046] = 8'b0_0000011;
     Memory[1045] = 8'b0_011_0100;
     Memory[1044] = 8'b1000_0000;
     Memory[1043] = 8'b00000001;

     /* Nos testes do tipo B, faz-se as comparacoes desejadas e saltam 8 posicoes
        na memoria */
     // x imm[12|10:5] x4 x2 000 imm[4:1|11] 1100011 BEQ imm = 8
     Memory[1050] = 8'b0_1100011; 
     Memory[1049] = 8'b0_000_0100;
     Memory[1048] = 8'b0100_0001;
     Memory[1047] = 8'b0000000_0;

     // x imm[12|10:5] x1 x0 001 imm[4:1|11] 1100011 BNE imm = 8
     Memory[1058] = 8'b0_1100011;
     Memory[1057] = 8'b0_001_0100;
     Memory[1056] = 8'b0001_0000;
     Memory[1055] = 8'b0000000_0; 
      // imm[12|10:5] x1 x0 100 imm[4:1|11] 1100011 BLT imm = 8
     Memory[1066] = 8'b0_1100011;
     Memory[1065] = 8'b0_100_0100;
     Memory[1064] = 8'b0001_0000;
     Memory[1063] = 8'b0000000_0; 
      // x imm[12|10:5] x0 x1 101 imm[4:1|11] 1100011 BGE imm = 8
     Memory[1074] = 8'b0_1100011;
     Memory[1073] = 8'b1_101_0100;
     Memory[1072] = 8'b0000_0000;
     Memory[1071] = 8'b0000000_0;
      // x imm[12|10:5] x1 x0 110 imm[4:1|11] 1100011 BLTU imm = 8
     Memory[1082] = 8'b0_1100011; 
     Memory[1081] = 8'b0_110_0100;
     Memory[1080] = 8'b0001_0000;
     Memory[1079] = 8'b0000000_0;
      // x imm[12|10:5] x0 x1 111 imm[4:1|11] 1100011 BGEU imm = 8
     Memory[1090] = 8'b0_1100011;  
     Memory[1089] = 8'b1_111_0100; 
     Memory[1088] = 8'b0000_0000;
     Memory[1087] = 8'b0000000_0;
     
     /* Agora, os testes para o tipo J */
     /* com esta instrucao JAL, coloca o PC de 1095 para 1095 + 16
        registrador x5 deve valer 1099 */
     // imm[20|10:1|11|19:12] rd 1101111 JAL rd = x5 imm = 16
     Memory[1098] = 8'b1_1101111;  
     Memory[1097] = 8'b0000_0010; 
     Memory[1096] = 8'b000_0_0000;
     Memory[1095] = 8'b0_0000001;

     /* com esta instrucao do tipo JALR, coloca o PC para x5 (que vale 1099)
        + o immediate (0), ou seja, retorna para 1099
        registrador x5 deve valer 1115 */
     // imm[11:0] rs1 000 rd 1100111 JALR rs1 = x5 rd = x5
     Memory[1114] = 8'b1_1100111;  
     Memory[1113] = 8'b1_000_0010; 
     Memory[1112] = 8'b0000_0010;
     Memory[1111] = 8'b00000000;
    
     /* Testa soma com immediate (negativo para garantir que subi tambem funciona) */
     // imm[11:0] rs1 000 rd 0010011 imm = -2 rd = x6 rs = x3 "SUBI"
     /* reg x6 deve valer x3 - 2 = 12 */
     Memory[1102] = 8'b0_0010011;  
     Memory[1101] = 8'b1_000_0011; 
     Memory[1100] = 8'b1110_0001;
     Memory[1099] = 8'b11111111;

     // imm[31:12] rd 0010111 AUIPC imm -8 rd = x5
     /* este este foi so para verificar se o AUIPC estava funcionando
       com complemento de dois também, então o registrador 5 deve valer -31661
       NAO FAZ SENTIDO EM TERMOS DE MEMORIA, E SO UM TESTE */
      Memory[1106] = 8'b0_0010111;  
      Memory[1105] = 8'b1000_0011; 
      Memory[1104] = 8'b11111111;
      Memory[1103] = 8'b11111111;
      
     /* Da um jump para sair da instrucao 11111, que ja foi setada anteriormente */
      // imm[20|10:1|11|19:12] rd 1101111 JAL rd = x5 imm = 16
      Memory[1110] = 8'b1_1101111;  
      Memory[1109] = 8'b0000_0010; 
      Memory[1108] = 8'b100_0_0000;
      Memory[1107] = 8'b0_0000000;

     /* 
      Testes deluxe: uma nova sessão para instrucoes que nao sao as basicas
      implementadas em sala
      */
      /* 0000000 rs2 rs1 111 rd 0110011 AND rs2 = x5 rs1 = x6 rd = x7 
         realiza and entre x5 e x6, guardando 1025 em x7*/
      Memory[1118] = 8'b1_0110011;  
      Memory[1117] = 8'b1_111_0011; 
      Memory[1116] = 8'b0110_0010;
      Memory[1115] = 8'b0000000_0;

      /* imm[11:0] rs1 111 rd 0010011 ANDI rs1 = x3 rd = x7 
         realiza andi entre x3 e 3, guardando 2 em x7*/
      Memory[1122] = 8'b1_0010011;  
      Memory[1121] = 8'b1_111_0011; 
      Memory[1120] = 8'b0011_0001;
      Memory[1119] = 8'b00000000;

       /* 0000000 rs2 rs1 110 rd 0110011 OR rs2 = x5 rs1 = x6 rd = x7 
         realiza and entre x5 e x6, guardando -31649 em x7*/
      Memory[1126] = 8'b1_0110011;  
      Memory[1125] = 8'b1_110_0011; 
      Memory[1124] = 8'b0110_0010;
      Memory[1123] = 8'b0000000_0;

      /* imm[11:0] rs1 110 rd 0010011 ORI rs1 = x3 rd = x7 
         realiza andi entre x3 e 3, guardando 15 em x7*/
      Memory[1130] = 8'b1_0010011;  
      Memory[1129] = 8'b1_110_0011; 
      Memory[1128] = 8'b0011_0001;
      Memory[1127] = 8'b00000000;
     
   end
   
   assign read_data = {Memory[endereco + 0], Memory[endereco + 1], 
                       Memory[endereco + 2], Memory[endereco + 3],
                       Memory[endereco + 4], Memory[endereco + 5], 
                       Memory[endereco + 6], Memory[endereco + 7]}; 

   // sincrono
   always @(posedge clk) begin        
        if (mem_write == 1) begin
          Memory[endereco + 7] <= write_data[7:0];
          Memory[endereco + 6] <= write_data[15:8];
          Memory[endereco + 5] <= write_data[23:16];
          Memory[endereco + 4] <= write_data[31:24];
          Memory[endereco + 3] <= write_data[39:32];
          Memory[endereco + 2] <= write_data[47:40];
          Memory[endereco + 1] <= write_data[55:48];
          Memory[endereco] <= write_data[63:56];
        end
   end      
endmodule