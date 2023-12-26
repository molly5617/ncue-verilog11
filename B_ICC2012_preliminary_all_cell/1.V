`timescale 1ns/100ps
module NFC(clk, rst, done, F_IO_A, F_CLE_A, F_ALE_A, F_REN_A, F_WEN_A, F_RB_A, F_IO_B, F_CLE_B, F_ALE_B, F_REN_B, F_WEN_B, F_RB_B);

input clk;
input rst;
input  F_RB_A;//快閃記憶體A完成/忙碌信號
input  F_RB_B;//快閃記憶體B完成/忙碌信號
inout [7:0] F_IO_B;
output done;
inout [7:0] F_IO_A;
output F_CLE_A;
output F_ALE_A;
output F_REN_A;
output F_WEN_A;
output F_CLE_B;
output F_ALE_B;
output F_REN_B;
output F_WEN_B;
reg F_CLE_A,F_CLE_B,F_ALE_A,F_ALE_B;
reg done;
reg [2:0] state;
reg F_WEN_A;
reg [1:0]address_a_state;
reg F_REN_A;
reg F_REN_B;
wire OUT_EN_A;
wire [7:0] F_IN_A;
reg [7:0] F_OUT_A;
assign F_IO_A = OUT_EN_A ? F_OUT_A : 'bz;
assign F_IN_A = F_IO_A;
reg F_WEN_B;
//Thi-state Buffer B
wire OUT_EN_B;
wire [7:0] F_IN_B;
reg [7:0] F_OUT_B;
assign F_IO_B = OUT_EN_B ? F_OUT_B : 'bz;
assign F_IN_B = F_IO_B;

reg [17:0] ADDR_CNT;
reg flag_REVC;
reg [1:0] ADDR_STATE_CNT;


always@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        done = 0;
        state=0;
        address_a_state=0;
        flag_REVC=1;
        F_REN_A=1;
        F_WEN_A=1;
        F_REN_B=1;
    end
    else if(state==0)//command
    begin
        F_CLE_A = 1 ;
        F_CLE_B=1;
        F_WEN_B = (~clk);
        state=1;
        F_WEN_A=F_WEN_B;
    end
    else if(state==1)//address
    begin
        F_ALE_A = 1 ;
        F_ALE_B = 1 ;
        F_CLE_A=0;
        F_CLE_B=0;
        F_WEN_B = (~clk);
        F_WEN_A=F_WEN_B;
        if(address_a_state==2'd2)
        begin
            address_a_state=0;
            state=2;
        end
        address_a_state=address_a_state+1;

    end
    else if(state==2)//wait A memory
    begin
        F_WEN_A=1;
        if(F_RB_A)
            state=3;
    end
    else if(state==3)//receive data
    begin
        F_REN_A=~F_REN_A;
        if(flag_REVC==1)
            flag_REVC=0;
        if(ADDR_CNT[8:0]==9'd511 && flag_REVC==0)
            state=4;
    end
    else if(state==4)//write into b
    begin
        F_CLE_B=1;
        F_WEN_B = (~clk);
        state=5;
    end
    else if(state==5)//wait write
    begin
        flag_REVC=1;
        if(F_RB_B&& ADDR_CNT==18'd262143)//256*1024=262144
            state=6;
        else if(F_RB_B)
            state=0;

    end
    else if(state==6)//done
    begin
        done=1;
        //state=0;
    end


end










endmodule
