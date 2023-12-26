// ==============================================================
//   Modify the definition of HALF_CYCLE to change clock period
//   clock period = HALF_CYCLE * 2
// ==============================================================
module test;

wire  [7:0] protect;
wire [31:0] result;
reg clk;
reg reset_n;
reg [2:0] instruction;
reg [15:0] multiplier;
reg [15:0] multiplicand;
reg stall;
mac m0(clk, reset_n, instruction, multiplier,multiplicand, stall, protect, result);
initial
begin
    reset_n=1;
    stall=0;
    clk=0;
    multiplier=0;
    instruction=0;
    multiplicand=0;
    #10
     multiplier=16'd6;
    multiplicand=16'd25;
    instruction=3'd1;
    #10
     multiplier=16'd6;
    multiplicand=16'd30;
    instruction=3'd1;
    #10
     multiplier=-16'd4;
    multiplicand=16'd5;
    instruction=3'd2;
    #10
     multiplier=-16'd4;
    multiplicand=16'd5;
    instruction=3'd2;
    #10
     multiplier=-16'd15 ;
    multiplicand=-16'd6;
    instruction=3'd2;
    #10
     multiplier=-16'd15;
    multiplicand=-16'd6;
    instruction=3'd2;
    #10 $finish;
end
always #5 clk=~clk;




endmodule
