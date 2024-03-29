`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	DX_MemtoReg,
	DX_RegWrite,
	DX_MemRead,
	DX_MemWrite,
	DX_branch,
	ALUctr,
	NPC,
	A,
	B,
	imm,
	DX_RD,
	DX_MD,

	JT,
	DX_PC,
	DX_jump,

	XM_MemtoReg,
	XM_RegWrite,
	XM_MemRead,
	XM_MemWrite,
	XM_branch,
	ALUout,
	XM_RD,
	XM_MD,
	XM_BT
);

input clk, rst, DX_MemtoReg, DX_RegWrite, DX_MemRead, DX_MemWrite, DX_branch, DX_jump;
input [3:0] ALUctr;
input [31:0]JT, DX_PC, NPC, A, B;
input [15:0]imm;
input [4:0] DX_RD;
input [31:0] DX_MD;

output reg XM_MemtoReg, XM_RegWrite, XM_MemRead, XM_MemWrite, XM_branch;
output reg [31:0]ALUout, XM_BT;
output reg [4:0] XM_RD;
output reg [31:0] XM_MD;

//set pipeline register
always @(posedge clk or posedge rst)
begin
	if(rst) begin //初始化
		XM_MemtoReg	<= 1'b0;
		XM_RegWrite	<= 1'b0;
		XM_MemRead 	<= 1'b0;
		XM_MemWrite	<= 1'b0;
		XM_RD 	   	<= 5'b0;
		XM_MD 	   	<= 32'b0;
		XM_branch	<= 1'b0;
		XM_BT		<= 32'b0;
	end else begin
		XM_MemtoReg	<= DX_MemtoReg;
		XM_RegWrite	<= DX_RegWrite;
		XM_MemRead 	<= DX_MemRead;
		XM_MemWrite	<= DX_MemWrite;
		XM_RD 	   	<= DX_RD;
		XM_MD 	   	<= DX_MD;
	    XM_branch	<= ((ALUctr==7) && (A == B) && (DX_branch))? 1'b1: ((ALUctr==8) && (A != B) && (DX_branch))?1'b1:1'b0;
		XM_BT		<= NPC+{ { 15{imm[15]}}, imm, 2'b0};  //Branch Target = 當前的PC值 + 相對位址 (EX. beq指令)
		//beq指令在"execution"中所需要的設定其實大多都完成了，各位可以參閱上方兩行指令。但下方ALUout還是記得要給個值，例如：0
	end
end

always @(posedge clk or posedge rst)
begin
   if(rst) begin
   		ALUout <= 32'b0;
   end else begin
   		case(ALUctr)
		  	4'd0: //add / lw ...  //在ID階段時已經解碼出指令了，那該指令需要哪一種運算?
		     	ALUout 	<= A + B;
			4'd1: //sub
				ALUout 	<= A - B;
			4'd2: //and
				ALUout 	<= A & B;
			4'd3: //or
				ALUout 	<= A | B;
			4'd4: //slt
				ALUout 	<= (A < B)?1:0;
			// I type
			4'd5: //lw
				ALUout 	<= A + B;
			4'd6: //sw
				ALUout 	<= A + B;
			4'd7: //beq
				ALUout 	<= 32'd0;
			4'd8: //bne
				ALUout 	<= 32'd0;
			// J type
			4'd9: //j
				ALUout 	<= 32'd0;
		endcase
   end
end


endmodule
