module skeleton(resetn, 
	PS2_CLK, PS2_DAT, 	   									// ps2 related I/O
	debug_data_in, debug_addr,       						// extra debugging ports
	effect,
	// Inputs
	KEY,
	/*SW*/,
	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,
	
	I2C_SCLK,															
	CLOCK_50,
	/*ps2_out*/,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	LEDR, LEDG,
	GPIO_0, GPIO_1/*,
	test_f, test_d_orig, test_d_act, test_x, test_m, test_w, is_reg30, out_freq*/);	
	
	////////////////////////	AUDIO	////////////////////////////
	input				   CLOCK_50;
	input		[3:0]	   KEY;
	input 	[3:0]    effect;
	

	input				AUD_ADCDAT;

	input [35:0] GPIO_0, GPIO_1; 
	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;
   wire   	[17:0]	freq;
	output				I2C_SCLK;
	//output   [17:0]   out_freq;
	//assign out_freq = freq;
	
	//output [31:0] test_f, test_d_orig, test_d_act, test_x, test_m, test_w;
	//output is_reg30;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output [8:0] LEDG;
	output [17:0] LEDR;
	
	audio3 ac (CLOCK_50, /*CLOCK_27*/, KEY, freq,
	           HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, /*HEX6*/, /*HEX7*/,
			     /*LEDG*/, LEDR,
			     /*TD_RESET*/, I2C_SDAT, I2C_SCLK,
			     AUD_ADCLRCLK, AUD_ADCDAT, AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, AUD_XCK,
			     GPIO_0, GPIO_1);
	
	
	////////////////////////	PS2	////////////////////////////
	input 			resetn;
	inout 			PS2_DAT, PS2_CLK;
	
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 	[31:0] 	debug_data_in;
	output   [11:0]   debug_addr;
	
	wire			    clock;
	wire		[7:0]	 ps2_key_data;
	wire			 	 ps2_key_pressed;
	wire    	[7:0]	 ps2_out;	
	
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	assign clock = CLOCK_50;
	
	// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
	//assign clock = inclock;
	
	// your processor
	processor_tkm19 myprocessor(clock, ~resetn, /*ps2_key_pressed*/ debounced_ps2, debug_data_in, debug_addr/*, test_f, test_d_orig, test_d_act, test_x, test_m, test_w, is_reg30*/, freq, effect);
	
	
	// keyboard controller
	PS2_Interface myps2(clock, resetn, PS2_CLK, PS2_DAT, ps2_key_data, ps2_key_pressed, ps2_out);
	
	wire [7:0] debounced_ps2;
	ps2_fsm my_ps2_fsm(ps2_key_pressed, clock, ~resetn, ps2_out, debounced_ps2, effect[3]);
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex6(ps2_out[3:0], HEX6);
	Hexadecimal_To_Seven_Segment hex7(ps2_out[7:4], HEX7);
	
endmodule



module ps2_fsm(key_pressed, clock, reset, in, out, perc);
	input key_pressed, clock, reset, perc;
	input [7:0] in;
	output [7:0] out;
	reg [7:0] out;
	reg [31:0] counter = 1'b0;
	reg stop_playing = 1'b0;
	reg [7:0] previous_key = 8'h00;
	reg prevF;

	always @ (posedge clock) begin
	
		if (reset) begin
			out = 8'b0;
			stop_playing = 1'b0;
			counter = 1'b0;
		end
		
		else if (in == 8'h1A || in == 8'h1B || in == 8'h22 || in == 8'h23 ||
		         in == 8'h21 || in == 8'h2A || in == 8'h34 || in == 8'h32 ||
					in == 8'h33 || in == 8'h31 || in == 8'h3B || in == 8'h3A )  begin
		
			if(perc) begin
				if(~stop_playing) begin
					out = in;
					counter = 1'b0;
					previous_key = in;
				end
				out = 8'b0;
			end
			
			else begin
				if(~stop_playing) begin
					out = in;
					counter = 1'b0;
					previous_key = in;
				end
				else begin
					out = 8'b0;
				end
			end
			
		end
				
		else if (in == 8'hF0) begin 
			stop_playing = 1'b1;
			out = previous_key;
			prevF = 1'b1;
		end
		
		else begin
			out = 8'b0;
			counter = 1'b0;
			previous_key = in;
		end
		
		counter = counter + 1;
		
		if(counter >= 20) begin
			prevF = 1'b0;
			if(in != previous_key) begin // new key is pressed
				stop_playing = 1'b0;
				counter = 1'b0;
			end
			counter = 1'b0;
		end
		
		if(key_pressed && !prevF) begin
			stop_playing = 1'b0;
			counter = 1'b0;
		end
		
	end

endmodule
