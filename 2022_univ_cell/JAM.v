module JAM (
           input CLK,
           input RST,
           output reg [2:0] W,
           output reg [2:0] J,
           input [6:0] Cost,
           output reg [3:0] MatchCount,
           output reg [9:0] MinCost,
           output reg Valid );
reg [2:0] cur_state, next_state;
reg [2:0] n[7:0];
reg [2:0] pivot, left, right;
reg [9:0] cost_buffer;
reg [2:0] swapnum,swapnum_index;
reg new;
reg [2:0] state;
always@(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        Valid<=0;
        MatchCount<=0;
        MinCost<=10'b1111111111;//最小的cost
        cost_buffer<=10'd0;//暫存目前cost
        W<=3'd0;
        J<=3'd0;
        n[0] <= 3'd0;
        n[1] <= 3'd1;
        n[2] <= 3'd2;
        n[3] <= 3'd3;
        n[4] <= 3'd4;
        n[5] <= 3'd5;
        n[6] <= 3'd6;
        n[7] <= 3'd7;
        pivot<=3'd7;//替換點
        left<=3'd0;
        new<=0;
        swapnum<=7;//要找出替換右邊數字中最小但比替換點大的數字

        state<=0;
    end
    else if(state==0)
    begin
        cost_buffer<=cost_buffer+Cost;//暫存這part cost值 先存(0,0) state4會重製開頭陣列
        W<=W+1;
        J<=n[W+1];
        if(W==7)
        begin
            new<=1;
            state<=1;
        end

    end
    else if(state==1)
    begin
        if(new)
        begin
            new<=0;
            if(cost_buffer<MinCost)//若比mincost小換mincost值
            begin
                MinCost<=cost_buffer;
                MatchCount<=4'd1;
            end
            else if(cost_buffer==MinCost)//若相同match組數+1
            begin
                MatchCount<=MatchCount+1;
            end
            else
            begin
                MinCost<=MinCost;
            end
        end
        if(n[pivot]>n[pivot-1])//找第一組右邊比左邊大的數
        begin
            pivot<=pivot-1;//替換點
            left<=pivot;
            swapnum_index<=pivot;
            state<=2;
        end
        else
        begin
            pivot<=pivot-1;
            left<=pivot;
        end

        if((n[0] == 7 && n[1] == 6 && n[2] == 5 && n[3] == 4 & n[4] == 3 && n[5] == 2 && n[6] == 1 && n[7] == 0))
        begin
            state<=5;
        end
    end
    else if(state==2)//找比現在pivot的大，但是是右邊最小的
    begin

        if(n[left]>n[pivot])
        begin
            if(n[left]<swapnum)
            begin
                swapnum<=n[left];//要交換的值
                swapnum_index<=left;//要交換的index
            end
            else
            begin
                swapnum<=swapnum;
            end
        end
        if(left==7)//搜尋完Pivot右邊
        begin
            state<=3;
        end
        left<=left+1;//pivot右邊一個
    end
    else if(state==3)//把pivot跟state2找到最小的交換
    begin
        n[pivot] <= n[swapnum_index];
        n[swapnum_index]<=n[pivot];
        left<=pivot+1;
        right<=7;
        state<=4;
    end
    else if(state==4)//將pivot右邊翻轉
    begin
        cost_buffer<=10'd0;
        if(left<right)
        begin
            n[left]<=n[right];
            n[right]<=n[left];
            left<=left+1;
            right<=right-1;
        end
        else
        begin
            W<=0;
            pivot<=3'd7;
            J<=n[0];
            swapnum<=7;
            state<=0;
        end
    end
    else if(state==5)
    begin
        Valid<=1;
    end
end
endmodule
