module IR_CTRL (
    
    input clk,
    input reset_n,

    input sfr_rd,
    input sfr_wr,
    input [7:0] sfr_addr,
    input [7:0] sfr_data_out,
    output reg [7:0] sfr_data_in,

    output reg IRDA_TXD

);

    //宣告
    reg [2:0] send_state;
    parameter IDLE = 3'd0, LEADER = 3'd1, ADDR = 3'd2, ADDR_N = 3'd3;
    parameter CMD = 3'd4, CMD_N = 3'd5, REPEAT = 3'd6;
    parameter STOP = 3'd7;

    parameter CTRL_BYTE = 8'hF1, BYTE_1 = 8'hF2, BYTE_2 = 8'hF3;
    parameter BYTE_3 = 8'hF4, BYTE_4 = 8'hF5;
    
    reg [16:0]counter;
    reg [7:0] send_mem [8'hF5 : 8'hF1];
    reg [3:0] send_conter;
    reg [19:0] leader_counter;
    reg [19:0] rep_counter;
    reg wave;
    reg leader_tx, repeat_tx;

    wire send_tx = send_mem[CTRL_BYTE][0];
    wire send_repeat = send_mem[CTRL_BYTE][1];

    wire send = (send_state >= ADDR && send_state <= CMD_N) ? send_mem[send_state+8'hF0][send_conter] : 1'b0;
    wire bit_send_end = (send) ? counter == 17'd112_499 : counter == 17'd56_000;
    wire byte_send_end = bit_send_end && send_conter == 4'd7;
    
    
    //SFM暫存 -- 讀取
    always @(*) begin
        if(sfr_rd && sfr_addr == CTRL_BYTE)
            sfr_data_in = send_mem[sfr_addr];
        else sfr_data_in = 8'h0;
    end

    //SFM暫存 -- 存入
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) begin
            send_mem[CTRL_BYTE] <= 8'h0;
            send_mem[BYTE_1] <= 8'h0;
            send_mem[BYTE_2] <= 8'h0;
            send_mem[BYTE_3] <= 8'h0;
            send_mem[BYTE_4] <= 8'h0;
        end

        //完成
        else if(send_state == CMD_N && byte_send_end || send_state == REPEAT && rep_counter == 20'd562_500)begin
            send_mem[CTRL_BYTE][4] <= 1'd1;
        end

        //街道開始傳送旗標 -> 清除旗標
        else if(send_tx || send_repeat)begin
            send_mem[CTRL_BYTE] <= 1'd0;
        end

        //寫入
        else if(sfr_addr >= CTRL_BYTE && sfr_addr <=BYTE_4 && sfr_wr)begin
            send_mem[sfr_addr] <= sfr_data_out;
        end

        //啥事都不做
        else begin
            send_mem[sfr_addr] <= send_mem[sfr_addr];
        end
    end
    
    //主要TXD
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) IRDA_TXD <= 1'd0;
        else begin
            if(send_state == LEADER) IRDA_TXD <= wave & leader_tx;
            else if(send_state >= ADDR && send_state <= CMD_N) IRDA_TXD <= wave & counter < 17'd28_000;
            else if(send_state == REPEAT) IRDA_TXD <= wave & repeat_tx;
            else if(send_state == STOP) IRDA_TXD <= 1'b1;
            else IRDA_TXD <= 1'd0;
        end
    end

    //主要有限狀態機
    always @(posedge clk,negedge reset_n) begin
        if(!reset_n) send_state <= IDLE;
        else begin
            case (send_state)
                //wait
                IDLE:   send_state <= (send_tx) ? LEADER :
                                      (send_repeat) ? REPEAT 
                                      : IDLE;
                
                //Nomal Send
                LEADER: send_state <= (leader_counter == 20'd675_000) ? ADDR : LEADER;
                ADDR:   send_state <= (byte_send_end) ? ADDR_N : ADDR;
                ADDR_N: send_state <= (byte_send_end) ? CMD    : ADDR_N;
                CMD:    send_state <= (byte_send_end) ? CMD_N  : CMD;
                CMD_N:  send_state <= (byte_send_end) ? STOP   : CMD_N;

                //Rep Code
                REPEAT: send_state <= (rep_counter == 20'd562_500) ? STOP : REPEAT;

                //Stop
                STOP:   send_state <= IDLE;

                default:send_state <= IDLE;
            endcase
        end
    end



    //傳送計數器 -- 普通資料
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) send_conter <= 4'd0;
        else if(send_state >= ADDR && send_state <= CMD_N) begin
            if(bit_send_end) begin
                if(send_conter == 4'd7) send_conter <= 4'd0;
                else send_conter <= send_conter + 1'd1;
            end
            else send_conter <= send_conter;
        end
        else send_conter <= 4'd0;
    end


    //0/1產生器 -- 普通資料 -- 底層計數器
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) counter <= 17'd0;
        else if(send_state >= ADDR && send_state <= CMD_N) begin 
            if(send && counter == 17'd112_499) counter <= 17'd0;
            else if (!send && counter == 17'd56_000) counter <= 17'd0;
            else counter <= counter + 17'd1;
        end
        else counter <= 17'd0;
    end

    //領導產生器
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) begin
            leader_counter <= 20'd0;
            leader_tx <= 1'd1;
        end
        else if(send_state == LEADER)begin
            if(leader_counter == 20'd675_000)begin
                leader_counter <= 20'd0;
                leader_tx <= 1'd1;
            end
            else if(leader_counter == 20'd450_000)begin
                leader_counter <= leader_counter + 1'd1;
                leader_tx <= 1'd0;
            end
            else begin
                leader_counter <= leader_counter + 20'd1;
                leader_tx <= leader_tx;
            end
        end
    end

    //重複訊號產生器
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) begin
            rep_counter <= 20'd0;
            repeat_tx <= 1'd1;
        end 
        else if(send_state == REPEAT)begin
            if(rep_counter == 20'd562_500) begin
                rep_counter <= 20'd0;
                repeat_tx <= 1'd1;
            end
            else if (rep_counter == 20'd450_000) begin
                rep_counter <= rep_counter + 20'd1;
                repeat_tx <= 1'd0;
            end
            else begin
                rep_counter <= rep_counter + 20'd1;
                repeat_tx <= repeat_tx;
            end
        end
        else begin
            rep_counter <= 20'd0;
        end 
    end

    //載波產生器
    reg [10:0] wave_counter;
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n)begin
            wave_counter <= 11'd0;
            wave <= 1'd0;
        end 
        else if(wave_counter == 11'd1316)begin
            wave_counter <= 11'd0;
            wave <= 1'd0;
        end 
        else if(wave_counter == 11'd658)begin
            wave_counter <= wave_counter + 11'd1;
            wave <= 1'd1;
        end 
        else begin
            wave_counter <= wave_counter + 11'd1;
            wave <= wave;
        end 
    end

    
    
    
endmodule