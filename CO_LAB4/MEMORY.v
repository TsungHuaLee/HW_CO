`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout,
	XM_RD,
    XM_MemtoReg,
    XM_MemWrite,
    XM_MD,
    XM_RegWrite,
    input_number,

    MW_RegWrite,
	MW_ALUout,
	MW_RD,
    output_number1,
    output_number2
);
input clk, rst;
input [31:0] ALUout,XM_MD;
input [4:0] XM_RD;
input XM_MemtoReg,XM_MemWrite,XM_RegWrite;
input [12:0] input_number;

output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;
output reg MW_RegWrite;
output reg [31:0] output_number1,output_number2;

//data memory
reg [31:0] DM [0:127];

//always store word to data memory
always @(posedge clk)
begin
  	DM[0] <= {{19{0}},input_number};
  	output_number1 <= DM[1];
  	output_number2 <= DM[2];
  	if(XM_MemWrite)
    	DM[ALUout[6:0]] <= XM_MD;
end

//send to Dst REG: "load word from data memory" or  "ALUout"
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  MW_ALUout	<=	32'b0;
	  MW_RD		<=	5'b0;
      MW_RegWrite <= 1'd0;
	end
  else
    begin
      MW_RegWrite <= XM_RegWrite;
      if(XM_MemtoReg==1'b0)
        begin
	      MW_ALUout	<=	ALUout;
	      MW_RD		<=	XM_RD;
	    end
      else
        begin
          MW_ALUout	<=	DM[ALUout];//lw
	      MW_RD		<=	XM_RD;
        end
    end
end

endmodule
