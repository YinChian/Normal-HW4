module KEY_CTRL (
    input clk,
    input reset_n,

    input [7:0] sfr_addr,
    input [7:0] sfr_data_out,
    output reg [7:0] sfr_data_in,
    input sfr_rd,
    input sfr_wr,

    output reg [3:0] key_scan,
    input [3:0] key_read
); 

parameter key_control_byte = 8'hEA;
parameter key_map_1_byte = 8'hEB;
parameter key_map_2_byte = 8'hEC;

reg [2:0] key_state;
reg [7:0] key_sfr_mem [8'hEC:8'hEA];
reg [3:0] key_mem [3:0];
reg [13:0] counter_250u;
wire key_timeout;
wire key_en = key_sfr_mem[key_control_byte][0];
wire key_pressed = key_mem[0] != 3'd0 || key_mem[1] != 3'd0 || key_mem[2] != 3'd0 || key_mem[3] != 3'd0;
wire key_changed;

//SFR --read
always @(*) begin
    if(sfr_rd && sfr_addr >= key_control_byte && sfr_addr <= key_map_2_byte) begin
        sfr_data_in = key_sfr_mem[sfr_addr];
    end
    else sfr_data_in = 8'd0;
end

//SFR -- write
always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
        key_sfr_mem[key_control_byte] <= 8'h0;
        key_sfr_mem[key_map_1_byte]   <= 8'h0;
        key_sfr_mem[key_map_2_byte]   <= 8'h0;
    end

    else if(key_timeout)begin
        key_sfr_mem[key_control_byte][5] <= 1'd1;
    end
    
    else if(key_changed) begin
        key_sfr_mem[key_control_byte][4] <= 1'd1;
    end
    else if(sfr_wr && sfr_addr >= key_control_byte && sfr_addr <= key_map_2_byte) begin
        key_sfr_mem[sfr_addr] <= sfr_data_out;
    end

    //做完即清除
    else if(sfr_rd && sfr_addr == key_control_byte)begin
        key_sfr_mem[key_control_byte] <= key_sfr_mem[key_control_byte] & 8'd1; //清除enable以外的腳
    end

    //按鈕變更
    else if(key_pressed)begin
        {key_sfr_mem[key_map_2_byte],key_sfr_mem[key_map_1_byte]} <= {key_mem[3],key_mem[2],key_mem[1],key_mem[0]};
    end

    else begin
        key_sfr_mem[sfr_addr] <= key_sfr_mem[sfr_addr];
    end
end

//Counter -- Scan Freq.
always @(posedge clk, negedge reset_n) begin
    if(!reset_n) counter_250u <= 14'd0;
    else if(key_en) begin
        if(counter_250u == 14'd12_499) counter_250u <= 14'd0;
        else counter_250u <= counter_250u + 14'd1;
    end
    else counter_250u <= 14'd0;
end

//Counter -- Scan Controller
always @(posedge clk,negedge reset_n) begin
    if(!reset_n) key_state <= 3'd0;
    else if(key_en)begin
        if(counter_250u == 14'd12_499)begin
            if(key_state == 3'd3) key_state <= 3'd0;
            else key_state <= key_state + 3'd1;
        end
        else begin
            key_state <= key_state;
        end
    end
    else key_state <= 3'd0;
end

//Output
always@(*)begin
    if(key_en && counter_250u == 14'd12_499) begin
        key_scan[key_state] = 1'd1;
    end
    else key_scan = 4'd0;
end

//key_mem
always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
        key_mem[0] <= 3'd0;
        key_mem[1] <= 3'd0;
        key_mem[2] <= 3'd0;
        key_mem[3] <= 3'd0;
    end
    else if(key_en) begin
        if(counter_250u == 14'd12_499) key_mem[key_state] <= key_read;
        else key_mem[key_state] <= key_mem[key_state];
    end
    else begin
        key_mem[0] <= 3'd0;
        key_mem[1] <= 3'd0;
        key_mem[2] <= 3'd0;
        key_mem[3] <= 3'd0;
    end
end

//debounce
debounce deb(
    .CLOCK_50(clk),
    .reset_n(reset_n),
    .btn_i(~key_pressed),
    .btn_o(key_changed)
);

//repeat code
pass_counter pass_counter(
    .CLOCK_50(clk),
    .reset_n(reset_n),
    .reset(key_changed),
    .btn_i(~key_pressed),
    .btn_o(key_timeout)
);
    
endmodule