`timescale 1ns/100ps
module NFC(clk, rst, done, F_IO_A, F_CLE_A, F_ALE_A, F_REN_A, F_WEN_A, F_RB_A, F_IO_B, F_CLE_B, F_ALE_B, F_REN_B, F_WEN_B, F_RB_B);

input clk;
input rst;
output done;
inout [7:0] F_IO_A;
output F_CLE_A; //read F_IO command,when posedge
output F_ALE_A; //read F_IO Address,when posedge
output F_REN_A; //address++,and read data,negedge
output F_WEN_A; //command,address,write need to set high
input  F_RB_A;  //when high,can access data
inout [7:0] F_IO_B;
output F_CLE_B;
output F_ALE_B;
output F_REN_B;
output F_WEN_B;
input  F_RB_B;

reg done;
//Thi-state Buffer A
wire OUT_EN_A;
wire [7:0] F_IN_A;
reg [7:0] F_OUT_A;
assign F_IO_A = OUT_EN_A ? F_OUT_A : 'bz;
assign F_IN_A = F_IO_A;

//Thi-state Buffer B
wire OUT_EN_B;
wire [7:0] F_IN_B;
reg [7:0] F_OUT_B;
assign F_IO_B = OUT_EN_B ? F_OUT_B : 'bz;
assign F_IN_B = F_IO_B;

//state machine
reg [2:0] cs,ns; //current state , next state
parameter 	IDLE = 3'd0,
           CMD = 3'd1,//command
           ADDR = 3'd2,//ADDRESS Memory
           WAIT_A = 3'd3,//wait memory
           REVC_A = 3'd4, // receive data
           WRITE_B = 3'd5,
           WAIT_B = 3'd6, //wait write
           DONE = 3'd7;

//counter mem_A address
reg [17:0] ADDR_CNT;
reg flag_REVC;
reg [1:0] ADDR_STATE_CNT;

//state switch
always@(posedge clk or posedge rst)
begin
    if(rst)
        cs <= IDLE;
    else
        cs <= ns;
end

//next state logic
always@(*)
begin
    case(cs)
        IDLE:
            ns = CMD;
        CMD:
            ns = ADDR;
        ADDR:
        begin
            if(ADDR_STATE_CNT == 2'd2)
                ns = WAIT_A;
            else
                ns = ADDR;
        end
        WAIT_A:
        begin
            if(F_RB_A)
                ns = REVC_A;
            else
                ns = WAIT_A;
        end
        REVC_A:
        begin
            if( ADDR_CNT[8:0] == 9'd511 && flag_REVC == 1'd0)
                ns = WRITE_B;
            else
                ns = REVC_A;
        end
        WRITE_B:
        begin
            ns = WAIT_B;
        end
        WAIT_B:
        begin
            if(F_RB_B && ADDR_CNT == 18'd262143)
                ns = DONE;
            else if(F_RB_B)
                ns = IDLE;
            else
                ns = WAIT_B;
        end
        DONE:
            ns = DONE;
        default:
            ns = IDLE;
    endcase
end

//counter ADDR state
always@(posedge clk or posedge rst)
begin
    if(rst)
        ADDR_STATE_CNT <= 2'd0;
    else if(ADDR_STATE_CNT == 2'd2)
        ADDR_STATE_CNT <= 2'd0;
    else if(cs == ADDR)
        ADDR_STATE_CNT <= ADDR_STATE_CNT + 2'd1;
end

//flag to juge ever entered REVC_A
always@(posedge clk or posedge rst)
begin
    if(rst)
        flag_REVC <= 1'd1;
    else if(cs == REVC_A && flag_REVC == 1'd1)
        flag_REVC <= 1'd0;
    else if(cs == WAIT_B)
        flag_REVC <= 1'd1;
end

//F_CLE
wire F_CLE_A = (cs == CMD) ? 1'd1 : 1'd0;
wire F_CLE_B = (cs == CMD || cs == WRITE_B ) ? 1'd1 : 1'd0;

//F_REN
reg F_REN_A;
always@(posedge clk or posedge rst)
begin
    if(rst)
        F_REN_A <= 1'd1;
    else if(cs == REVC_A)
        F_REN_A <= (~F_REN_A);
end
wire F_REN_B = 1'd1;

//F_WEN
wire F_WEN_A = (cs == CMD || cs == ADDR) ? F_WEN_B : 1'd1;
reg F_WEN_B;
always@(*)
begin
    if(F_CLE_B == 1'd1 || cs == ADDR)
        F_WEN_B = (~clk);
    else if(F_REN_A == 1'd0)
        F_WEN_B  = (~clk);
    else
        F_WEN_B = 1'd0;
end

//F_ALE
wire F_ALE_A = (cs == ADDR) ? 1'd1 : 1'd0;
wire F_ALE_B = (cs == ADDR) ? 1'd1 : 1'd0;

//OUT_EN
assign OUT_EN_A = (cs == CMD || cs == ADDR) ? 1'd1 : 1'd0;
assign OUT_EN_B = 1'd1;

//F_OUT_A
wire [17:0] ADDR_CNT_ADD_ONE = (ADDR_CNT == 18'd0) ? ADDR_CNT : ADDR_CNT + 18'd1;
always@(posedge clk or posedge rst)
begin
    if(rst)
        F_OUT_A <= 8'd0;
    else if(cs == IDLE)
        F_OUT_A <= {7'd0,ADDR_CNT_ADD_ONE[8]};
    else if(cs == CMD)
        F_OUT_A <= ADDR_CNT_ADD_ONE[7:0];
    else if(cs == ADDR && ADDR_STATE_CNT == 2'd0 )
        F_OUT_A <= ADDR_CNT_ADD_ONE[16:9];
    else if(cs == ADDR && ADDR_STATE_CNT == 2'd1 )
        F_OUT_A <= {7'd0,ADDR_CNT_ADD_ONE[17]};
end

//F_OUT_B
always@(*)
begin
    if(cs == CMD)
        F_OUT_B = 8'h80;
    else if(cs == ADDR)
        F_OUT_B = F_OUT_A;
    else if(cs == WRITE_B)
        F_OUT_B = 8'h10;
    else
        F_OUT_B = F_IN_A;
end

reg flag_c;
//ADDR_CNT
always@(posedge clk or posedge rst)
begin
    if(rst)
        {ADDR_CNT,flag_c} <= {18'd262143,1'd1};
    else if(cs == REVC_A && ns == REVC_A)
        {ADDR_CNT,flag_c} <= {ADDR_CNT,flag_c} + 19'd1;
end

//done
always@(posedge clk or posedge rst)
begin
    if(rst)
        done <= 1'd0;
    else if(cs == DONE)
        done <= 1'd1;
end

endmodule
