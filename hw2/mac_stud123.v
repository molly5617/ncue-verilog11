module mac (clk, reset_n, instruction, multiplier,
            multiplicand, stall, protect, result,see);
input clk;
input reset_n;
input [2:0] instruction;
input [15:0] multiplier;
input [15:0] multiplicand;
input stall;
output reg [7:0] protect;
output reg [31:0] result;

reg [15:0] Multiplier;
reg [15:0] Multiplicand;
reg [39:0] temp;
reg [39:0] temp2;
reg [1:0] notice;
output reg [39:0] see;
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
        protect = 8'd0;
        result = 32'd0;
    end
    else
    begin
        // reset_n == 1'b1

        Multiplier = multiplier;	// new multiplier`
        Multiplicand = multiplicand;// new multiplicand

        if (instruction == 3'b000 || instruction == 3'b100)
            temp = 40'd0;
        else if (instruction == 3'b001)
        begin
            // 16-bit x 16-bit
            notice = 2'd0;
            // reset negative count

            if (Multiplier[15] == 1'b1)
            begin
                // negative number
                notice=notice+1;// ...
                Multiplier=~Multiplier+1;
            end

            if (Multiplicand[15] == 1'b1)
            begin
                // negative number
                notice=notice+1;// ...
                Multiplicand=~Multiplicand+1;


            end
            {protect[7:0],result[31:0]}=Multiplier*Multiplicand;
            temp = {protect[7:0],result[31:0]};

            if (notice%2 == 1)
                // negative result
                temp=~temp+1;
            // 2's complement

            for (i=32; i<40; i=i+1)
                temp[i]=temp[31];
            // sign extension
            result=temp;
            // current result is stored in temp
        end
        else if (instruction == 3'b010)
        begin
            temp2 = temp;

            // temp: temporary multiplication result
            // temp2: temporary mac result
            notice = 2'd0;

            if (Multiplier[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplier=~Multiplier+1;
            end

            if (Multiplicand[15] == 1'b1)
            begin
                notice=notice+1;
                Multiplicand=~Multiplicand+1;
            end

            temp[31:0] = temp2;
            {protect[7:0],result[31:0]}=Multiplicand*Multiplier;
            if (notice%2 == 1)
                {protect[7:0],result[31:0]}=~{protect[7:0],result[31:0]}+1;
            {protect[7:0],result[31:0]}=temp2+{protect[7:0],result[31:0]};

            for (i=32; i<40; i=i+1)
                temp[i]=temp[31];

            temp = {protect[7:0],result[31:0]};

            // current result is stored in temp
            result=temp;
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

            // current result is stored in temp
        end
        else if (instruction == 3'b110)
        begin
            temp = 40'd0;
            result=temp;
            // current result is stored in temp
        end
        else if (instruction == 3'b111)
        begin
            temp = 40'd0;
            result=temp;
            // current result is stored in temp
        end

        if (stall == 1'b0)
        begin
            {protect, result} = temp;
        end
    end
end
endmodule
