    
	 // ALU OPERATIONS //

module adder32(x, y, cin, s, cout, sub, overflow, en);
	input  [31:0] x, y;
	input         cin, sub, en;
	output [31:0] s;
	output        cout, overflow;
	wire   [31:0] sol;
	wire   [7:0]  c;
	wire          oflow;

	adder4 block0(x[3:0],  y[3:0],  cin, sol[3:0],  c[0], sub);
	adder4 block1(x[7:4],  y[7:4],  c[0],sol[7:4],  c[1], sub);
	adder4 block2(x[11:8], y[11:8], c[1],sol[11:8], c[2], sub);
	adder4 block3(x[15:12],y[15:12],c[2],sol[15:12],c[3], sub);
	adder4 block4(x[19:16],y[19:16],c[3],sol[19:16],c[4], sub);
	adder4 block5(x[23:20],y[23:20],c[4],sol[23:20],c[5], sub);
	adder4 block6(x[27:24],y[27:24],c[5],sol[27:24],c[6], sub);
	adder4 block7(x[31:28],y[31:28],c[6],sol[31:28],c[7], sub);
	
	xor of(oflow, c[6], c[7]);
	
	assign s = en ? sol : x;
	assign cout = en ? c[7] : cin;
	assign overflow = en ? oflow : 1'b0;
endmodule

module adder4(x,Y,cin,s,cout,sub);
	input  [3:0] x, Y;
	input        cin, sub;
	output [3:0] s;
	output       cout;
	wire   [3:0] g, p, y;
	wire   [3:1] c;
	wire   [9:0] z;
	
	xor xor_neg0(y[0], Y[0], sub);
	xor xor_neg1(y[1], Y[1], sub);
	xor xor_neg2(y[2], Y[2], sub);
	xor xor_neg3(y[3], Y[3], sub);

	and and_g0(g[0],x[0],y[0]);
	or  or_p0 (p[0],x[0],y[0]);
	and and_z0(z[0],p[0],cin);
	or  or_c1 (c[1],g[0],z[0]);
	xor xor_s0(s[0],x[0],y[0],cin);

	and and_g1(g[1],x[1],y[1]);
	or  or_p1 (p[1],x[1],y[1]);
	and and_z1(z[1],p[1],p[0],cin);
	and and_z2(z[2],p[1],g[0]);
	or  or_c2 (c[2],g[1],z[2],z[1]);
	xor xor_s1(s[1],x[1],y[1],c[1]);

	and and_g2(g[2],x[2],y[2]);
	or  or_p2 (p[2],x[2],y[2]);
	and and_z3(z[3],p[2],p[1],p[0],cin);
	and and_z4(z[4],p[2],p[1],g[0]);
	and and_z5(z[5],p[2],g[1]);
	or  or_c3 (c[3],g[2],z[5],z[4],z[3]);
	xor xor_s2(s[2],x[2],y[2],c[2]);

	and and_g3(g[3],x[3],y[3]);
	or  or_p3 (p[3],x[3],y[3]);
	and and_z6(z[6],p[3],p[2],p[1],p[0],cin);
	and and_z7(z[7],p[3],p[2],p[1],g[0]);
	and and_z8(z[8],p[3],p[2],g[1]);
	and and_z9(z[9],p[3],g[2]);
	or  or_c4 (cout,g[3],z[9],z[8],z[7],z[6]);
	xor xor_s3(s[3],x[3],y[3],c[3]);
endmodule

module compare32(A,B,EQ1,GT1,EQ0,GT0);
	input [31:0] A, B;
	input        EQ1, GT1;
	output       EQ0, GT0;
	wire  [15:1] EQs, GTs;

	compare2 block15(A[30],A[31],B[30],B[31],EQ1,    GT1,    EQs[15],GTs[15]);
	compare2 block14(A[28],A[29],B[28],B[29],EQs[15],GTs[15],EQs[14],GTs[14]);
	compare2 block13(A[26],A[27],B[26],B[27],EQs[14],GTs[14],EQs[13],GTs[13]);
	compare2 block12(A[24],A[25],B[24],B[25],EQs[13],GTs[13],EQs[12],GTs[12]);
	compare2 block11(A[22],A[23],B[22],B[23],EQs[12],GTs[12],EQs[11],GTs[11]);
	compare2 block10(A[20],A[21],B[20],B[21],EQs[11],GTs[11],EQs[10],GTs[10]);
	compare2 block9 (A[18],A[19],B[18],B[19],EQs[10],GTs[10],EQs[9], GTs[9]);
	compare2 block8 (A[16],A[17],B[16],B[17],EQs[9], GTs[9], EQs[8], GTs[8]);
	compare2 block7 (A[14],A[15],B[14],B[15],EQs[8], GTs[8], EQs[7], GTs[7]);
	compare2 block6 (A[12],A[13],B[12],B[13],EQs[7], GTs[7], EQs[6], GTs[6]);
	compare2 block5 (A[10],A[11],B[10],B[11],EQs[6], GTs[6], EQs[5], GTs[5]);
	compare2 block4 (A[8], A[9], B[8], B[9], EQs[5], GTs[5], EQs[4], GTs[4]);
	compare2 block3 (A[6], A[7], B[6], B[7], EQs[4], GTs[4], EQs[3], GTs[3]);
	compare2 block2 (A[4], A[5], B[4], B[5], EQs[3], GTs[3], EQs[2], GTs[2]);
	compare2 block1 (A[2], A[3], B[2], B[3], EQs[2], GTs[2], EQs[1], GTs[1]);
	compare2 block0 (A[0], A[1], B[0], B[1], EQs[1], GTs[1], EQ0,    GT0);
endmodule

module compare2(A0,A1,B0,B1,EQ1,GT1,EQ0,GT0);
	input      A0, A1, B0, B1, EQ1, GT1;
	output     EQ0, GT0;
	wire       notB0, maybeEQ0, maybeGT0;
	wire [2:0] select;
	wire [7:0] EQInputs, GTInputs;
	
	not n1(notB0, B0);
	
	assign select = {A1,A0,B1};
	assign EQInputs = {B0,1'b0,notB0,1'b0,1'b0,B0,1'b0,notB0};
	assign GTInputs = {notB0,1'b1,1'b0,1'b1,1'b0,notB0,1'b0,1'b0};
	
	mux8_1b eq(maybeEQ0, EQInputs, select);
	mux8_1b gt(maybeGT0, GTInputs, select);
	
	and a1(EQ0, maybeEQ0, EQ1);	
	assign GT0 = EQ1 ? maybeGT0 : GT1;
endmodule    
    
module and32(out,A,B);
	input  [31:0] A, B;
	output [31:0] out;
	and a0 (out[0], A[0], B[0]);
	and a1 (out[1], A[1], B[1]);
	and a2 (out[2], A[2], B[2]);
	and a3 (out[3], A[3], B[3]);
	and a4 (out[4], A[4], B[4]);
	and a5 (out[5], A[5], B[5]);
	and a6 (out[6], A[6], B[6]);
	and a7 (out[7], A[7], B[7]);
	and a8 (out[8], A[8], B[8]);
	and a9 (out[9], A[9], B[9]);
	and a10(out[10],A[10],B[10]);
	and a11(out[11],A[11],B[11]);
	and a12(out[12],A[12],B[12]);
	and a13(out[13],A[13],B[13]);
	and a14(out[14],A[14],B[14]);
	and a15(out[15],A[15],B[15]);
	and a16(out[16],A[16],B[16]);
	and a17(out[17],A[17],B[17]);
	and a18(out[18],A[18],B[18]);
	and a19(out[19],A[19],B[19]);
	and a20(out[20],A[20],B[20]);
	and a21(out[21],A[21],B[21]);
	and a22(out[22],A[22],B[22]);
	and a23(out[23],A[23],B[23]);
	and a24(out[24],A[24],B[24]);
	and a25(out[25],A[25],B[25]);
	and a26(out[26],A[26],B[26]);
	and a27(out[27],A[27],B[27]);
	and a28(out[28],A[28],B[28]);
	and a29(out[29],A[29],B[29]);
	and a30(out[30],A[30],B[30]);
	and a31(out[31],A[31],B[31]);
