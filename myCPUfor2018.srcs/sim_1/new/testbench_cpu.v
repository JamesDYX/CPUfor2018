`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/31 17:17:58
// Design Name: 
// Module Name: testbench_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_cpu;

	// Inputs
	reg clk;
	reg resetn;

	// Instantiate the Unit Under Test (UUT)
	soc_sram uut (
		.clk(clk), 
		.rstn(resetn)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		resetn = 0;

		
		#100;
		resetn = 1;
//		#100;
//		reset = 1;
//		#100;
//		reset = 0;

	end
	always #5 clk = ~clk;

endmodule
