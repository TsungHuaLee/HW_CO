`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	A,
	B,
	DX_RD,
	ALUctr,
    DX_MemtoReg,
    DX_MemWrite,
    DX_MD,
    DX_RegWrite,
    DX_Beqctr,
    DX_BranchIns,
    DX_Bnectr,

    XF_Bnectr,
    XF_BranchIns,
    XF_Beqctr,
    XM_RegWrite,
    XM_MD,
    XM_MemWrite,
    XM_MemtoReg,
	ALUout,
	XM_RD
);

input clk,rst;
input [31:0] A,B,DX_MD,DX_BranchIns;
input [4:0]DX_RD;
input [2:0] ALUctr;
input DX_MemtoReg,DX_MemWrite,DX_RegWrite,DX_Beqctr,DX_Bnectr;

output reg [31:0]ALUout,XM_MD,XF_BranchIns;
output reg [4:0]XM_RD;
output reg XM_MemtoReg,XM_MemWrite,XM_RegWrite,XF_Beqctr,XF_Bnectr;

//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
      XM_MemtoReg <= 1'd0;
      XM_MemWrite <= 1'd0;
      XM_MD <= 32'd0;
      XM_RegWrite <= 1'd0;
      XF_Beqctr <= 1'd0;
      XF_BranchIns <= 32'd0;
      XF_Bnectr <= 1'd0;
	end 
  else 
	begin
	  XM_RD <= DX_RD;
      XM_MemtoReg <= DX_MemtoReg;
      XM_MemWrite <= DX_MemWrite;
      XM_MD <= DX_MD;
      XM_RegWrite <= DX_RegWrite;
      XF_Beqctr <= DX_Beqctr;
      XF_BranchIns <= DX_BranchIns<<2;
      XF_Bnectr <= DX_Bnectr;
	end
end

// calculating ALUout
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  ALUout	<= 32'd0;
	end 
  else 
	begin
	  case(ALUctr)
	    3'd0: //add //lw //sw
		  begin
	        ALUout <=A+B;
		  end
		3'd1: //sub beq
		  begin
            ALUout <=A-B;
		    //define sub behavior here
		  end
        3'd2: //and
		  begin
            ALUout <=A&B;
		    //define  behavior here
		  end
        3'd3: //or
		  begin
            ALUout <=A|B;
		    //define  behavior here
		  end
        3'd4: //slt
		  begin
            ALUout <= (A<B)?1:0;
		    //define  behavior here
		  end
	  endcase
	end
end
endmodule
	
