module IR_RX(
           IRDA_RXD,
           CLOCK_50,
           RSTN,
           DATA
           );
input IRDA_RXD;
input CLOCK_50;
input RSTN;
output [31:0]DATA;
parameter lead_code = 607500;//9+4.5ms=13.5ms*0.9
parameter repeat_code = 506250;//9+2.25ms=11.25ms*0.9
parameter low_time = 50400;//1.12ms*0.9
parameter high_time = 101250;//2.25ms*0.9
parameter idle=2'd0,leader_check=2'd1,receive=2'd2,data_check_latch=2'd3;
reg [31:0] ir_data;
reg [31:0] output_buf;
reg [1:0] state;
reg ir_n,ir_flag;
reg [20:0] lead_cnt;
reg [16:0] data_cnt;
reg [4:0] bitcount;
reg dataok;
reg leadok;
reg data_rece_finish;
reg data_error;
reg repeat_ok;

assign DATA = output_buf;

always@(posedge CLOCK_50 or negedge RSTN) //ir dection
begin
        if(!RSTN)begin
                ir_n<=1'h0;
        end
        else begin
                if(IRDA_RXD) begin
                        ir_flag<=1'h1;
                        ir_n<=1'h0;
                end
                else begin
                        if(ir_flag) begin
                                ir_n<=1'h1;
                                ir_flag<=1'h0;
                        end
                        else begin
                                ir_n<=1'h0;
                        end
                end
        end
end
always@(posedge CLOCK_50 or negedge RSTN) //FSM
begin
        if(!RSTN)begin
                state<=idle;
                dataok<=0;
        end
        else begin
                case(state)
                        idle:begin
                                if(ir_n) state<=leader_check;
                                else state<=idle;
                        end
                        leader_check:begin
                                if(leadok) state<=receive;
                                else state<=leader_check;
                        end
                        receive:begin
                                if(data_rece_finish) state<=data_check_latch;
                                else if(data_error) state<=idle;
                                else state<=receive;
                        end
                        data_check_latch:
                        begin
                                state<=idle;
                        end
                        default:state<=idle;
                endcase
        end
end
always@(posedge CLOCK_50 or negedge RSTN) begin //lead time counter
        if(!RSTN)begin
                lead_cnt<=0;
        end
        else begin
                if(state==leader_check)begin
                        if(ir_n)begin
                                lead_cnt<=0;
                        end
                        else begin
                                lead_cnt<=lead_cnt+1;
                        end
                end
                else begin
                        lead_cnt<=0;
                end
        end
end
always@(posedge CLOCK_50 or negedge RSTN) //check lead code time
begin
        if(!RSTN) begin
                leadok<=0;
        end
        else begin
                if(state==leader_check) begin
                        if(ir_n) begin
                                if((lead_cnt>lead_code)&&(lead_cnt<742500))
                                begin
                                        leadok<=1;
                                end
                                else begin
                                        leadok<=0;
                                end
                        end
                        else begin
                                leadok<=0;
                        end
                end
                else begin
                        leadok<=0;
                end
        end
end

always@(posedge CLOCK_50 or negedge RSTN) //check lead code time
begin
        if(!RSTN) begin
                repeat_ok<=0;
        end
        else begin
                if(state==leader_check) begin
                        if(ir_n) begin
                                if((lead_cnt > repeat_code)&&(lead_cnt < 618750))
                                begin
                                        repeat_ok<=1;
                                end
                                else begin
                                        repeat_ok<=0;
                                end
                        end
                        else begin
                                repeat_ok<=0;
                        end
                end
                else begin
                        repeat_ok<=0;
                end
        end
end


always@(posedge CLOCK_50 or negedge RSTN) begin //data counter
        if(!RSTN)begin
                data_cnt<=0;
        end
        else begin
                if(state==receive)begin
                        if(ir_n)begin
                                data_cnt<=0;
                        end
                        else begin
                                data_cnt<=data_cnt+1;
                        end
                end
                else begin
                        data_cnt<=0;
                end
        end
end
always@(posedge CLOCK_50 or negedge RSTN) // decide data '1' or '0'
begin
        if(!RSTN)begin
                data_error<=0;
        end
        else begin
                if(state==receive)begin
                        if(ir_n)begin
                                if((data_cnt>=low_time)&&(data_cnt<61600))
                                begin
                                        ir_data[bitcount]<=1'h0;
                                                        
                                end
                                else if((data_cnt>=high_time)&&(data_cnt<135750))
                                begin
                                        ir_data[bitcount]<=1'h1;
                                                        
                                end
                                else begin
                                        ir_data<=0;
                                        data_error<=1;
                                end
                        end
                        else begin
                                ir_data<=ir_data;
                                data_error<=0;
                        end
                end
                else begin
                        ir_data<=ir_data;
                        data_error<=0;
                end
        end
end
always@(posedge CLOCK_50 or negedge RSTN) begin //bitcounter
        if(!RSTN)begin
                bitcount<=0;
        end
        else begin
                if(state==receive)begin
                        if(ir_n)begin
                                        bitcount<=bitcount+1;
                        end
                        else begin
                                bitcount<=bitcount;
                        end
                end
                else begin
                        bitcount<=0;
                end
        end
end
always@(posedge CLOCK_50 or negedge RSTN)//check receive data finish
begin
        if(!RSTN)begin
                data_rece_finish<=0;
        end
        else begin
                if(bitcount==31&&ir_n)begin
                        data_rece_finish<=1;
                end
                else begin
                        data_rece_finish<=0;
                end
        end
end
always@(posedge CLOCK_50 or negedge RSTN) //check data to output
begin
        if(!RSTN) output_buf<=0;
        else begin
                if(state==data_check_latch)begin
                        if(ir_data[31:24]==~ir_data[23:16]) begin
                                output_buf<=ir_data;
                        end
                        else begin
                                output_buf<=output_buf;
                        end
                end
                else begin
                        output_buf<=output_buf;
                end
        end
end


endmodule