endmodule

module or32(out,A,B);
	input  [31:0] A, B;
	output [31:0] out;
	or o0 (out[0], A[0], B[0]);
	or o1 (out[1], A[1], B[1]);
	or o2 (out[2], A[2], B[2]);
	or o3 (out[3], A[3], B[3]);
	or o4 (out[4], A[4], B[4]);
	or o5 (out[5], A[5], B[5]);
	or o6 (out[6], A[6], B[6]);
	or o7 (out[7], A[7], B[7]);
	or o8 (out[8], A[8], B[8]);
	or o9 (out[9], A[9], B[9]);
	or o10(out[10],A[10],B[10]);
	or o11(out[11],A[11],B[11]);
	or o12(out[12],A[12],B[12]);
	or o13(out[13],A[13],B[13]);
	or o14(out[14],A[14],B[14]);
	or o15(out[15],A[15],B[15]);
	or o16(out[16],A[16],B[16]);
	or o17(out[17],A[17],B[17]);
	or o18(out[18],A[18],B[18]);
	or o19(out[19],A[19],B[19]);
	or o20(out[20],A[20],B[20]);
	or o21(out[21],A[21],B[21]);
	or o22(out[22],A[22],B[22]);
	or o23(out[23],A[23],B[23]);
	or o24(out[24],A[24],B[24]);
	or o25(out[25],A[25],B[25]);
	or o26(out[26],A[26],B[26]);
	or o27(out[27],A[27],B[27]);
	or o28(out[28],A[28],B[28]);
	or o29(out[29],A[29],B[29]);
	or o30(out[30],A[30],B[30]);
	or o31(out[31],A[31],B[31]);
endmodule

module xor32(out,A,B);
	input  [31:0] A, B;
	output [31:0] out;
	xor x0 (out[0], A[0], B[0]);
	xor x1 (out[1], A[1], B[1]);
	xor x2 (out[2], A[2], B[2]);
	xor x3 (out[3], A[3], B[3]);
	xor x4 (out[4], A[4], B[4]);
	xor x5 (out[5], A[5], B[5]);
	xor x6 (out[6], A[6], B[6]);
	xor x7 (out[7], A[7], B[7]);
	xor x8 (out[8], A[8], B[8]);
	xor x9 (out[9], A[9], B[9]);
	xor x10(out[10],A[10],B[10]);
	xor x11(out[11],A[11],B[11]);
	xor x12(out[12],A[12],B[12]);
	xor x13(out[13],A[13],B[13]);
	xor x14(out[14],A[14],B[14]);
	xor x15(out[15],A[15],B[15]);
	xor x16(out[16],A[16],B[16]);
	xor x17(out[17],A[17],B[17]);
	xor x18(out[18],A[18],B[18]);
	xor x19(out[19],A[19],B[19]);
	xor x20(out[20],A[20],B[20]);
	xor x21(out[21],A[21],B[21]);
	xor x22(out[22],A[22],B[22]);
	xor x23(out[23],A[23],B[23]);
	xor x24(out[24],A[24],B[24]);
	xor x25(out[25],A[25],B[25]);
	xor x26(out[26],A[26],B[26]);
	xor x27(out[27],A[27],B[27]);
	xor x28(out[28],A[28],B[28]);
	xor x29(out[29],A[29],B[29]);
	xor x30(out[30],A[30],B[30]);
	xor x31(out[31],A[31],B[31]);
endmodule

    // MULTIPLEXERS //

module mux32(out, x, s);
	input [1023:0] x;
	input [4:0] s;
	output [31:0] out;
	wire [63:0] a;

	mux16 m1(a[63:32], x[1023:512], s[3:0]);
	mux16 m2(a[31:0], x[511:0], s[3:0]);
	mux2 m3(out, a, s[4]);
endmodule	
	
module mux16(out, x, s);
	input [511:0] x;
	input [3:0] s;
	output [31:0] out;
	wire [63:0] a;
	
	mux8 m1(a[63:32], x[511:256], s[2:0]);
	mux8 m2(a[31:0], x[255:0], s[2:0]);
	mux2 m3(out, a, s[3]);
endmodule

module mux8(out, x, s);
	input  [255:0] x;
	input  [2:0]   s;
	output [31:0]  out;
	wire   [63:0]  a;
	
	mux4 m1(a[63:32], x[255:128], s[1:0]);
	mux4 m2(a[31:0], x[127:0], s[1:0]);
	mux2 m3(out, a, s[2]);
endmodule

module mux4(out, x, s);
	input  [127:0] x;
	input  [1:0]   s;
	output [31:0]  out;
	wire   [63:0]  a;
	
	mux2 m1(a[63:32], x[127:64], s[0]);
	mux2 m2(a[31:0], x[63:0], s[0]);
	mux2 m3(out, a, s[1]);
endmodule

module mux2(out, x, s);
	input  [63:0] x;
	input         s;
	output [31:0] out;
	assign out = s ? x[63:32] : x[31:0];
endmodule

module mux8_1b(out, x, s);
	input  [7:0] x;
	input  [2:0] s;
	output       out;
	wire   [1:0] a;
	
	mux4_1b m1(a[1], x[7:4], s[1:0]);
	mux4_1b m2(a[0], x[3:0], s[1:0]);
	mux2_1b m3(out, a, s[2]);
endmodule

module mux4_1b(out, x, s);
	input  [3:0] x;
	input  [1:0] s;
	output       out;
	wire   [1:0] a;
	
	mux2_1b m1(a[1], x[3:2], s[0]);
	mux2_1b m2(a[0], x[1:0], s[0]);
	mux2_1b m3(out, a, s[1]);
endmodule

module mux2_1b(out, x, s);
	input [1:0] x;
	input       s;
	output out;
	assign out = s ? x[1] : x[0];
endmodule

    // SEQUENTIAL LOGIC //

