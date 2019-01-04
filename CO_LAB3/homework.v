`define CYCLE_TIME 20
`define INSTRUCTION_NUMBERS 780
`timescale 1ns/1ps
`include "CPU.v"

module testbench;
reg Clk, Rst;
reg [31:0] cycles, i;

// Instruction DM initialilation
initial
begin// 3->input, 4->conuter
	//######## preprocessing
		cpu.IF.instruction[ 0] = 32'b000000_00000_00000_00100_00000_100000; 	// add $4, $0, $0	-> r4 當作 counter
		cpu.IF.instruction[ 1] = 32'b001000_00000_00001_00000_00000_000001;		// addi $1, $0, 1	-> initial $1 = 1
	//Start
		cpu.IF.instruction[ 2] = 32'b100011_00000_00011_00000_00000_000000; 	// lw $3 ,0($M0)	-> r3 當作 s0
		cpu.IF.instruction[ 3] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 4] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 5] = 32'b001000_00001_00010_00000_00000_000001;		// addi $2, $1, 1	-> initial $2 = 1
		cpu.IF.instruction[ 6] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 7] = 32'b000000_00011_00001_01000_00000_100100; 	// and $8, $3, $1 	-> and $t0, $s0, 1  # t0 determine input is odd | even. ( t0 == 1 -> input is odd, t0 == 0 -> input even )
		cpu.IF.instruction[ 8] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 9] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 10] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 11] = 32'b000101_01000_00000_00000_00000_000111; 	// bne $8, $0, 7	-> bne $t0, $zero, Start # if input != even, start, else input++
		cpu.IF.instruction[ 12] = 32'b000000_00000_00000_00000_00000_100000;	// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 13] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 14] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 15] = 32'b001000_00011_00011_00000_00000_000001;	// add $3, $3, $1	-> addi $s0, $s0, 1
		cpu.IF.instruction[ 16] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 17] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 18] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
	//######## start calculate
//findPrime
		cpu.IF.instruction[ 19] = 32'b000101_00100_00000_00000_00000_000111; 	// bne $4, $zero, 7 -> bne $t3, $zero, Lookdown
		cpu.IF.instruction[ 20] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 21] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 22] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 23] = 32'b000000_00011_00010_00011_00000_100000; 	// add $3, $3, $2 -> add $s1, $s1, $s2	# s1 ++, continue find prime number
		cpu.IF.instruction[ 24] = 32'b000010_00000_00000_00000_00000_011100;	// j 28 -> j Loopset
		cpu.IF.instruction[ 25] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 26] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//Lookdown
		cpu.IF.instruction[ 27] = 32'b000000_00011_00010_00011_00000_100010;	// sub $3, $3, $2 -> sub $s1, $s1, $s2	# s1 --, continue find prime number
//Loopset
		cpu.IF.instruction[ 28] = 32'b000000_00000_00001_00101_00000_100000;	// add $5, $0, $1 -> r5 當作 inner loop index   addi $t1, $zero, 1	# t1 is inner loop index
		cpu.IF.instruction[ 29] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 30] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 31] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//innerloop
		cpu.IF.instruction[ 32] = 32'b000000_00101_00010_00101_00000_100000;	// add $5, $5, $2 -> addi $t1, $t1, 2	# t1++
		cpu.IF.instruction[ 33] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 34] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 35] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 36] = 32'b000100_00011_00101_00000_00000_100000;	//  beq $3, $5, Exit -> beq $s1, $t1, Exit1	# when index == s1, s1 is prime number
		cpu.IF.instruction[ 37] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 38] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 39] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 40] = 32'b000000_00011_00000_00110_00000_100000;	// add $6, $3, $0 -> r6 當作 temp r3
		cpu.IF.instruction[ 41] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 42] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 43] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//modFun
		cpu.IF.instruction[ 44] = 32'b000000_00110_00101_00111_00000_101010;	// slt $7, $6, $5 -> # if (temp < inner loop index)
		cpu.IF.instruction[ 45] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 46] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 47] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 48] = 32'b000101_00111_00000_00000_00000_001010;	// bne $7, $0, 10 -> bne $t2, $zero, modEnd	# t0 < t1 t2 = 1, end mod
		cpu.IF.instruction[ 49] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 50] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 51] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 52] = 32'b000000_00110_00101_00110_00000_100010;	// sub $6, $6, $5 -> sub $t0, $t0, $t1	# t0 - t1
		cpu.IF.instruction[ 53] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 54] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 55] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 56] = 32'b000010_00000_00000_00000_00000_101100;	// j 44 -> j modFun
		cpu.IF.instruction[ 57] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 58] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//modEnd
		cpu.IF.instruction[ 59] = 32'b000100_00110_00000_00000_00000_000110;	//beq $6, $zero, 6-> b F
		cpu.IF.instruction[ 60] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 61] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 62] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 63] = 32'b000010_00000_00000_00000_00000_100000;	// j 32 -> j innerloop
		cpu.IF.instruction[ 64] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 65] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//F
		cpu.IF.instruction[ 66] = 32'b000010_00000_00000_00000_00000_010011;	// j 19 -> j findPrime
		cpu.IF.instruction[ 67] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 68] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//Exit
		cpu.IF.instruction[ 69] = 32'b000101_00100_00000_00000_00000_001000;	//bne $4, $zero, 8	-> b EndProgram
		cpu.IF.instruction[ 70] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 71] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 72] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 73] = 32'b101011_00000_00011_00000_00000_000001;	// sw $3, 1($0)
		cpu.IF.instruction[ 74] = 32'b000000_00100_00001_00100_00000_100000;	// add $4, $4, $1 -> count++
		cpu.IF.instruction[ 75] = 32'b000010_00000_00000_00000_00000_000010;	// j 2 -> restart
		cpu.IF.instruction[ 76] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 77] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
