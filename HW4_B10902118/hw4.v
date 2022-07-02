module lab4 (
    input CLOCK_50,
    input RST_n,

    output [3:0] KEY_SCAN,
    input [3:0] KEY_READ,

    output IRDA_TXD
);

    //sfr_bus
    wire [7:0] sfr_addr, sfr_data_in, sfr_data_out;
    wire sfr_wr,sfr_rd;
	
	//internal RAM wire declare
	wire [7:0] iram_addr, iram_data_out, iram_data_in;
	wire iram_rd_n, iram_we1_n, iram_we2_n;

	//internal ROM wire declare
	wire [15:0] irom_addr; 
	wire [7:0] irom_data_out; 
	wire irom_rd_n, irom_cs_n; 


    wire reset_n = RST_n;

	DW8051_core CPU(
		
		//System
		.clk(CLOCK_50),
		.por_n(reset_n),
		.rst_in_n(reset_n),

		//Config
		.test_mode_n (1'b1), 
		.mem_ea_n (1'b1),
	
		//SFR_Ctrl
		.sfr_wr(sfr_wr),
		.sfr_rd(sfr_rd),
	
		//SFR_Data
		.sfr_addr(sfr_addr),
		.sfr_data_out(sfr_data_out),
		.sfr_data_in(sfr_data_in),
	
		//IRAM
		.iram_addr (iram_addr),
		.iram_data_out (iram_data_out), 
		.iram_data_in (iram_data_in), 
		.iram_rd_n (iram_rd_n), 
		.iram_we1_n (iram_we1_n),
		.iram_we2_n (iram_we2_n),
		
		//IROM
		.irom_addr (irom_addr), 
		.irom_data_out (irom_data_out), 
		.irom_rd_n (irom_rd_n), 
		.irom_cs_n (irom_cs_n)
		
	);

    wire [7:0] sfr_data_in_ir, sfr_data_in_key;
    assign sfr_data_in = (sfr_addr >= 8'hEA && sfr_addr <= 8'hEC) ? sfr_data_in_key : sfr_data_in_ir;


    //internal RAM
	int_mem u3_int_mem(

		.clk(CLOCK_50),

		.addr(iram_addr),

		.data_in(iram_data_in),
		.data_out(iram_data_out),

		.we1_n(iram_we1_n),
		.we2_n(iram_we2_n),

		.rd_n(iram_rd_n)
	); 

    //internal ROM
	rom_mem u4_rom_mem(
		.addr(irom_addr),
		.data_out(irom_data_out),
		.rd_n(irom_rd_n),
		.cs_n(irom_cs_n)
	);

    //Key_CTRL
    KEY_CTRL KEY_CTRL(
        .clk(CLOCK_50),
        .reset_n(RST_n),

        .sfr_addr(sfr_addr),
        .sfr_data_in(sfr_data_in_key),
        .sfr_data_out(sfr_data_out),

        .sfr_rd(sfr_rd),
        .sfr_wr(sfr_wr),

        .key_scan(KEY_SCAN),
        .key_read(KEY_READ)
    );

    //IR_CTRL
    IR_CTRL IR_CTRL(

        .clk(CLOCK_50),
        .reset_n(RST_n),

        .sfr_rd(sfr_rd),
        .sfr_wr(sfr_wr),

        .sfr_addr(sfr_addr),
        .sfr_data_in(sfr_data_in_ir),
        .sfr_data_out(sfr_data_out),

        .IRDA_TXD(IRDA_TXD)

    );


endmodule