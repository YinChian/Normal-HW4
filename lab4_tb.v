`timescale 1ns/1ns

module lab4_tb;

parameter DATA_HI_PERIOD   = 21; // 560us
parameter DATA0_LO_PERIOD  = 21; // 21*26.315=560us
parameter DATA1_LO_PERIOD  = 64; // 64*26.315=1684us

reg clk_50M;
reg reset_n;
wire [3:0] key;
reg ir;

wire [3:0] key_read;
wire [3:0] key_scan;

wire       ir_tx;
reg        ir_en;
reg        clk_38K;
reg  [15:0] ir_tx_enlop_cnt;
reg        ir_tx_enlop;
reg        ir_tx_d1;
reg        ir_tx_d2;
wire       ir_tx_pos;
reg        k0_ctrl;
reg        k1_ctrl;
reg        k2_ctrl;
reg        k3_ctrl;
reg        k4_ctrl;
reg        k5_ctrl;
reg        k6_ctrl;
reg        k7_ctrl;
reg        k8_ctrl;
reg        k9_ctrl;
reg        k10_ctrl;
reg        k11_ctrl;
reg        k12_ctrl;
reg        k13_ctrl;
reg        k14_ctrl;
reg        k15_ctrl;
wire       ir_tx_enlop_rev;

pulldown(key_read[0]);
pulldown(key_read[1]);
pulldown(key_read[2]);
pulldown(key_read[3]);

tranif1( key_read[0] , key_scan[0], k0_ctrl);
tranif1( key_read[1] , key_scan[0], k1_ctrl);
tranif1( key_read[2] , key_scan[0], k2_ctrl);
tranif1( key_read[3] , key_scan[0], k3_ctrl);
tranif1( key_read[0] , key_scan[1], k4_ctrl);
tranif1( key_read[1] , key_scan[1], k5_ctrl);
tranif1( key_read[2] , key_scan[1], k6_ctrl);
tranif1( key_read[3] , key_scan[1], k7_ctrl);
tranif1( key_read[0] , key_scan[2], k8_ctrl);
tranif1( key_read[1] , key_scan[2], k9_ctrl);
tranif1( key_read[2] , key_scan[2], k10_ctrl);
tranif1( key_read[3] , key_scan[2], k11_ctrl);
tranif1( key_read[0] , key_scan[3], k12_ctrl);
tranif1( key_read[1] , key_scan[3], k13_ctrl);
tranif1( key_read[2] , key_scan[3], k14_ctrl);
tranif1( key_read[3] , key_scan[3], k15_ctrl);

lab4 lab4(
        //////// CLOCK //////////
        .CLOCK_50(clk_50M),
        .RST_n(reset_n),
        //////// LCM //////////
        .KEY_SCAN(key_scan),
        .KEY_READ(key_read),
        //////// IR Tx //////////
        .IRDA_TXD(ir_tx)                      
        );  

IR_RX IR_RX(
            .CLOCK_50(clk_50M), 
            .RSTN(reset_n), 
            .IRDA_RXD(ir_tx_enlop_rev), 
            .DATA()            
            );
always
  #10 clk_50M = ~clk_50M;

//always
//  #13157 clk_38K = ~clk_38K;   // 38KHz 
  
always@(posedge clk_50M)
  begin
  if(lab4_tb.IR_RX.state == 2'b11)
    $display("time=%3d IR data = %x,%x,%x,%x ", $time,lab4_tb.IR_RX.ir_data[7:0],lab4_tb.IR_RX.ir_data[15:8],lab4_tb.IR_RX.ir_data[23:16],lab4_tb.IR_RX.ir_data[31:24]);
  if(lab4_tb.IR_RX.repeat_ok)
    $display("time=%3d IR repeat code = %x.", $time,lab4_tb.IR_RX.repeat_ok);  
  end
    

assign ir_tx_pos =  ir_tx_d1 & ~ir_tx_d2;    
always@(posedge clk_50M)
  begin
  ir_tx_d1 <= ir_tx;
  ir_tx_d2 <= ir_tx_d1;
  end 
 
always@(posedge clk_50M)
  begin
  if(ir_tx_pos) 
    begin
     ir_tx_enlop_cnt <= 0;
     ir_tx_enlop <= 1;
    end
  else 
    begin
    if(ir_tx_enlop_cnt < 1500)  // 20ns*1500 =  30us timeout
      ir_tx_enlop_cnt <= ir_tx_enlop_cnt + 1;
    else
      ir_tx_enlop <= 0; 
    end
  end

assign ir_tx_enlop_rev = !ir_tx_enlop;
  
//assign ir_tx = ir_en ? clk_38K : 1'b0;

 
initial
  begin
  //$dumpfile("lab4_tb.vcd");  
  //$dumpvars;
      
  reset_n = 1;  
  clk_50M = 0 ;
  clk_38K = 0;
  ir_en = 0;
  ir_tx_enlop = 0;
  ir_tx_enlop_cnt = 0;
  //force key_scan = 4'h0;
  k0_ctrl = 0;
  k1_ctrl = 0;
  k2_ctrl = 0;
  k3_ctrl = 0;
  k4_ctrl = 0;
  k5_ctrl = 0;
  k6_ctrl = 0;
  k7_ctrl = 0;
  k8_ctrl = 0;
  k9_ctrl = 0;
  k10_ctrl = 0;
  k11_ctrl = 0;
  k12_ctrl = 0;
  k13_ctrl = 0;
  k14_ctrl = 0;
  k15_ctrl = 0;  
  
  #40 reset_n = 0; 
  
  #30 reset_n = 1;
 ////////////////////////
  #1_000_000;
  k0_ctrl = 1;   // press KEY 0
  #10_000_000;   // 10ms  
  k0_ctrl = 0;   // release KEY 0
 //////////////////////// 
  #1_000_000;
  k6_ctrl = 1;   // press KEY 6
  #20_000_000;   // 20ms  
  k6_ctrl = 0;   // release KEY 6  
 ////////////////////////
  wait(lab4_tb.IR_RX.state == 2'b11); // wait IR TX send end
  //////////////////////
  #3_000_000;
  k9_ctrl = 1;   // press KEY 9
  #150_000_000;  // 150ms  
  k9_ctrl = 0;   // release KEY 9 
  /////////////////////
  #1_000_000;
  
  $finish;
  end
  
  
task send_ir_leader;  
 begin
  ir_en = 1;
  repeat(342)@(posedge clk_38K); // 9ms  , 342*26.315us = 9ms 
  ir_en = 0;
  repeat(171)@(posedge clk_38K); // 
  end
endtask 

task send_ir_repeat;  
 begin
  ir_en = 1;
  repeat(342)@(posedge clk_38K); // 9ms  , 342*26.315us = 9ms 
  
  ir_en = 0;
  repeat(85)@(posedge clk_38K); // 2.25ms
  
  ir_en = 1;
  repeat(DATA_HI_PERIOD)@(posedge clk_38K); // 560us
  ir_en = 0; 
  end
endtask 


task send_ir_byte;
  input [7:0] byte;
  integer i;
  begin
  $display("send ir = %x ",byte);
  for (i=0; i<8; i=i+1) 
     begin 
     ir_en = 1;
     repeat(DATA_HI_PERIOD)@(posedge clk_38K); //
     ir_en = 0;
     if(byte[0])
       repeat(DATA1_LO_PERIOD)@(posedge clk_38K); //
     else
       repeat(DATA0_LO_PERIOD)@(posedge clk_38K); // 
     byte = byte >> 1;       
     end      
  end   
endtask 

task send_ir_end;  
 begin
  ir_en = 1;
  repeat(DATA_HI_PERIOD)@(posedge clk_38K); //
  ir_en = 0;
 end
endtask
  
endmodule
