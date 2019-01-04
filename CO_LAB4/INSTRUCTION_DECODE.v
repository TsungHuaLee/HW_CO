`timescale 1ns/1ps

module INSTRUCTION_DECODE(
	clk,
	rst,
	IR,
	PC,
	MW_RD,
	MW_ALUout,
    MW_RegWrite,

	A,
	B,
	RD,
	ALUctr,
    DX_MemtoReg,
    DX_MemWrite,
    DX_MD,
    DX_RegWrite,
    DX_Beqctr,
    DX_BranchIns,
    DF_Jumpctr,
    DF_JumpImm,
    DX_Bnectr
);

input clk,rst;
input [31:0]IR, PC, MW_ALUout;
input [4:0] MW_RD;
input MW_RegWrite;

output reg [31:0] A, B, DX_MD,DX_BranchIns,DF_JumpImm;
output reg [4:0] RD;
output reg [2:0] ALUctr;
output reg DX_MemtoReg,DX_MemWrite,DX_RegWrite,DX_Beqctr,DF_Jumpctr,DX_Bnectr;

//register file
reg [31:0] REG [0:31];

//Write back
always @(posedge clk or posedge rst)//add new Dst REG source here
begin
    if(rst) begin
        REG[0] = 32'd0;
    end
    else if(MW_RegWrite)
      begin
	    if(MW_RD)
          REG[MW_RD] <= MW_ALUout;
	    else
	      REG[MW_RD] <= REG[MW_RD];//keep REG[0] always equal zero
      end
end

//set A, and other register content(j/beq flag and address)
always @(posedge clk or posedge rst)
begin
	if(rst)
	  begin
	    A 	<=32'b0;
	  end
	else
	  begin
	    A 	<=REG[IR[25:21]];
	  end
end

//set control signal, choose Dst REG, and set B
always @(posedge clk or posedge rst)
begin
	if(rst)
	  begin
		B 		<=32'b0;
        DX_MD	<=32'b0;
		RD 		<=5'b0;
		ALUctr 	<=3'b0;
        DX_MemtoReg <=1'b0;
        DX_MemWrite <=1'b0;
        DX_RegWrite <=1'b0;
        DX_Beqctr   <=1'b0;
        DX_BranchIns <=32'b0;
        DF_Jumpctr <=1'b0;
        DF_JumpImm <=32'b0;
        DX_Bnectr <=1'b0;
	  end
	else
	  begin
        DX_Beqctr <= 1'd0;
        DF_Jumpctr <= 1'd0;
        DX_Bnectr <=1'b0;
	    case(IR[31:26])
		  6'd0://R-Type
		    begin
			  case(IR[5:0])//funct & setting ALUctr
			    6'd32://add
				  begin
		            B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd0;//self define ALUctr value
                    DX_MemtoReg <=3'd0;
                    DX_MemWrite <= 1'd0;
                    DX_RegWrite <= 1'd1;
				  end
				6'd34://sub
				  begin
					//define sub behavior here
                    B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd1;//self define ALUctr value
                    DX_MemtoReg <=3'd0;
                    DX_MemWrite <= 1'd0;
                    DX_RegWrite <= 1'd1;
				  end
                6'd36://and
				  begin
                    B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd2;//self define ALUctr value
                    DX_MemtoReg <=3'd0;
                    DX_MemWrite <= 1'd0;
                    DX_RegWrite <= 1'd1;
					//define and behavior here
				  end
                6'd37://or
				  begin
                    B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd3;//self define ALUctr value
                    DX_MemtoReg <=3'd0;
                    DX_MemWrite <= 1'd0;
                    DX_RegWrite <= 1'd1;
					//define or behavior here
				  end
				6'd42://slt
				  begin
                    B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd4;//self define ALUctr value
                    DX_MemtoReg <=3'd0;
                    DX_MemWrite <= 1'd0;
                    DX_RegWrite <= 1'd1;
					//define slt behavior here
				  end
			  endcase
			end
	      6'd35://lw
			begin
                B <= {{16{IR[15]}},IR[15:0]};
                RD	<=IR[20:16];
                ALUctr <=3'd0;
                DX_MemtoReg <=3'd1;
                DX_MemWrite <= 1'd0;
                DX_RegWrite <= 1'd1;
			  //define lw behavior here
			end
	      6'd43://sw
			begin
                B <= {{16{IR[15]}},IR[15:0]};
                RD	<=IR[20:16];
                DX_MD <= REG[IR[20:16]];
                ALUctr <=3'd0;
                DX_MemWrite <= 1'd1;
                DX_RegWrite <= 1'd0;
			  //define sw behavior here
			end

          6'd8://lw
                begin
                B <= {{16{IR[15]}},IR[15:0]};
                RD    <=IR[20:16];
                ALUctr <=3'd0;
                DX_MemtoReg <=3'd0;
                DX_MemWrite <= 1'd0;
                DX_RegWrite <= 1'd1;
                //define lw behavior here
          end
	      6'd4://beq
			begin
                B	<=REG[IR[20:16]];
                ALUctr <=3'd1;
                DX_MemWrite <= 1'd0;
                DX_RegWrite <= 1'd0;
                DX_Beqctr <= 1'd1;
                DX_BranchIns <= {{16{IR[15]}},IR[15:0]};
			  //define beq behavior here
			end
	      6'd2://j
			begin
                DX_MemWrite <= 1'd0;
                DX_RegWrite <= 1'd0;
                DF_Jumpctr <= 1'd1;
                DF_JumpImm <= IR[25:0]<<2;
			  //define j behavior here
			end
          6'd8://addi
            begin
                B	<= {{16{IR[15]}},IR[15:0]};
		        RD	<=IR[20:16];
				ALUctr <=3'd0;//self define ALUctr value
                DX_MemtoReg <=3'd0;
                DX_MemWrite <= 1'd0;
                DX_RegWrite <= 1'd1;
            end
          6'd5://bne
            begin
                B	<=REG[IR[20:16]];
                ALUctr <=3'd1;
                DX_MemWrite <= 1'd0;
                DX_RegWrite <= 1'd0;
                DX_Bnectr <= 1'd1;
                DX_BranchIns <= {{16{IR[15]}},IR[15:0]};
            end
		endcase
	  end
end
endmodule
