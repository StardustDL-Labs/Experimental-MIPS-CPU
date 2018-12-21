
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

`include "./defines.v"

module mips32(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// Seg7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT
);

wire [`Addr_Width-1:0] db_maddr = {{22{1'b0}},SW};
wire [`Data_Width-1:0] db_memdata;
wire [`Byte_Width-1:0] db_mdata;
wire [`Inst_Width-1:0] db_instr;
wire [2:0] db_valFrom;
wire db_count;

reg coreClk = 0;

// assign LEDR = {coreClk,{1{1'b0}},db_mdata};
// assign LEDR = db_pc[9:0];
assign LEDR[9] = db_count;

show2h s1pc0(
	.en(1),
	.m(db_mdata[7:0]),
	.hex1(HEX1),
	.hex0(HEX0)
);
show2h s1pc1(
	.en(1),
	.m(db_memdata[7:0]),
	.hex1(HEX3),
	.hex0(HEX2)
);
show2h s1m(
	.en(1),
	.m(db_memdata[23:16]),
	.hex1(HEX5),
	.hex0(HEX4)
);

assign db_clear = ~KEY[1];
assign en = 1;

Core core(
	.clock(coreClk),
	.db_clear(db_clear),
	.db_maddr(db_maddr),
	.db_mdata(db_mdata),
	.db_instr(db_instr),
	.db_memdata(db_memdata),
	.db_valFrom(db_valFrom),
	.db_count(db_count)
);

clkgen #(100) cgvag_1(
	.clkin(CLOCK_50),
	.rst(db_clear),
	.clken(en),
	.clkout(coreClk)
);

/*always @ (posedge KEY[0]) begin
	coreClk = 0;
	#100;
	for (integer i = 0; i < 25*2; i=i+1) begin
	  	coreClk = ~coreClk;
		#100;
	end
end*/

endmodule

module show2h(en,m,hex1,hex0);
	input en;
	input [7:0] m;
	output [6:0] hex0;
    output [6:0] hex1;
	
    show1h ls1_0(en, m[3:0], hex0);
    show1h ls1_1(en, m[7:4], hex1);
endmodule

module show1h(en,m,f);
	input en;
	input [3:0] m;
	output reg [6:0] f;
	
	always @(m or en)
		begin
		if (en==1)
			begin
			case (m)
				0: f=7'b1000000;
				1: f=7'b1111001;
				2: f=7'b0100100;
				3: f=7'b0110000;
				4: f=7'b0011001;
				5: f=7'b0010010;
				6: f=7'b0000010;
				7: f=7'b1111000;
				8: f=7'b0000000;
				9: f=7'b0010000;
                10: f=7'b0001000;
                11: f=7'b0000000;
                12: f=7'b1000110;
                13: f=7'b1000000;
                14: f=7'b0000110;
                15: f=7'b0001110;
				default: f=7'b1111111;
			endcase
			end
		else
			begin
			f = 7'b1111111;
			end
		end
endmodule

module clkgen(clkin, rst, clken, clkout);
    input clkin, rst, clken;
    output reg clkout;

    parameter clk_freq = 1000;
    parameter countlimit = 50000000/2/clk_freq;

    reg [31:0] clkcount;

    always @ (posedge clkin)
        if(rst) begin
            clkcount = 0;
            clkout = 1'b0;
        end
        else begin
            if (clken) begin
                clkcount = clkcount + 1;
                if (clkcount >= countlimit) begin
                    clkcount = 32'd0;
                    clkout = ~clkout;
                end
                else 
                    clkout = clkout;
            end
            else begin
                clkcount = clkcount;
                clkout = clkout;
            end
        end
endmodule