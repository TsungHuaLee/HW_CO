`timescale 1ns/1ps

`include "INSTRUCTION_FETCH.v"
`include "INSTRUCTION_DECODE.v"
`include "EXECUTION.v"
`include "MEMORY.v"

module CPU(
	clk,
	rst,
    input_number,
    output_number1,
    output_number2
);
input clk, rst;
input [12:0] input_number;
output wire [31:0] output_number1,output_number2;
/*============================== Wire  ==============================*/
// INSTRUCTION_FETCH wires
wire [31:0] FD_PC, FD_IR;
// INSTRUCTION_DECODE wires
wire [31:0] A, B;
wire [4:0] DX_RD;
wire [2:0] ALUctr;
wire DX_MemtoReg;
wire DX_MemWrite;
wire DX_RegWrite;
wire [31:0] DX_MD;
wire DX_Beqctr;
wire [31:0] DX_BranchIns;
wire DF_Jumpctr;
wire [31:0] DF_JumpImm;
wire DX_Bnectr;
// EXECUTION wires
wire [31:0] XM_ALUout;
wire [4:0] XM_RD;
wire XM_MemtoReg;
wire XM_MemWrite;
wire XM_RegWrite;
wire [31:0] XM_MD;
wire XF_Beqctr;
wire [31:0] XF_BranchIns;
wire XF_Bnectr;
// DATA_MEMORY wires
wire [31:0] MW_ALUout;
wire [4:0]	MW_RD;
wire MW_RegWrite;

/*============================== INSTRUCTION_FETCH  ==============================*/

INSTRUCTION_FETCH IF(
	.clk(clk),
	.rst(rst),
    .XF_Beqctr(XF_Beqctr),
    .XF_ALUout(XM_ALUout),
    .XF_BranchIns(XF_BranchIns),
    .DF_Jumpctr(DF_Jumpctr),
    .DF_JumpImm(DF_JumpImm),
    .XF_Bnectr(XF_Bnectr),

	.PC(FD_PC),
	.IR(FD_IR)
);

/*============================== INSTRUCTION_DECODE ==============================*/

INSTRUCTION_DECODE ID(
	.clk(clk),
	.rst(rst),
	.PC(FD_PC),
	.IR(FD_IR),
	.MW_RD(MW_RD),
	.MW_ALUout(MW_ALUout),
    .MW_RegWrite(MW_RegWrite),

	.A(A),
	.B(B),
	.RD(DX_RD),
	.ALUctr(ALUctr),
    .DX_MemtoReg(DX_MemtoReg),
    .DX_MemWrite(DX_MemWrite),
    .DX_MD(DX_MD),
    .DX_RegWrite(DX_RegWrite),
    .DX_Beqctr(DX_Beqctr),
    .DX_BranchIns(DX_BranchIns),
    .DF_Jumpctr(DF_Jumpctr),
    .DF_JumpImm(DF_JumpImm),
    .DX_Bnectr(DX_Bnectr)
);

/*==============================     EXECUTION  	==============================*/

EXECUTION EXE(
	.clk(clk),
	.rst(rst),
	.A(A),
	.B(B),
	.DX_RD(DX_RD),
	.ALUctr(ALUctr),
    .DX_MemtoReg(DX_MemtoReg),
    .DX_MemWrite(DX_MemWrite),
    .DX_MD(DX_MD),
    .DX_RegWrite(DX_RegWrite),
    .DX_Beqctr(DX_Beqctr),
    .DX_BranchIns(DX_BranchIns),
    .DX_Bnectr(DX_Bnectr),

    .XF_Bnectr(XF_Bnectr),
    .XF_BranchIns(XF_BranchIns),
    .XF_Beqctr(XF_Beqctr),
    .XM_RegWrite(XM_RegWrite),
    .XM_MD(XM_MD),
    .XM_MemWrite(XM_MemWrite),
    .XM_MemtoReg(XM_MemtoReg),
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD)
);

/*==============================     DATA_MEMORY	==============================*/

MEMORY MEM(
	.clk(clk),
	.rst(rst),
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
    .XM_MemtoReg(XM_MemtoReg),
    .XM_MemWrite(XM_MemWrite),
    .XM_MD(XM_MD),
    .XM_RegWrite(XM_RegWrite),
    .input_number(input_number),

    .MW_RegWrite(MW_RegWrite),
	.MW_ALUout(MW_ALUout),
	.MW_RD(MW_RD),
    .output_number1(output_number1),
    .output_number2(output_number2)
);

endmodule
