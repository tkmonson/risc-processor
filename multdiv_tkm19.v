module multdiv_tkm19(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_inputRDY, data_resultRDY);
   input  [31:0] data_operandA;
   input  [31:0] data_operandB;
   input         ctrl_MULT, ctrl_DIV, clock;             
   output [31:0] data_result; 
   output        data_exception, data_inputRDY, data_resultRDY;
	wire   [31:0] product, quotient, opA, opB;
	wire          overflow, div0, prodRDY, quotRDY, reset, multiplying, dividing, newop, opclk;
	
	assign data_inputRDY = 1'b1;
	or res(reset, ctrl_MULT, ctrl_DIV);
	
	xor new_op(newop, ctrl_MULT, ctrl_DIV);
	and oc    (opclk, newop, clock);
	
	cycle32 A(data_operandA, opA, opclk);
	cycle32 B(data_operandB, opB, opclk);	
	
	mult multiplier (opA, opB, clock, reset, product,  overflow, prodRDY);
	div  divider    (opA, opB, clock, reset, quotient, div0,     quotRDY);
	
	SR m(ctrl_MULT, ctrl_DIV, multiplying, /*Qbar*/);
	SR d(ctrl_DIV, ctrl_MULT, dividing, /*Qbar*/);
	
	mux4_1b exception (data_exception, {1'b0,  overflow, div0,      1'b0}, {multiplying, dividing});
	mux4_1b resRDY    (data_resultRDY, {1'b0,  prodRDY,  quotRDY,   1'b0}, {multiplying, dividing});
	mux4    result    (data_result,    {32'b0, product,  quotient, 32'b0}, {multiplying, dividing});
	
endmodule
