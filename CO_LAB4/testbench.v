//`define INSTRUCTION_NUMBERS 529600
`timescale 1ns/1ps
`include "CPU.v"

module testbench(
    input clk,
    input rst,
    input sw0,
    input sw1,
    input sw2,
    input sw3,
    input sw4,
    input sw5,
    input sw6,
    input sw7,
    input sw8,
	input sw9,
    input sw10,
    input sw11,
    input sw12,
    input BTNR,

    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
    output dp,
    output d0,
    output d1,
    output d2,
    output d3,
    output d4,
    output d5,
    output d6,
    output d7
    );

reg [6:0] seg_number,seg_data;
reg [17:0] counter;
reg [2:0] state;
reg [7:0] scan;
reg [12:0] input_number;
wire [31:0] output_number1,output_number2;

CPU cpu(
	.clk(clk),
	.rst(rst),
    .input_number(input_number),
    .output_number1(output_number1),
    .output_number2(output_number2)
);

always@(posedge clk)begin
    input_number <= {sw12,sw11,sw10,sw9,sw8,sw7,sw6,sw5,sw4,sw3,sw2,sw1,sw0};
end
assign {d7,d6,d5,d4,d3,d2,d1,d0} = scan;
assign dp = 1;
always@(posedge clk) begin
  counter <=(counter<=100000) ? (counter +1) : 0;
  state <= (counter==100000) ? (state + 1) : state;
   case(state)
	0:begin
      if(BTNR)
        seg_number <= 0;
      else
        seg_number <= output_number1/1000;//cpu.MEM.DM[1]/1000;
	  scan <= 8'b0111_1111;
	end
	1:begin
      if(BTNR)
        seg_number <= 0;
      else
        seg_number <= output_number1%1000/100;//(cpu.MEM.DM[1]%1000)/100;
	  scan <= 8'b1011_1111;
	end
	2:begin
      if(BTNR)
        seg_number <= 0;
      else
        seg_number <= output_number1%100/10;//(cpu.MEM.DM[1]%100)/10;
	  scan <= 8'b1101_1111;
	end
	3:begin
      if(BTNR)
        seg_number <= 0;
      else
        seg_number <= output_number1%10;//cpu.MEM.DM[1]%10;
	  scan <= 8'b1110_1111;
	end
	4:begin
      if(BTNR)
        seg_number <= input_number/1000;
      else
        seg_number <= output_number2/1000;//cpu.MEM.DM[2]/1000;
	  scan <= 8'b1111_0111;
	end
	5:begin
      if(BTNR)
        seg_number <= input_number%1000/100;
      else
        seg_number <= output_number2%1000/100;//(cpu.MEM.DM[2]%1000)/100;
	  scan <= 8'b1111_1011;
	end
	6:begin
      if(BTNR)
        seg_number <= input_number%100/10;
      else
        seg_number <= output_number2%100/10;//(cpu.MEM.DM[2]%100)/10;
	  scan <= 8'b1111_1101;
	end
	7:begin
      if(BTNR)
        seg_number <= input_number%10;
      else
        seg_number <= output_number2%10;//cpu.MEM.DM[2]%10;
	  scan <= 8'b1111_1110;
	end
	default: state <= state;
  endcase
end


assign {g,f,e,d,c,b,a} = seg_data;
always@(posedge clk) begin
  case(seg_number)
	16'd0:seg_data <= 7'b100_0000;
	16'd1:seg_data <= 7'b111_1001;
	16'd2:seg_data <= 7'b010_0100;
	16'd3:seg_data <= 7'b011_0000;
	16'd4:seg_data <= 7'b001_1001;
	16'd5:seg_data <= 7'b001_0010;
	16'd6:seg_data <= 7'b000_0010;
	16'd7:seg_data <= 7'b101_1000;
	16'd8:seg_data <= 7'b000_0000;
	16'd9:seg_data <= 7'b001_0000;
	default: seg_number <= seg_number;
  endcase
end
endmodule
