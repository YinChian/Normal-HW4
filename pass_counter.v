module pass_counter(

	input 	CLOCK_50,
	input 	reset_n,
	input 	btn_i,
	input 	reset,
	
	output 	btn_o
	
);
	
	reg [22:0] counter;
	
	
	always @(posedge CLOCK_50,negedge reset_n) begin
		if(!reset_n) counter <= 23'd0;
		else begin
			if(reset)	begin
				counter <= 23'd0;
			end
			else if(!btn_i) begin
				if(counter == 23'd5_500_000)	counter <= 23'd0;
				else counter <= counter + 23'd1;
			end
			else begin
				counter <= 23'd0;
			end
		end
	end
	
	assign btn_o = (counter == 23'd5_500_000);
	
endmodule 