module register(d, clk, clr, in_enable, out_enable, out);
	input [31:0] d;
	input clk, clr, in_enable, out_enable;
	output [31:0] out;
	wire write;
	
	and a(write, clk, in_enable);

	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loopDFFtri
			DFFtri DFFtri1(d[i], write, clr, 1'b0, in_enable, out_enable, out[i]);
		end
	endgenerate
endmodule

module DFFtri(d, clk, clr, pr, in_enable, out_enable, out);
	input d, clk, clr, pr, in_enable, out_enable;
	output out;
	wire q, clrn, prn;
	
	assign clrn = ~clr;
	assign prn = ~pr;
	
	dffe a_dff(.d(d), .clk(clk), .clrn(clrn), .prn(prn), .ena(in_enable), .q(q));
	assign out = out_enable ? q : 1'bz;
endmodule

module counter(out,enable,clk,reset);
	output [5:0] out;
	input enable, clk, reset;
	reg [5:0] out;
	always @(posedge clk)
	if (reset) begin
		out <= 6'b00000;
	end else if (enable) begin
		case(out)
			6'd0: out <= 6'd1;
			6'd1: out <= 6'd2;
			6'd2: out <= 6'd3;
			6'd3: out <= 6'd4;
			6'd4: out <= 6'd5;
			6'd5: out <= 6'd6;
			6'd6: out <= 6'd7;
			6'd7: out <= 6'd8;
			6'd8: out <= 6'd9;
			6'd9: out <= 6'd10;
			6'd10: out <= 6'd11;
			6'd11: out <= 6'd12;
			6'd12: out <= 6'd13;
			6'd13: out <= 6'd14;
			6'd14: out <= 6'd15;
			6'd15: out <= 6'd16;
			6'd16: out <= 6'd17;
			6'd17: out <= 6'd18;
			6'd18: out <= 6'd19;
			6'd19: out <= 6'd20;
			6'd20: out <= 6'd21;
			6'd21: out <= 6'd22;
			6'd22: out <= 6'd23;
			6'd23: out <= 6'd24;
			6'd24: out <= 6'd25;
			6'd25: out <= 6'd26;
			6'd26: out <= 6'd27;
			6'd27: out <= 6'd28;
			6'd28: out <= 6'd29;
			6'd29: out <= 6'd30;
			6'd30: out <= 6'd31;
			6'd31: out <= 6'd62;
			6'd62: out <= 6'd63;
			6'd63: out <= 6'd62;
		endcase
	end
endmodule

module cycle32 (in, out, clock);
	input [31:0] in;
	output [31:0] out;
	input clock;
	reg [31:0] out;
	
	always @(posedge clock) begin
		out <= in;
	end
endmodule

module cycle (in, out, clock);
	input [64:0] in;
	output [64:0] out;
	input clock;
	reg [64:0] out;
	
	always @(posedge clock) begin
		out <= in;
	end
endmodule

module SR(S, R, Q, Qbar);
	input R, S;
	output Q, Qbar;
	nor (Q, R, Qbar);
	nor (Qbar, S, Q);
endmodule

    // SHIFTERS //

module shifter(out, in, SRA, shamt);
	input  [31:0] in;
	input  [4:0]  shamt;
	input         SRA;
	output [31:0] out;
	wire   [31:0] s16, s8, s4, s2;
	
	shift16 block16(s16, in,  SRA, shamt[4]);
	shift8  block8 (s8, s16,  SRA, shamt[3]);
	shift4  block4 (s4,  s8,  SRA, shamt[2]);
	shift2  block2 (s2,  s4,  SRA, shamt[1]);
	shift1  block1 (out, s2,  SRA, shamt[0]);
endmodule

module shift16(out, in, SRA, en);
	input  [31:0] in;
	input         SRA, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRA ? {{16{in[31]}}, in[31:16]} : {in[15:0], {16{1'b0}}};
	assign out = en  ? ans : in;
endmodule

module shift8(out, in, SRA, en);
	input  [31:0] in;
	input         SRA, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRA ? {{8{in[31]}}, in[31:8]} : {in[23:0], {8{1'b0}}};
	assign out = en  ? ans : in;
endmodule

module shift4(out, in, SRA, en);
	input  [31:0] in;
	input         SRA, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRA ? {{4{in[31]}}, in[31:4]} : {in[27:0], {4{1'b0}}};
	assign out = en  ? ans : in;
endmodule

module shift2(out, in, SRA, en);
	input  [31:0] in;
	input         SRA, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRA ? {{2{in[31]}}, in[31:2]} : {in[29:0], {2{1'b0}}};
	assign out = en  ? ans : in;
endmodule

module shift1(out, in, SRA, en);
	input  [31:0] in;
	input         SRA, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRA ? {in[31], in[31:1]} : {in[30:0], 1'b0};
	assign out = en  ? ans : in;
endmodule

module shifterLog(out, in, SRL, shamt);
	input  [31:0] in;
	input  [4:0]  shamt;
	input         SRL;
	output [31:0] out;
	wire   [31:0] s16, s8, s4, s2;
	
	shiftLog16 block16(s16, in,  SRL, shamt[4]);
	shiftLog8  block8 (s8, s16,  SRL, shamt[3]);
	shiftLog4  block4 (s4,  s8,  SRL, shamt[2]);
	shiftLog2  block2 (s2,  s4,  SRL, shamt[1]);
	shiftLog1  block1 (out, s2,  SRL, shamt[0]);
endmodule

module shiftLog16(out, in, SRL, en);
	input  [31:0] in;
	input         SRL, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRL ? {16'b0, in[31:16]} : {in[15:0], 16'b0};
	assign out = en  ? ans : in;
endmodule

module shiftLog8(out, in, SRL, en);
	input  [31:0] in;
	input         SRL, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRL ? {8'b0, in[31:8]} : {in[23:0], 8'b0};
	assign out = en  ? ans : in;
endmodule

module shiftLog4(out, in, SRL, en);
	input  [31:0] in;
	input         SRL, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRL ? {4'b0, in[31:4]} : {in[27:0], 4'b0};
	assign out = en  ? ans : in;
endmodule

module shiftLog2(out, in, SRL, en);
	input  [31:0] in;
	input         SRL, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRL ? {2'b0, in[31:2]} : {in[29:0], 2'b0};
	assign out = en  ? ans : in;
endmodule

module shiftLog1(out, in, SRL, en);
	input  [31:0] in;
	input         SRL, en;
	output [31:0] out;
	wire   [31:0] ans;
	
	assign ans = SRL ? {1'b0, in[31:1]} : {in[30:0], 1'b0};
	assign out = en  ? ans : in;
endmodule

module SRA65(in, out);
	input  [64:0] in;
	output [64:0] out;
	
	assign out = {{2{in[64]}}, in[64:2]};
endmodule

    // MISC //
    
module flagger(in, add, sub, SLL);
	input  [2:0] in;
	output       add, sub, SLL;
	wire         nin0, w0, w1, w2, w3;
	
	not  not0  (nin0, in[2]);
	or   or0   (w0, in[1], in[0]);
	and  and0  (add, nin0, w0);
	nand nand0 (w1, in[1], in[0]);
	and  and1  (sub, w1, in[2]);
	or   or1   (w2, add, sub);
	xnor xnor0 (w3, in[1], in[0]);
	and  and2  (SLL, w2, w3);
endmodule

module decoder32(out, select, enable);
	input [4:0] select;
	input enable;
	output [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loopDecode
			assign out[i] = ((i==select) & enable);
		end
	endgenerate
endmodule

    // MULT/DIV //
    
module div(dividend, d, clock, reset, quotient, Div0, resultRDY);
	input  [31:0] dividend, d;
	output [31:0] quotient;
	input         clock, reset;
	output        Div0, resultRDY;
	wire   [31:0] RQB              [31:0];
	wire   [31:0] RQBShiftedBy       [31:0];
	wire   [31:0] DivisorShiftedBy [31:0];
	wire   [31:0] RQBSub           [31:0];	
	wire   [31:0] GT, nGT, divisor, Q, Q2;
	wire   [5:0]  i;
	wire   [4:0]  Div0Check;
	wire          neg;
	
		// I/O FLAGS //
	counter count(i, 1'b1, clock, reset);
	and resRDY(resultRDY, ~i[5], i[4], i[3], i[2], i[1], i[0]);
	
		// EXCEPTION CHECKING //
	and div0_0(Div0Check[0], ~d[31], ~d[30], ~d[29], ~d[28], ~d[27], ~d[26], ~d[25], ~d[24]);
	and div0_1(Div0Check[1], ~d[23], ~d[22], ~d[21], ~d[20], ~d[19], ~d[18], ~d[17], ~d[16]);
	and div0_2(Div0Check[2], ~d[15], ~d[14], ~d[13], ~d[12], ~d[11], ~d[10],  ~d[9],  ~d[8]); 
	and div0_3(Div0Check[3],  ~d[7],  ~d[6],  ~d[5],  ~d[4],  ~d[3],  ~d[2],  ~d[1],  ~d[0]);
	and div0_4(Div0Check[4], Div0Check[3], Div0Check[2], Div0Check[1], Div0Check[0]);
		
		// SIGN CONVERSION //
	xor negQ(neg, dividend[31], d[31]);
	
	adder32 compA(32'b0, dividend, dividend[31], RQB[31], /*cout*/, dividend[31], /*of*/, 1'b1);
	adder32 compB(32'b0, d, d[31], divisor, /*cout*/, d[31], /*of*/, 1'b1);
	
		// BLOCK 31 //
	shifterLog shRQB31  (RQBShiftedBy[31], RQB[31], 1'b1, 5'b11111);
	compare32  cmp31    (divisor, RQBShiftedBy[31], 1'b1, 1'b0, /*EQ*/, GT[31]);
	assign     Q[31] =   GT[31] ? 1'b0 : 1'b1;
	not        not31    (nGT[31], GT[31]);
	shifterLog shDiv31  (DivisorShiftedBy[31], divisor, 1'b0, 5'b11111);
	adder32    subRQB31 (RQB[31], DivisorShiftedBy[31], 1'b1, RQBSub[31], /*cout*/, 1'b1, /*of*/, nGT[31]);
	cycle32    c31      (RQBSub[31], RQB[30], clock);
	
		// BLOCK 30 //
	shifterLog shRQB30  (RQBShiftedBy[30], RQB[30], 1'b1, 5'b11110);
	compare32  cmp30    (divisor, RQBShiftedBy[30], 1'b1, 1'b0, /*EQ*/, GT[30]);
	assign     Q[30] =   GT[30] ? 1'b0 : 1'b1;
	not        not30    (nGT[30], GT[30]);
	shifterLog shDiv30  (DivisorShiftedBy[30], divisor, 1'b0, 5'b11110);
	adder32    subRQB30 (RQB[30], DivisorShiftedBy[30], 1'b1, RQBSub[30], /*cout*/, 1'b1, /*of*/, nGT[30]);
	cycle32    c30      (RQBSub[30], RQB[29], clock);
	
		// BLOCK 29 //
	shifterLog shRQB29  (RQBShiftedBy[29], RQB[29], 1'b1, 5'b11101);
	compare32  cmp29    (divisor, RQBShiftedBy[29], 1'b1, 1'b0, /*EQ*/, GT[29]);
	assign     Q[29] =   GT[29] ? 1'b0 : 1'b1;
	not        not29    (nGT[29], GT[29]);
	shifterLog shDiv29  (DivisorShiftedBy[29], divisor, 1'b0, 5'b11101);
	adder32    subRQB29 (RQB[29], DivisorShiftedBy[29], 1'b1, RQBSub[29], /*cout*/, 1'b1, /*of*/, nGT[29]);
	cycle32    c29      (RQBSub[29], RQB[28], clock);
	
		// BLOCK 28 //
	shifterLog shRQB28  (RQBShiftedBy[28], RQB[28], 1'b1, 5'b11100);
	compare32  cmp28    (divisor, RQBShiftedBy[28], 1'b1, 1'b0, /*EQ*/, GT[28]);
	assign     Q[28] =   GT[28] ? 1'b0 : 1'b1;
	not        not28    (nGT[28], GT[28]);
	shifterLog shDiv28  (DivisorShiftedBy[28], divisor, 1'b0, 5'b11100);
	adder32    subRQB28 (RQB[28], DivisorShiftedBy[28], 1'b1, RQBSub[28], /*cout*/, 1'b1, /*of*/, nGT[28]);
	cycle32    c28      (RQBSub[28], RQB[27], clock);
	
		// BLOCK 27 //
	shifterLog shRQB27  (RQBShiftedBy[27], RQB[27], 1'b1, 5'b11011);
	compare32  cmp27    (divisor, RQBShiftedBy[27], 1'b1, 1'b0, /*EQ*/, GT[27]);
	assign     Q[27] =   GT[27] ? 1'b0 : 1'b1;
	not        not27    (nGT[27], GT[27]);
	shifterLog shDiv27  (DivisorShiftedBy[27], divisor, 1'b0, 5'b11011);
	adder32    subRQB27 (RQB[27], DivisorShiftedBy[27], 1'b1, RQBSub[27], /*cout*/, 1'b1, /*of*/, nGT[27]);
	cycle32    c27      (RQBSub[27], RQB[26], clock);
	
		// BLOCK 26 //
	shifterLog shRQB26  (RQBShiftedBy[26], RQB[26], 1'b1, 5'b11010);
	compare32  cmp26    (divisor, RQBShiftedBy[26], 1'b1, 1'b0, /*EQ*/, GT[26]);
	assign     Q[26] =   GT[26] ? 1'b0 : 1'b1;
	not        not26    (nGT[26], GT[26]);
	shifterLog shDiv26  (DivisorShiftedBy[26], divisor, 1'b0, 5'b11010);
	adder32    subRQB26 (RQB[26], DivisorShiftedBy[26], 1'b1, RQBSub[26], /*cout*/, 1'b1, /*of*/, nGT[26]);
	cycle32    c26      (RQBSub[26], RQB[25], clock);
	
		// BLOCK 25 //
	shifterLog shRQB25  (RQBShiftedBy[25], RQB[25], 1'b1, 5'b11001);
	compare32  cmp25    (divisor, RQBShiftedBy[25], 1'b1, 1'b0, /*EQ*/, GT[25]);
	assign     Q[25] =   GT[25] ? 1'b0 : 1'b1;
	not        not25    (nGT[25], GT[25]);
	shifterLog shDiv25  (DivisorShiftedBy[25], divisor, 1'b0, 5'b11001);
	adder32    subRQB25 (RQB[25], DivisorShiftedBy[25], 1'b1, RQBSub[25], /*cout*/, 1'b1, /*of*/, nGT[25]);
	cycle32    c25      (RQBSub[25], RQB[24], clock);
	
		// BLOCK 24 //
	shifterLog shRQB24  (RQBShiftedBy[24], RQB[24], 1'b1, 5'b11000);
	compare32  cmp24    (divisor, RQBShiftedBy[24], 1'b1, 1'b0, /*EQ*/, GT[24]);
	assign     Q[24] =   GT[24] ? 1'b0 : 1'b1;
	not        not24    (nGT[24], GT[24]);
	shifterLog shDiv24  (DivisorShiftedBy[24], divisor, 1'b0, 5'b11000);
	adder32    subRQB24 (RQB[24], DivisorShiftedBy[24], 1'b1, RQBSub[24], /*cout*/, 1'b1, /*of*/, nGT[24]);
	cycle32    c24      (RQBSub[24], RQB[23], clock);
	
		// BLOCK 23 //
	shifterLog shRQB23  (RQBShiftedBy[23], RQB[23], 1'b1, 5'b10111);
	compare32  cmp23    (divisor, RQBShiftedBy[23], 1'b1, 1'b0, /*EQ*/, GT[23]);
	assign     Q[23] =   GT[23] ? 1'b0 : 1'b1;
	not        not23    (nGT[23], GT[23]);
	shifterLog shDiv23  (DivisorShiftedBy[23], divisor, 1'b0, 5'b10111);
	adder32    subRQB23 (RQB[23], DivisorShiftedBy[23], 1'b1, RQBSub[23], /*cout*/, 1'b1, /*of*/, nGT[23]);
	cycle32    c23      (RQBSub[23], RQB[22], clock);
	
		// BLOCK 22 //
	shifterLog shRQB22  (RQBShiftedBy[22], RQB[22], 1'b1, 5'b10110);
	compare32  cmp22    (divisor, RQBShiftedBy[22], 1'b1, 1'b0, /*EQ*/, GT[22]);
	assign     Q[22] =   GT[22] ? 1'b0 : 1'b1;
	not        not22    (nGT[22], GT[22]);
	shifterLog shDiv22  (DivisorShiftedBy[22], divisor, 1'b0, 5'b10110);
	adder32    subRQB22 (RQB[22], DivisorShiftedBy[22], 1'b1, RQBSub[22], /*cout*/, 1'b1, /*of*/, nGT[22]);
	cycle32    c22      (RQBSub[22], RQB[21], clock);
	
		// BLOCK 21 //
	shifterLog shRQB21  (RQBShiftedBy[21], RQB[21], 1'b1, 5'b10101);
	compare32  cmp21    (divisor, RQBShiftedBy[21], 1'b1, 1'b0, /*EQ*/, GT[21]);
	assign     Q[21] =   GT[21] ? 1'b0 : 1'b1;
	not        not21    (nGT[21], GT[21]);
	shifterLog shDiv21  (DivisorShiftedBy[21], divisor, 1'b0, 5'b10101);
	adder32    subRQB21 (RQB[21], DivisorShiftedBy[21], 1'b1, RQBSub[21], /*cout*/, 1'b1, /*of*/, nGT[21]);
	cycle32    c21      (RQBSub[21], RQB[20], clock);
	
		// BLOCK 20 //
	shifterLog shRQB20  (RQBShiftedBy[20], RQB[20], 1'b1, 5'b10100);
	compare32  cmp20    (divisor, RQBShiftedBy[20], 1'b1, 1'b0, /*EQ*/, GT[20]);
	assign     Q[20] =   GT[20] ? 1'b0 : 1'b1;
	not        not20    (nGT[20], GT[20]);
	shifterLog shDiv20  (DivisorShiftedBy[20], divisor, 1'b0, 5'b10100);
	adder32    subRQB20 (RQB[20], DivisorShiftedBy[20], 1'b1, RQBSub[20], /*cout*/, 1'b1, /*of*/, nGT[20]);
	cycle32    c20      (RQBSub[20], RQB[19], clock);
	
		// BLOCK 19 //
	shifterLog shRQB19  (RQBShiftedBy[19], RQB[19], 1'b1, 5'b10011);
	compare32  cmp19    (divisor, RQBShiftedBy[19], 1'b1, 1'b0, /*EQ*/, GT[19]);
	assign     Q[19] =   GT[19] ? 1'b0 : 1'b1;
	not        not19    (nGT[19], GT[19]);
	shifterLog shDiv19  (DivisorShiftedBy[19], divisor, 1'b0, 5'b10011);
	adder32    subRQB19 (RQB[19], DivisorShiftedBy[19], 1'b1, RQBSub[19], /*cout*/, 1'b1, /*of*/, nGT[19]);
	cycle32    c19      (RQBSub[19], RQB[18], clock);
	
		// BLOCK 18 //
	shifterLog shRQB18  (RQBShiftedBy[18], RQB[18], 1'b1, 5'b10010);
	compare32  cmp18    (divisor, RQBShiftedBy[18], 1'b1, 1'b0, /*EQ*/, GT[18]);
	assign     Q[18] =   GT[18] ? 1'b0 : 1'b1;
	not        not18    (nGT[18], GT[18]);
	shifterLog shDiv18  (DivisorShiftedBy[18], divisor, 1'b0, 5'b10010);
	adder32    subRQB18 (RQB[18], DivisorShiftedBy[18], 1'b1, RQBSub[18], /*cout*/, 1'b1, /*of*/, nGT[18]);
	cycle32    c18      (RQBSub[18], RQB[17], clock);
	
		// BLOCK 17 //
	shifterLog shRQB17  (RQBShiftedBy[17], RQB[17], 1'b1, 5'b10001);
	compare32  cmp17    (divisor, RQBShiftedBy[17], 1'b1, 1'b0, /*EQ*/, GT[17]);
	assign     Q[17] =   GT[17] ? 1'b0 : 1'b1;
	not        not17    (nGT[17], GT[17]);
	shifterLog shDiv17  (DivisorShiftedBy[17], divisor, 1'b0, 5'b10001);
	adder32    subRQB17 (RQB[17], DivisorShiftedBy[17], 1'b1, RQBSub[17], /*cout*/, 1'b1, /*of*/, nGT[17]);
	cycle32    c17      (RQBSub[17], RQB[16], clock);
	
		// BLOCK 16 //
	shifterLog shRQB16  (RQBShiftedBy[16], RQB[16], 1'b1, 5'b10000);
	compare32  cmp16    (divisor, RQBShiftedBy[16], 1'b1, 1'b0, /*EQ*/, GT[16]);
	assign     Q[16] =   GT[16] ? 1'b0 : 1'b1;
	not        not16    (nGT[16], GT[16]);
	shifterLog shDiv16  (DivisorShiftedBy[16], divisor, 1'b0, 5'b10000);
	adder32    subRQB16 (RQB[16], DivisorShiftedBy[16], 1'b1, RQBSub[16], /*cout*/, 1'b1, /*of*/, nGT[16]);
	cycle32    c16      (RQBSub[16], RQB[15], clock);
	
		// BLOCK 15 //
	shifterLog shRQB15  (RQBShiftedBy[15], RQB[15], 1'b1, 5'b01111);
	compare32  cmp15    (divisor, RQBShiftedBy[15], 1'b1, 1'b0, /*EQ*/, GT[15]);
	assign     Q[15] =   GT[15] ? 1'b0 : 1'b1;
	not        not15    (nGT[15], GT[15]);
	shifterLog shDiv15  (DivisorShiftedBy[15], divisor, 1'b0, 5'b01111);
	adder32    subRQB15 (RQB[15], DivisorShiftedBy[15], 1'b1, RQBSub[15], /*cout*/, 1'b1, /*of*/, nGT[15]);
	cycle32    c15      (RQBSub[15], RQB[14], clock);
	
		// BLOCK 14 //
	shifterLog shRQB14  (RQBShiftedBy[14], RQB[14], 1'b1, 5'b01110);
	compare32  cmp14    (divisor, RQBShiftedBy[14], 1'b1, 1'b0, /*EQ*/, GT[14]);
	assign     Q[14] =   GT[14] ? 1'b0 : 1'b1;
	not        not14    (nGT[14], GT[14]);
	shifterLog shDiv14  (DivisorShiftedBy[14], divisor, 1'b0, 5'b01110);
	adder32    subRQB14 (RQB[14], DivisorShiftedBy[14], 1'b1, RQBSub[14], /*cout*/, 1'b1, /*of*/, nGT[14]);
	cycle32    c14      (RQBSub[14], RQB[13], clock);
	
		// BLOCK 13 //
	shifterLog shRQB13  (RQBShiftedBy[13], RQB[13], 1'b1, 5'b01101);
	compare32  cmp13    (divisor, RQBShiftedBy[13], 1'b1, 1'b0, /*EQ*/, GT[13]);
	assign     Q[13] =   GT[13] ? 1'b0 : 1'b1;
	not        not13    (nGT[13], GT[13]);
	shifterLog shDiv13  (DivisorShiftedBy[13], divisor, 1'b0, 5'b01101);
	adder32    subRQB13 (RQB[13], DivisorShiftedBy[13], 1'b1, RQBSub[13], /*cout*/, 1'b1, /*of*/, nGT[13]);
	cycle32    c13      (RQBSub[13], RQB[12], clock);
	
		// BLOCK 12 //
	shifterLog shRQB12  (RQBShiftedBy[12], RQB[12], 1'b1, 5'b01100);
	compare32  cmp12    (divisor, RQBShiftedBy[12], 1'b1, 1'b0, /*EQ*/, GT[12]);
	assign     Q[12] =   GT[12] ? 1'b0 : 1'b1;
	not        not12    (nGT[12], GT[12]);
	shifterLog shDiv12  (DivisorShiftedBy[12], divisor, 1'b0, 5'b01100);
	adder32    subRQB12 (RQB[12], DivisorShiftedBy[12], 1'b1, RQBSub[12], /*cout*/, 1'b1, /*of*/, nGT[12]);
	cycle32    c12      (RQBSub[12], RQB[11], clock);
	
		// BLOCK 11 //
	shifterLog shRQB11  (RQBShiftedBy[11], RQB[11], 1'b1, 5'b01011);
	compare32  cmp11    (divisor, RQBShiftedBy[11], 1'b1, 1'b0, /*EQ*/, GT[11]);
	assign     Q[11] =   GT[11] ? 1'b0 : 1'b1;
	not        not11    (nGT[11], GT[11]);
	shifterLog shDiv11  (DivisorShiftedBy[11], divisor, 1'b0, 5'b01011);
	adder32    subRQB11 (RQB[11], DivisorShiftedBy[11], 1'b1, RQBSub[11], /*cout*/, 1'b1, /*of*/, nGT[11]);
	cycle32    c11      (RQBSub[11], RQB[10], clock);
	
		// BLOCK 10 //
	shifterLog shRQB10  (RQBShiftedBy[10], RQB[10], 1'b1, 5'b01010);
	compare32  cmp10    (divisor, RQBShiftedBy[10], 1'b1, 1'b0, /*EQ*/, GT[10]);
	assign     Q[10] =   GT[10] ? 1'b0 : 1'b1;
	not        not10    (nGT[10], GT[10]);
	shifterLog shDiv10  (DivisorShiftedBy[10], divisor, 1'b0, 5'b01010);
	adder32    subRQB10 (RQB[10], DivisorShiftedBy[10], 1'b1, RQBSub[10], /*cout*/, 1'b1, /*of*/, nGT[10]);
	cycle32    c10      (RQBSub[10], RQB[9], clock);
	
		// BLOCK 9 //
	shifterLog shRQB9  (RQBShiftedBy[9], RQB[9], 1'b1, 5'b01001);
	compare32  cmp9    (divisor, RQBShiftedBy[9], 1'b1, 1'b0, /*EQ*/, GT[9]);
	assign     Q[9] =   GT[9] ? 1'b0 : 1'b1;
	not        not9    (nGT[9], GT[9]);
	shifterLog shDiv9  (DivisorShiftedBy[9], divisor, 1'b0, 5'b01001);
	adder32    subRQB9 (RQB[9], DivisorShiftedBy[9], 1'b1, RQBSub[9], /*cout*/, 1'b1, /*of*/, nGT[9]);
	cycle32    c9      (RQBSub[9], RQB[8], clock);
	
		// BLOCK 8 //
	shifterLog shRQB8  (RQBShiftedBy[8], RQB[8], 1'b1, 5'b01000);
	compare32  cmp8    (divisor, RQBShiftedBy[8], 1'b1, 1'b0, /*EQ*/, GT[8]);
	assign     Q[8] =   GT[8] ? 1'b0 : 1'b1;
	not        not8    (nGT[8], GT[8]);
	shifterLog shDiv8  (DivisorShiftedBy[8], divisor, 1'b0, 5'b01000);
	adder32    subRQB8 (RQB[8], DivisorShiftedBy[8], 1'b1, RQBSub[8], /*cout*/, 1'b1, /*of*/, nGT[8]);
	cycle32    c8      (RQBSub[8], RQB[7], clock);
	
		// BLOCK 7 //
	shifterLog shRQB7  (RQBShiftedBy[7], RQB[7], 1'b1, 5'b00111);
	compare32  cmp7    (divisor, RQBShiftedBy[7], 1'b1, 1'b0, /*EQ*/, GT[7]);
	assign     Q[7] =   GT[7] ? 1'b0 : 1'b1;
	not        not7    (nGT[7], GT[7]);
	shifterLog shDiv7  (DivisorShiftedBy[7], divisor, 1'b0, 5'b00111);
	adder32    subRQB7 (RQB[7], DivisorShiftedBy[7], 1'b1, RQBSub[7], /*cout*/, 1'b1, /*of*/, nGT[7]);
	cycle32    c7      (RQBSub[7], RQB[6], clock);
	
		// BLOCK 6 //
	shifterLog shRQB6  (RQBShiftedBy[6], RQB[6], 1'b1, 5'b00110);
	compare32  cmp6    (divisor, RQBShiftedBy[6], 1'b1, 1'b0, /*EQ*/, GT[6]);
	assign     Q[6] =   GT[6] ? 1'b0 : 1'b1;
	not        not6    (nGT[6], GT[6]);
	shifterLog shDiv6  (DivisorShiftedBy[6], divisor, 1'b0, 5'b00110);
	adder32    subRQB6 (RQB[6], DivisorShiftedBy[6], 1'b1, RQBSub[6], /*cout*/, 1'b1, /*of*/, nGT[6]);
	cycle32    c6      (RQBSub[6], RQB[5], clock);
	
		// BLOCK 5 //
	shifterLog shRQB5  (RQBShiftedBy[5], RQB[5], 1'b1, 5'b00101);
	compare32  cmp5    (divisor, RQBShiftedBy[5], 1'b1, 1'b0, /*EQ*/, GT[5]);
	assign     Q[5] =   GT[5] ? 1'b0 : 1'b1;
	not        not5    (nGT[5], GT[5]);
	shifterLog shDiv5  (DivisorShiftedBy[5], divisor, 1'b0, 5'b00101);
	adder32    subRQB5 (RQB[5], DivisorShiftedBy[5], 1'b1, RQBSub[5], /*cout*/, 1'b1, /*of*/, nGT[5]);
	cycle32    c5      (RQBSub[5], RQB[4], clock);
	
		// BLOCK 4 //
	shifterLog shRQB4  (RQBShiftedBy[4], RQB[4], 1'b1, 5'b00100);
	compare32  cmp4    (divisor, RQBShiftedBy[4], 1'b1, 1'b0, /*EQ*/, GT[4]);
	assign     Q[4] =   GT[4] ? 1'b0 : 1'b1;
	not        not4    (nGT[4], GT[4]);
	shifterLog shDiv4  (DivisorShiftedBy[4], divisor, 1'b0, 5'b00100);
	adder32    subRQB4 (RQB[4], DivisorShiftedBy[4], 1'b1, RQBSub[4], /*cout*/, 1'b1, /*of*/, nGT[4]);
	cycle32    c4      (RQBSub[4], RQB[3], clock);
	
		// BLOCK 3 //
	shifterLog shRQB3  (RQBShiftedBy[3], RQB[3], 1'b1, 5'b00011);
	compare32  cmp3    (divisor, RQBShiftedBy[3], 1'b1, 1'b0, /*EQ*/, GT[3]);
	assign     Q[3] =   GT[3] ? 1'b0 : 1'b1;
	not        not3    (nGT[3], GT[3]);
	shifterLog shDiv3  (DivisorShiftedBy[3], divisor, 1'b0, 5'b00011);
	adder32    subRQB3 (RQB[3], DivisorShiftedBy[3], 1'b1, RQBSub[3], /*cout*/, 1'b1, /*of*/, nGT[3]);
	cycle32    c3      (RQBSub[3], RQB[2], clock);
	
		// BLOCK 2 //
	shifterLog shRQB2  (RQBShiftedBy[2], RQB[2], 1'b1, 5'b00010);
	compare32  cmp2    (divisor, RQBShiftedBy[2], 1'b1, 1'b0, /*EQ*/, GT[2]);
	assign     Q[2] =   GT[2] ? 1'b0 : 1'b1;
	not        not2    (nGT[2], GT[2]);
	shifterLog shDiv2  (DivisorShiftedBy[2], divisor, 1'b0, 5'b00010);
	adder32    subRQB2 (RQB[2], DivisorShiftedBy[2], 1'b1, RQBSub[2], /*cout*/, 1'b1, /*of*/, nGT[2]);
	cycle32    c2      (RQBSub[2], RQB[1], clock);
	
		// BLOCK 1 //
	shifterLog shRQB1  (RQBShiftedBy[1], RQB[1], 1'b1, 5'b00001);
	compare32  cmp1    (divisor, RQBShiftedBy[1], 1'b1, 1'b0, /*EQ*/, GT[1]);
	assign     Q[1] =   GT[1] ? 1'b0 : 1'b1;
	not        not1    (nGT[1], GT[1]);
	shifterLog shDiv1  (DivisorShiftedBy[1], divisor, 1'b0, 5'b00001);
	adder32    subRQB1 (RQB[1], DivisorShiftedBy[1], 1'b1, RQBSub[1], /*cout*/, 1'b1, /*of*/, nGT[1]);
	cycle32    c1      (RQBSub[1], RQB[0], clock);
	
		// BLOCK 0 //
	shifterLog shRQB0  (RQBShiftedBy[0], RQB[0], 1'b1, 5'b00000);
	compare32  cmp0    (divisor, RQBShiftedBy[0], 1'b1, 1'b0, /*EQ*/, GT[0]);
	assign     Q[0] =   GT[0] ? 1'b0 : 1'b1;
	
	adder32 ans(32'b0, Q, neg, Q2, /*cout*/, neg, /*of*/, 1'b1);
	
	assign quotient = resultRDY ? Q2 : 32'b0;
	assign Div0 = resultRDY ? Div0Check[4] : 1'b0;
	
endmodule

module mult(multiplicand, multiplier, clock, reset, product, overflow, resultRDY);
	input  [31:0]  multiplicand, multiplier;
	output [31:0]  product;
	input          clock, reset;
	output         overflow, resultRDY;
	wire   [64:0]  left    [15:0];
	wire   [64:0]  right   [15:-1];
	wire   [64:0]  preleft [14:-1];
	wire   [31:0]  s       [14:-1];
	wire   [31:0]  SLLBy1  [14:-1];
	wire   [31:0]  p;
	wire   [31:-1] enop, add, sub, SLL;
	wire   [5:0]   i;
	wire   [4:0]   o1, o2;
	wire           o3, neg;
	
		// I/O FLAGS //
	counter count(i, 1'b1, clock, reset);
	and resRDY(resultRDY, ~i[5], i[4], ~i[3], ~i[2], ~i[1], ~i[0]);
	
		// SIGN CHECKING //
	xor negP(neg, multiplicand[31], multiplier[31]);
	
		// BLOCK -1 //
	assign    right[-1] = {32'b0, multiplier, 1'b0};	
	flagger   fneg1   (right[-1][2:0], add[-1], sub[-1], SLL[-1]);
	shiftLog1 SLLneg1 (SLLBy1[-1], multiplicand, 1'b0, SLL[-1]);
	or        orneg1  (enop[-1], add[-1], sub[-1]);
	adder32   asneg1  (right[-1][64:33], SLLBy1[-1], sub[-1], s[-1], /*cout*/, sub[-1], /*of*/, enop[-1]);
	assign    preleft[-1] = {s[-1], right[-1][32:0]};
	cycle     cneg1   (preleft[-1], left[0], clock);
	
		// BLOCK 0 //
	SRA65     SRA0  (left[0], right[0]);
	flagger   f0    (right[0], add[0], sub[0], SLL[0]);
	shiftLog1 SLL0  (SLLBy1[0], multiplicand, 1'b0, SLL[0]);
	or        or0   (enop[0], add[0], sub[0]);
	adder32   as0   (right[0][64:33], SLLBy1[0], sub[0], s[0], /*cout*/, sub[0], /*of*/, enop[0]);
	assign    preleft[0] = {s[0], right[0][32:0]};
	cycle     c0    (preleft[0], left[1], clock);
	
		// BLOCK 1 //
	SRA65     SRA1  (left[1], right[1]);
	flagger   f1    (right[1], add[1], sub[1], SLL[1]);
	shiftLog1 SLL1  (SLLBy1[1], multiplicand, 1'b0, SLL[1]);
	or        or1   (enop[1], add[1], sub[1]);
	adder32   as1   (right[1][64:33], SLLBy1[1], sub[1], s[1], /*cout*/, sub[1], /*of*/, enop[1]);
	assign    preleft[1] = {s[1], right[1][32:0]};
	cycle     c1    (preleft[1], left[2], clock);
	
		// BLOCK 2 //
	SRA65     SRA2  (left[2], right[2]);
	flagger   f2    (right[2], add[2], sub[2], SLL[2]);
	shiftLog1 SLL2  (SLLBy1[2], multiplicand, 1'b0, SLL[2]);
	or        or2   (enop[2], add[2], sub[2]);
	adder32   as2   (right[2][64:33], SLLBy1[2], sub[2], s[2], /*cout*/, sub[2], /*of*/, enop[2]);
	assign    preleft[2] = {s[2], right[2][32:0]};
	cycle     c2    (preleft[2], left[3], clock);
	
		// BLOCK 3 //
	SRA65     SRA3  (left[3], right[3]);
	flagger   f3    (right[3], add[3], sub[3], SLL[3]);
	shiftLog1 SLL3  (SLLBy1[3], multiplicand, 1'b0, SLL[3]);
	or        or3   (enop[3], add[3], sub[3]);
	adder32   as3   (right[3][64:33], SLLBy1[3], sub[3], s[3], /*cout*/, sub[3], /*of*/, enop[3]);
	assign    preleft[3] = {s[3], right[3][32:0]};
	cycle     c3    (preleft[3], left[4], clock);
	
		// BLOCK 4 //
	SRA65     SRA4  (left[4], right[4]);
	flagger   f4    (right[4], add[4], sub[4], SLL[4]);
	shiftLog1 SLL4  (SLLBy1[4], multiplicand, 1'b0, SLL[4]);
	or        or4   (enop[4], add[4], sub[4]);
	adder32   as4   (right[4][64:33], SLLBy1[4], sub[4], s[4], /*cout*/, sub[4], /*of*/, enop[4]);
	assign    preleft[4] = {s[4], right[4][32:0]};
	cycle     c4    (preleft[4], left[5], clock);
	
		// BLOCK 5 //
	SRA65     SRA5  (left[5], right[5]);
	flagger   f5    (right[5], add[5], sub[5], SLL[5]);
	shiftLog1 SLL5  (SLLBy1[5], multiplicand, 1'b0, SLL[5]);
	or        or5   (enop[5], add[5], sub[5]);
	adder32   as5   (right[5][64:33], SLLBy1[5], sub[5], s[5], /*cout*/, sub[5], /*of*/, enop[5]);
	assign    preleft[5] = {s[5], right[5][32:0]};
	cycle     c5    (preleft[5], left[6], clock);
	
		// BLOCK 6 //
	SRA65     SRA6  (left[6], right[6]);
	flagger   f6    (right[6], add[6], sub[6], SLL[6]);
	shiftLog1 SLL6  (SLLBy1[6], multiplicand, 1'b0, SLL[6]);
	or        or6   (enop[6], add[6], sub[6]);
	adder32   as6   (right[6][64:33], SLLBy1[6], sub[6], s[6], /*cout*/, sub[6], /*of*/, enop[6]);
	assign    preleft[6] = {s[6], right[6][32:0]};
	cycle     c6    (preleft[6], left[7], clock);
	
		// BLOCK 7 //
	SRA65     SRA7  (left[7], right[7]);
	flagger   f7    (right[7], add[7], sub[7], SLL[7]);
	shiftLog1 SLL7  (SLLBy1[7], multiplicand, 1'b0, SLL[7]);
	or        or7   (enop[7], add[7], sub[7]);
	adder32   as7   (right[7][64:33], SLLBy1[7], sub[7], s[7], /*cout*/, sub[7], /*of*/, enop[7]);
	assign    preleft[7] = {s[7], right[7][32:0]};
	cycle     c7    (preleft[7], left[8], clock);
	
		// BLOCK 8 //
	SRA65     SRA8  (left[8], right[8]);
	flagger   f8    (right[8], add[8], sub[8], SLL[8]);
	shiftLog1 SLL8  (SLLBy1[8], multiplicand, 1'b0, SLL[8]);
	or        or8   (enop[8], add[8], sub[8]);
	adder32   as8   (right[8][64:33], SLLBy1[8], sub[8], s[8], /*cout*/, sub[8], /*of*/, enop[8]);
	assign    preleft[8] = {s[8], right[8][32:0]};
	cycle     c8    (preleft[8], left[9], clock);
	
		// BLOCK 9 //
	SRA65     SRA9  (left[9], right[9]);
	flagger   f9    (right[9], add[9], sub[9], SLL[9]);
	shiftLog1 SLL9  (SLLBy1[9], multiplicand, 1'b0, SLL[9]);
	or        or9   (enop[9], add[9], sub[9]);
	adder32   as9   (right[9][64:33], SLLBy1[9], sub[9], s[9], /*cout*/, sub[9], /*of*/, enop[9]);
	assign    preleft[9] = {s[9], right[9][32:0]};
	cycle     c9    (preleft[9], left[10], clock);
	
		// BLOCK 10 //
	SRA65     SRA10  (left[10], right[10]);
	flagger   f10    (right[10], add[10], sub[10], SLL[10]);
	shiftLog1 SLL10  (SLLBy1[10], multiplicand, 1'b0, SLL[10]);
	or        or10   (enop[10], add[10], sub[10]);
	adder32   as10   (right[10][64:33], SLLBy1[10], sub[10], s[10], /*cout*/, sub[10], /*of*/, enop[10]);
	assign    preleft[10] = {s[10], right[10][32:0]};
	cycle     c10    (preleft[10], left[11], clock);
	
		// BLOCK 11 //
	SRA65     SRA11  (left[11], right[11]);
	flagger   f11    (right[11], add[11], sub[11], SLL[11]);
	shiftLog1 SLL11  (SLLBy1[11], multiplicand, 1'b0, SLL[11]);
	or        or11   (enop[11], add[11], sub[11]);
	adder32   as11   (right[11][64:33], SLLBy1[11], sub[11], s[11], /*cout*/, sub[11], /*of*/, enop[11]);
	assign    preleft[11] = {s[11], right[11][32:0]};
	cycle     c11    (preleft[11], left[12], clock);
	
		// BLOCK 12 //
	SRA65     SRA12  (left[12], right[12]);
	flagger   f12    (right[12], add[12], sub[12], SLL[12]);
	shiftLog1 SLL12  (SLLBy1[12], multiplicand, 1'b0, SLL[12]);
	or        or12   (enop[12], add[12], sub[12]);
	adder32   as12   (right[12][64:33], SLLBy1[12], sub[12], s[12], /*cout*/, sub[12], /*of*/, enop[12]);
	assign    preleft[12] = {s[12], right[12][32:0]};
	cycle     c12    (preleft[12], left[13], clock);
	
		// BLOCK 13 //
	SRA65     SRA13  (left[13], right[13]);
	flagger   f13    (right[13], add[13], sub[13], SLL[13]);
	shiftLog1 SLL13  (SLLBy1[13], multiplicand, 1'b0, SLL[13]);
	or        or13   (enop[13], add[13], sub[13]);
	adder32   as13   (right[13][64:33], SLLBy1[13], sub[13], s[13], /*cout*/, sub[13], /*of*/, enop[13]);
	assign    preleft[13] = {s[13], right[13][32:0]};
	cycle     c13    (preleft[13], left[14], clock);
	
		// BLOCK 14 //
	SRA65     SRA14  (left[14], right[14]);
	flagger   f14    (right[14], add[14], sub[14], SLL[14]);
	shiftLog1 SLL14  (SLLBy1[14], multiplicand, 1'b0, SLL[14]);
	or        or14   (enop[14], add[14], sub[14]);
	adder32   as14   (right[14][64:33], SLLBy1[14], sub[14], s[14], /*cout*/, sub[14], /*of*/, enop[14]);
	assign    preleft[14] = {s[14], right[14][32:0]};
	cycle     c14    (preleft[14], left[15], clock);
	
		// BLOCK 15 //
	SRA65     SRA15  (left[15], right[15]);
	
	assign product = resultRDY ? right[15][32:1] : 32'b0;
	
		// EXCEPTION CHECKING //
	assign p = right[15][64:33];
	
		// ALL 0 CASE (POS PRODUCT) //
	or  oflow0_0(o1[0], p[31], p[30], p[29], p[28], p[27], p[26], p[25], p[24]);
	or  oflow0_1(o1[1], p[23], p[22], p[21], p[20], p[19], p[18], p[17], p[16]);
	or  oflow0_2(o1[2], p[15], p[14], p[13], p[12], p[11], p[10], p[9],  p[8]);
	or  oflow0_3(o1[3], p[7],  p[6],  p[5],  p[4],  p[3],  p[2],  p[1],  p[0], product[31]);
	or  oflow0_4(o1[4], o1[3], o1[2], o1[1], o1[0]);
			
		// ALL 1 CASE (NEG PRODUCT) //
	nand  oflow1_0(o2[0], p[31], p[30], p[29], p[28], p[27], p[26], p[25], p[24]);
	nand  oflow1_1(o2[1], p[23], p[22], p[21], p[20], p[19], p[18], p[17], p[16]);
	nand  oflow1_2(o2[2], p[15], p[14], p[13], p[12], p[11], p[10], p[9],  p[8]);
	nand  oflow1_3(o2[3], p[7],  p[6],  p[5],  p[4],  p[3],  p[2],  p[1],  p[0], product[31]);
	or    oflow1_4(o2[4], o2[3], o2[2], o2[1], o2[0]);
						
	assign o3 = neg ? o2[4] : o1[4];
	assign overflow = resultRDY ? o3 : 1'b0;
	
endmodule