//EndProgram
		cpu.IF.instruction[ 78] = 32'b101011_00000_00011_00000_00000_000010;	// sw $3, 2($0)
		cpu.IF.instruction[ 79] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 80] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 81] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
		cpu.IF.instruction[ 82] = 32'b000000_00000_00000_00000_00000_100000;// NOP(add $0, $0, $0)
end

// Data Memory & Register Files initialilation
initial
begin
	cpu.MEM.DM[0] = 32'd127;	// input
	for (i=1; i<128; i=i+1) cpu.MEM.DM[i] = 32'b0;
	//cpu.ID.REG[0] = 32'd0;	// set r0 == zero
	//cpu.ID.REG[1] = 32'd1;	// set r1 == 1
	//cpu.ID.REG[2] = 32'd2;	// set r2 == 2
	for (i=3; i<32; i=i+1) cpu.ID.REG[i] = 32'b0;

end

//clock cycle time is 20ns, inverse Clk value per 10ns
initial Clk = 1'b1;
always #(`CYCLE_TIME/2) Clk = ~Clk;

//Rst signal
initial begin
	cycles = 32'b0;
	Rst = 1'b1;
	#12 Rst = 1'b0;
end

CPU cpu(
	.clk(Clk),
	.rst(Rst)
);

//display all Register value and Data memory content
always @(posedge Clk) begin
	cycles <= cycles + 1;
	if ((cpu.FD_PC>>2) == 83) $finish; // Finish when excute the 94-th instruction (End label).
	//if ((cpu.FD_PC >> 2) == 35 && (cpu.ID.REG[4] == 1)) $finish; // Finish when excute the 94-th instruction (End label).
	$display("PC: %d cycles: %d", cpu.FD_PC>>2 , cycles);
	$display("  R00-R07: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[0], cpu.ID.REG[1], cpu.ID.REG[2], cpu.ID.REG[3],cpu.ID.REG[4], cpu.ID.REG[5], cpu.ID.REG[6], cpu.ID.REG[7]);
	$display("  R08-R15: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[8], cpu.ID.REG[9], cpu.ID.REG[10], cpu.ID.REG[11],cpu.ID.REG[12], cpu.ID.REG[13], cpu.ID.REG[14], cpu.ID.REG[15]);
	$display("  R16-R23: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[16], cpu.ID.REG[17], cpu.ID.REG[18], cpu.ID.REG[19],cpu.ID.REG[20], cpu.ID.REG[21], cpu.ID.REG[22], cpu.ID.REG[23]);
	$display("  R24-R31: %08x %08x %08x %08x %08x %08x %08x %08x", cpu.ID.REG[24], cpu.ID.REG[25], cpu.ID.REG[26], cpu.ID.REG[27],cpu.ID.REG[28], cpu.ID.REG[29], cpu.ID.REG[30], cpu.ID.REG[31]);
	$display("  0x00   : %08x %08x %08x %08x %08x %08x %08x %08x", cpu.MEM.DM[0],cpu.MEM.DM[1],cpu.MEM.DM[2],cpu.MEM.DM[3],cpu.MEM.DM[4],cpu.MEM.DM[5],cpu.MEM.DM[6],cpu.MEM.DM[7]);
	$display("  0x08   : %08x %08x %08x %08x %08x %08x %08x %08x", cpu.MEM.DM[8],cpu.MEM.DM[9],cpu.MEM.DM[10],cpu.MEM.DM[11],cpu.MEM.DM[12],cpu.MEM.DM[13],cpu.MEM.DM[14],cpu.MEM.DM[15]);
end

//generate wave file, it can use gtkwave to display
initial begin
	$dumpfile("cpu_hw.vcd");
	$dumpvars;
end
endmodule
