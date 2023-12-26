module mac (clk, reset_n, instruction, multiplier,
            multiplicand, stall, protect, result);
input clk;
input reset_n;
input [2:0] instruction;
input [15:0] multiplier;
input [15:0] multiplicand;
input stall;
output reg [7:0] protect;
output reg [31:0] result;
reg [39:0]queue[2:0];
reg [15:0] Multiplier;
reg [15:0] Multiplicand;
reg [39:0] temp;
reg [39:0] temp2;
reg [1:0] notice;
reg[1:0] notice1;
reg [39:0]temp3;
/* 	for first part of class
reg [39:0] queue[1:0];//the output queue
reg [39:0] last_output;
reg [1:0] counter;
reg [1:0] counter2;
*/
integer i;//just for for loop

always@(posedge clk or negedge reset_n)
begin
    if (reset_n == 1'b0)
    begin
        protect[7:0] = 8'h0;
        result[31:0] = 32'h0;
        temp=0;
        queue[0]=0;
        queue[1]=0;
    end
    else
    begin
        // reset_n == 1'b1

        Multiplier = multiplier;	// new multiplier`
        Multiplicand = multiplicand;// new multiplicand

        if (instruction == 3'b000 || instruction == 3'b100)
        begin
            temp = 40'd0;
            result[31:0]=32'h0;
            protect[7:0]=8'h0;
        end
        else if (instruction == 3'b001)
        begin
            notice = 2'd0;
            if (Multiplier[15] == 1'b1)
            begin
                notice=notice+1;// ...
                Multiplier=-Multiplier;
            end

            if (Multiplicand[15] == 1'b1)
            begin
                notice=notice+1;// ...
                Multiplicand=-Multiplicand;
            end

            temp=Multiplier*Multiplicand;
            if (notice%2 == 1)
                temp=-temp;
        end

        else if (instruction == 3'b010)
        begin
            temp2 = temp;
            notice = 2'd0;
            if (Multiplier[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplier=-Multiplier;
            end
            if (Multiplicand[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplicand=-Multiplicand;
            end
            temp=Multiplicand*Multiplier;
            if (notice%2 == 1)
                temp=-temp;
            temp3=temp2+temp;
            temp=temp3;
            // current result is stored in temp
        end
        else if (instruction == 3'b011)
        begin
            // saturation16

            if (temp > 40'h007fffffff && temp[39] == 1'b0)
                temp[31:0] = 32'h7FFFFFFF;
            else if (temp < 40'hff80000000 && temp[39] == 1'b1)
                temp[31:0] = 32'h80000000;
            // current result is stored in temp

        end
        else if (instruction == 3'b101)
        begin
            temp = 40'd0;
            // temp: temporary multiplication result
            // temp2: temporary mac result
            notice = 2'd0;
            notice1=2'd0;
            if (Multiplier[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplier[15:8]=~Multiplier[15:8]+1;
            end
            if (Multiplier[7] == 1'b1)
            begin
                notice1=notice1+1;
                Multiplier[7:0]=~Multiplier+1;
            end

            if (Multiplicand[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplicand[15:8]=~Multiplicand[15:8]+1;
            end
            if (Multiplicand[7] == 1'b1)
            begin
                notice1=notice1+1;
                Multiplicand[7:0]=~Multiplicand[7:0]+1;
            end
            temp[19:0]=Multiplicand[7:0]*Multiplier[7:0];
            temp[39:20]=Multiplicand[15:8]*Multiplier[15:8];
            //{protect[3:0],result[15:0]}=Multiplicand[7:0]*Multiplier[7:0];
            //{protect[7:4],result[31:16]}=Multiplicand[15:8]*Multiplier[15:8];
            if (notice%2 == 1)
            begin
                temp[39:20]=-temp[39:20];
                //{protect[3:0],result[15:0]}=~{protect[3:0],result[15:0]}+1;
                //{protect[7:4],result[31:16]}=~{Multiplicand[15:8]*Multiplier[15:8]}+1;
            end
            if(notice1%2==1)
                temp[19:0]=-temp[19:0];
            //temp={protect[7:4],result[31:16],protect[3:0],result[15:0]};
            // current result is stored in temp
            // current result is stored in temp
            temp3=temp;
            temp={temp3[39:36],temp3[19:16],temp3[35:20],temp3[15:0]};
        end
        else if (instruction == 3'b110)
        begin
            temp2=temp;
            temp = 40'd0;
            notice = 2'd0;
            notice1=2'd0;
            if (Multiplier[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplier[15:8]=~Multiplier[15:8]+1;
            end
            if (Multiplier[7] == 1'b1)
            begin
                notice1=notice1+1;
                Multiplier[7:0]=~Multiplier[7:0]+1;
            end

            if (Multiplicand[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplicand[15:8]=~Multiplicand[15:8]+1;
            end
            if (Multiplicand[7] == 1'b1)
            begin
                notice1=notice1+1;
                Multiplicand[7:0]=~Multiplicand[7:0]+1;
            end

            temp[19:0]=Multiplicand[7:0]*Multiplier[7:0];
            temp[39:20]=Multiplicand[15:8]*Multiplier[15:8];
            if (notice%2 == 1)
            begin
                temp[39:20]=-temp[39:20];
                //{protect[7:4],result[31:16]}=temp2[39:20]+((~(Multiplicand[15:8]*Multiplier[15:8]))+1);
            end
            if(notice1%2==1)
                temp[19:0]=-temp[19:0];

            temp3=temp;
            temp2={temp2[39:36],temp2[31:16],temp2[35:32],temp2[15:0]};
            temp={temp2[39:20]+temp3[39:20],temp2[19:0]+temp3[19:0]};
            temp={temp[39:36],temp[19:16],temp[35:20],temp[15:0]};
            //temp={temp2[39:20]+temp[39:20],temp2[19:0]+temp[19:0]};

            //temp={protect[7:4],result[31:16],protect[3:0],result[15:0]};
            // current result is stored in temp
            // current result is stored in temp

        end
        else if (instruction == 3'b111)
        begin
            // saturation16
            if ({temp[39:36],temp[31:16]} > 20'h07fff && temp[39] == 1'b0)
                temp[31:16] = 16'h7FFF;
            else if ({temp[39:36],temp[31:16]} < 20'hf8000 && temp[39] == 1'b1)
                temp[31:16] = 16'h8000;
            //for(i=36;i<40;i=i+1)
            // temp[i]=temp[31];

            if ({temp[35:32],temp[15:0]} > 20'h07fff && temp[35] == 1'b0)
                temp[15:0] = 16'h7FFF;
            else if ({temp[35:32],temp[15:0]} < 20'hf8000 && temp[35] == 1'b1)
                temp[15:0] = 16'h8000;
            //for(i=32;i<36;i=i+1)
            //temp[i]=temp[15];

            // current result is stored in temp
        end

        if (stall == 1'b0)
        begin
            //{protect, result} = temp;
            {protect,result}=queue[0];
            queue[0]=queue[1];
            queue[1]=temp;
        end
        else
        begin
            temp=queue[1];


        end

    end
end
endmodule
