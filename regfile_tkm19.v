module regfile_tkm19(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output[31:0] data_readRegA, data_readRegB;
	wire [31:0] oneHot1, oneHot2, oneHot3, canReadReg;
	wire [1023:0] toMux;
	
	decoder32 dec1(oneHot1, ctrl_writeReg, ctrl_writeEnable);
	decoder32 dec2(oneHot2, ctrl_readRegA, 1'b1);
	decoder32 dec3(oneHot3, ctrl_readRegB, 1'b1);
	assign canReadReg = oneHot2 | oneHot3;
	
	register reg0(32'b0, clock, ctrl_reset, 1'b0, canReadReg[0], toMux[31:0]);
	
	genvar i;
	generate	
		for(i=1; i<32; i=i+1) begin: loopA
			register registers(data_writeReg, clock, ctrl_reset, oneHot1[i], canReadReg[i], toMux[32*i+31:32*i]);
		end
	endgenerate
		
	mux32 m1(data_readRegA, toMux, ctrl_readRegA);
	mux32 m2(data_readRegB, toMux, ctrl_readRegB);	
endmodule
