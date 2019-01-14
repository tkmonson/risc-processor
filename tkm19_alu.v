module tkm19_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	wire EQ0, GT0, EQorGT;
	wire [31:0] addSubResult, andResult, orResult, shiftResult, xorResult, res;
	
	compare32 comparator(data_operandA, data_operandB, 1'b1, 1'b0, EQ0, GT0);
	or  eqgt(EQorGT, EQ0, GT0);
	not neq(isNotEqual, EQ0);
	not lt(isLessThan, EQorGT);
	
	adder32 adderSubtractor(data_operandA, data_operandB, ctrl_ALUopcode[0], addSubResult, /*cout*/, ctrl_ALUopcode[0], overflow, 1'b1);
	
	and32 ander(andResult, data_operandA, data_operandB);
	or32  orer(orResult, data_operandA, data_operandB);
	
	shifter barrelShifter(shiftResult, data_operandA, ctrl_ALUopcode[0], ctrl_shiftamt);
	
	xor32 xorer(xorResult, data_operandA, data_operandB);
	
	mux8 whichOp(res, {shiftResult, shiftResult, orResult, andResult, addSubResult, addSubResult}, ctrl_ALUopcode[2:0]);
	assign data_result = ctrl_ALUopcode[3] ? xorResult : res;
endmodule
