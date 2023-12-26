// ==============================================================
//   Modify the definition of HALF_CYCLE to change clock period
//   clock period = HALF_CYCLE * 2
// ==============================================================
`timescale 1ns/10ps
`define HALF_CYCLE 10.0
`define CYCLE `HALF_CYCLE*2.0
`define THOLD 2.0
`define TDELAY 2.5

module mac_half_tb001;
reg clk, reset_n;
reg [2:0] instruction;
reg [15:0] multiplier;
reg [15:0] multiplicand;
reg stall;
wire [7:0] protect;
wire [31:0] result;
wire [39:0]see;
mac top (.clk(clk), .reset_n(reset_n), .instruction(instruction), .multiplier(multiplier),
         .multiplicand(multiplicand), .stall(stall), .protect(protect), .result(result),.see(see));


initial
begin
    reset_n <= 1'b1;
    clk <= 1'b1;
    multiplier <= 0;
    multiplicand <= 0;
    instruction <= 0;
    stall <= 1'b0;
end

always #(`HALF_CYCLE) clk = ~clk;

initial
begin
    #(`HALF_CYCLE)      reset_n = 1'b0;
    #(`CYCLE*2)        reset_n = 1'b1;
    #(`CYCLE)		multiplier = 6;
    multiplicand = 25;
    instruction = 1;
    #(`CYCLE)		multiplicand = 30;
    #(`CYCLE)		multiplier = -4;
    multiplicand = 5;
    instruction = 2;
    #(`CYCLE*2)		multiplier = -15;
    multiplicand = -6;
    #(`CYCLE*2)		multiplier = 32'h7fff;
    multiplicand = 32'h7fff;
    instruction = 1;
    #(`CYCLE)		instruction = 2;
    #(`CYCLE*7)		multiplier = 8;
    multiplicand = 8;
    instruction = 3;
    #(`CYCLE)		instruction = 1;
    #(`CYCLE*2)		$finish;

end
endmodule









