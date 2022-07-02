module debounce(

	input 	CLOCK_50,
	input 	reset_n,
	input 	btn_i,
	
	output 	btn_o
	
);
	
	reg [19:0] counter;
	
	
	always @(posedge CLOCK_50,negedge reset_n) begin
		if(!reset_n) counter <= 20'd0;
		else begin
			if(!btn_i) begin
				if(counter == 20'd750_000)	counter <= 20'd750_000;
				else counter <= counter + 20'd1;
			end
			else begin
				counter <= 20'd0;
			end
		end
	end
	
	assign btn_o = (counter == 20'd749_999);
	
endmodule 