`timescale 1ns/1ps

module INSTRUCTION_FETCH(
	clk,
	rst,
    XF_Beqctr,
    XF_ALUout,
    XF_BranchIns,
    DF_Jumpctr,
    DF_JumpImm,
    XF_Bnectr,

	PC,
	IR
);

input clk, rst, XF_Beqctr,DF_Jumpctr,XF_Bnectr;
input [31:0] XF_ALUout, XF_BranchIns,DF_JumpImm;
output reg 	[31:0] PC, IR;

//instruction memory
reg [31:0] instruction [127:0];

//output instruction
always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
            IR <= 32'd0;
            instruction[ 0] = 32'b000000_00000_00000_00100_00000_100000; 	// add $4, $0, $0	-> r4 ?? counter
            instruction[ 1] = 32'b001000_00000_00001_00000_00000_000001;        // addi $1, $0, 1    -> initial $1 = 1
        //Start
            instruction[ 2] = 32'b100011_00000_00011_00000_00000_000000;     // lw $3 ,0($M0)    -> r3 ?? s0
            instruction[ 3] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 4] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 5] = 32'b001000_00001_00010_00000_00000_000001;        // addi $2, $1, 1    -> initial $2 = 1
            instruction[ 6] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 7] = 32'b000000_00011_00001_01000_00000_100100;     // and $8, $3, $1     -> and $t0, $s0, 1  # t0 determine input is odd | even. ( t0 == 1 -> input is odd, t0 == 0 -> input even )
            instruction[ 8] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 9] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 10] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 11] = 32'b000101_01000_00000_00000_00000_000111;     // bne $8, $0, 7    -> bne $t0, $zero, Start # if input != even, start, else input++
            instruction[ 12] = 32'b000000_00000_00000_00000_00000_100000;    // NOP(add $0, $0, $0)
            instruction[ 13] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 14] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 15] = 32'b001000_00011_00011_00000_00000_000001;    // add $3, $3, $1    -> addi $s0, $s0, 1
            instruction[ 16] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 17] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 18] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //######## start calculate
        //findPrime
            instruction[ 19] = 32'b000101_00100_00000_00000_00000_000111;     // bne $4, $zero, 7 -> bne $t3, $zero, Lookdown
            instruction[ 20] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 21] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 22] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 23] = 32'b000000_00011_00010_00011_00000_100000;     // add $3, $3, $2 -> add $s1, $s1, $s2    # s1 ++, continue find prime number
            instruction[ 24] = 32'b000010_00000_00000_00000_00000_011100;    // j 28 -> j Loopset
            instruction[ 25] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 26] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //Lookdown
            instruction[ 27] = 32'b000000_00011_00010_00011_00000_100010;    // sub $3, $3, $2 -> sub $s1, $s1, $s2    # s1 --, continue find prime number
        //Loopset
            instruction[ 28] = 32'b000000_00000_00001_00101_00000_100000;    // add $5, $0, $1 -> r5 ?? inner loop index   addi $t1, $zero, 1    # t1 is inner loop index
            instruction[ 29] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 30] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 31] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //innerloop
            instruction[ 32] = 32'b000000_00101_00010_00101_00000_100000;    // add $5, $5, $2 -> addi $t1, $t1, 2    # t1++
            instruction[ 33] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 34] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 35] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 36] = 32'b000100_00011_00101_00000_00000_100000;    //  beq $3, $5, Exit -> beq $s1, $t1, Exit1    # when index == s1, s1 is prime number
            instruction[ 37] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 38] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 39] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 40] = 32'b000000_00011_00000_00110_00000_100000;    // add $6, $3, $0 -> r6 ?? temp r3
            instruction[ 41] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 42] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 43] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //modFun
            instruction[ 44] = 32'b000000_00110_00101_00111_00000_101010;    // slt $7, $6, $5 -> # if (temp < inner loop index)
            instruction[ 45] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 46] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 47] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 48] = 32'b000101_00111_00000_00000_00000_001010;    // bne $7, $0, 10 -> bne $t2, $zero, modEnd    # t0 < t1 t2 = 1, end mod
            instruction[ 49] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 50] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 51] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 52] = 32'b000000_00110_00101_00110_00000_100010;    // sub $6, $6, $5 -> sub $t0, $t0, $t1    # t0 - t1
            instruction[ 53] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 54] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 55] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 56] = 32'b000010_00000_00000_00000_00000_101100;    // j 44 -> j modFun
            instruction[ 57] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 58] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //modEnd
            instruction[ 59] = 32'b000100_00110_00000_00000_00000_000110;    //beq $6, $zero, 6-> b F
            instruction[ 60] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 61] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 62] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 63] = 32'b000010_00000_00000_00000_00000_100000;    // j 32 -> j innerloop
            instruction[ 64] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 65] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //F
            instruction[ 66] = 32'b000010_00000_00000_00000_00000_010011;    // j 19 -> j findPrime
            instruction[ 67] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 68] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //Exit
            instruction[ 69] = 32'b000101_00100_00000_00000_00000_001000;    //bne $4, $zero, 8    -> b EndProgram
            instruction[ 70] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 71] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 72] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 73] = 32'b101011_00000_00011_00000_00000_000001;    // sw $3, 1($0)
            instruction[ 74] = 32'b000000_00100_00001_00100_00000_100000;    // add $4, $4, $1 -> count++
            instruction[ 75] = 32'b000010_00000_00000_00000_00000_000010;    // j 2 -> restart
            instruction[ 76] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 77] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
        //EndProgram
            instruction[ 78] = 32'b101011_00000_00011_00000_00000_000010;    // sw $3, 2($0)
            instruction[ 79] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 80] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 81] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
            instruction[ 82] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
          end
	else
		IR <= instruction[PC[10:2]];
end

// output program counter
always @(posedge clk or posedge rst)
begin
	if(rst)
		PC <= 32'd0;
    else if(XF_Beqctr && XF_ALUout==0) //beq
        PC <= PC-8+XF_BranchIns;
    else if(XF_Bnectr && XF_ALUout!=0)//bne
        PC <= PC-8+XF_BranchIns;
    else if(DF_Jumpctr)//jump
        PC <= {PC[31:28],DF_JumpImm[27:0]};
	else if(PC <= 32'd330)//add new PC address here, ex: branch, jump...
		PC <= PC+4;
    else
        PC <= PC;
end

endmodule
