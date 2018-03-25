// +build !noasm,!generic,amd64

#include "fq_amd64.h"
#include "fq_asm.h"

TEXT ·fqAdd(SB),0,$0-24
	GET_A(DI)
	GET_B(SI)
	MOVQ D0, X0
	OP(MOVQ, 	D1, D2, D3, D4, D5, 	X1, X2, X3, X4, X5)
	GET_C(DI)
	ADDQ S0, X0
	OP(ADCQ, 	S1, S2, S3, S4, S5, 	X1, X2, X3, X4, X5)
	REDUCE_X
	MOVQ X0, D0
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	D1, D2, D3, D4, D5)
	RET

TEXT ·lfqAdd(SB),0,$0-24
	GET_A(DI)
	GET_B(SI)
	MOVQ D0, Y0
	OP(MOVQ, 	D1, D2, D3, D4, D5, 	Y1, Y2, Y3, Y4, Y5)
	ADDQ S0, Y0
	OP(ADCQ, 	S1, S2, S3, S4, S5, 	Y1, Y2, Y3, Y4, Y5)
	MOVQ D6, X0
	OP(MOVQ, 	D7, D8, D9, D10, D11, 	X1, X2, X3, X4, X5)
	GET_C(DI)
	ADCQ S6, X0
	OP(ADCQ, 	S7, S8, S9, S10, S11, 	X1, X2, X3, X4, X5)
	MOVQ Y0, D0
	OP(MOVQ, 	Y1, Y2, Y3, Y4, Y5, 	D1, D2, D3, D4, D5)
	REDUCE_X
	MOVQ X0, D6
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	D7, D8, D9, D10, D11)
	RET

TEXT ·fqReduce(SB),0,$0-8
	GET_C(DI)
	MOVQ D0, X0
	OP(MOVQ, 	D1, D2, D3, D4, D5, 	X1, X2, X3, X4, X5)
	REDUCE_X
	MOVQ X0, D0
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	D1, D2, D3, D4, D5)
	RET

TEXT ·fqSub(SB),0,$0-24
	GET_A(DI)
	GET_B(SI)
	MOVQ D0, X0
	OP(MOVQ, 	D1, D2, D3, D4, D5, 	X1, X2, X3, X4, X5)
	GET_C(DI)
	SUBQ S0, X0
	OP(SBBQ, 	S1, S2, S3, S4, S5, 	X1, X2, X3, X4, X5)
	MOVQ $0, Y0
	OP(MOVQ, 	$0, $0, $0, $0, $0, 	Y1, Y2, Y3, Y4, Y5)
	CMOVQCS Q0, Y0
	OP(CMOVQCS, 	Q1, Q2, Q3, Q4, Q5, 	Y1, Y2, Y3, Y4, Y5)
	ADDQ Y0, X0
	OP(ADCQ, 	Y1, Y2, Y3, Y4, Y5, 	X1, X2, X3, X4, X5)
	MOVQ X0, D0
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	D1, D2, D3, D4, D5)
	RET

TEXT ·lfqSub(SB),0,$0-24
	GET_A(DI)
	GET_B(SI)

	// a_low -> x
	MOVQ D0, X0
	OP(MOVQ, 	D1, D2, D3, D4, D5, 	X1, X2, X3, X4, X5)

	// sub s (b) from x
	SUBQ S0, X0
	OP(SBBQ, 	S1, S2, S3, S4, S5, 	X1, X2, X3, X4, X5)

	// a_hi -> y
	MOVQ D6, Y0
	OP(MOVQ, 	D7, D8, D9, D10, D11, 	Y1, Y2, Y3, Y4, Y5)

	// sub s_hi (b) from y
	SBBQ S6, Y0
	OP(SBBQ, 	S7, S8, S9, S10, S11, 	Y1, Y2, Y3, Y4, Y5)

	// put c into s
	GET_C(SI)

	// save bottom x to s
	MOVQ X0, S0
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	S1, S2, S3, S4, S5)

	// move q or 0 to x
	MOVQ $0, X0
	OP(MOVQ, 	$0, $0, $0, $0, $0, 	X1, X2, X3, X4, X5)

	CMOVQCS Q0, X0
	OP(CMOVQCS, 	Q1, Q2, Q3, Q4, Q5, 	X1, X2, X3, X4, X5)

	ADDQ X0, Y0
	OP(ADCQ, 	X1, X2, X3, X4, X5, 	Y1, Y2, Y3, Y4, Y5)

	MOVQ Y0, S6
	OP(MOVQ, 	Y1, Y2, Y3, Y4, Y5, 	S7, S8, S9, S10, S11)
	RET


TEXT ·fqNeg(SB),0,$0-16
	GET_A(SI)
	GET_C(DI)
	MOVQ S0, X0
	OP(MOVQ, 	S1, S2, S3, S4, S5, 	X1, X2, X3, X4, X5)
	MOVQ Q0, Y0
	OP(MOVQ, 	Q1, Q2, Q3, Q4, Q5, 	Y1, Y2, Y3, Y4, Y5)
	SUBQ X0, Y0
	OP(SBBQ, 	X1, X2, X3, X4, X5, 	Y1, Y2, Y3, Y4, Y5)
	MOVQ Y0, D0
	OP(MOVQ, 	Y1, Y2, Y3, Y4, Y5, 	D1, D2, D3, D4, D5)
	RET

TEXT ·fqMul(SB),4,$96-24
	GET_A(DI)
	GET_B(SI)
	MOVQ 0(DI), INPUT
	MULINPUT(0)
	MOVQ AX, tmp-96(SP)
	MULSTEP1(1, X0)
	MULSTEP1(2, X1)
	MULSTEP1(3, X2)
	MULSTEP1(4, X3)
	MULSTEP1(5, X4)
	MOVQ DX, X5
	MOVQ $1, BASE
 mul_loop:
	MOVQ (DI)(BASE*8), INPUT
	MULINPUT(0)
	ADDQ AX, X0 
	MOVQ X0, tmp-96(SP)(BASE*8)
	ADCQ $0, DX
	MULSTEP2(1, X1, X0)
	MULSTEP2(2, X2, X1)
	MULSTEP2(3, X3, X2)
	MULSTEP2(4, X4, X3)
	MULSTEP2(5, X5, X4)
	MOVQ DX, X5
	INCQ BASE
	CMPL BASE, $6
	JNE mul_loop
	MOVQ X0, tmp-48(SP)
	MOVQ X1, tmp-40(SP)
	MOVQ X2, tmp-32(SP)
	MOVQ X3, tmp-24(SP)
	MOVQ X4, tmp-16(SP)
	MOVQ X5, tmp-8(SP)
	MOVQ $0, BASE
	MOVQ $0, PCARRY
	GET_C(DI)
	MOVQ tmp-96(SP), X0
	MOVQ tmp-88(SP), X1
	MOVQ tmp-80(SP), X2
	MOVQ tmp-72(SP), X3
	MOVQ tmp-64(SP), X4
	MOVQ tmp-56(SP), X5
 redc_loop:
	MOVQ QINV, AX
	MULQ X0
	MOVQ AX, INPUT
	MULQ Q0
	ADDQ X0, AX
	ADCQ $0, DX
	REDCSTEP(1,Q1,X1,X0)
	REDCSTEP(2,Q2,X2,X1)
	REDCSTEP(3,Q3,X3,X2)
	REDCSTEP(4,Q4,X4,X3)
	REDCSTEP(5,Q5,X5,X4)
	MOVQ tmp-48(SP)(BASE*8), X5
	ADDQ PCARRY, X5
	MOVQ $0, PCARRY
	SETCS PCARRY
	ADDQ DX, X5
	ADCQ $0, PCARRY
	INCQ BASE
	CMPL BASE, $6
	JNE redc_loop
	REDUCE_X
	MOVQ X0, D0
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	D1, D2, D3, D4, D5)
	RET

TEXT ·fqREDC(SB),4,$0-16
	GET_A(SI)
	MOVQ $0, BASE
	MOVQ $0, PCARRY
	GET_C(DI)
	MOVQ 0(SI), X0
	MOVQ 8(SI), X1
	MOVQ 16(SI), X2
	MOVQ 24(SI), X3
	MOVQ 32(SI), X4
	MOVQ 40(SI), X5
 redc_loop:
	MOVQ QINV, AX
	MULQ X0
	MOVQ AX, INPUT
	MULQ Q0
	ADDQ X0, AX
	ADCQ $0, DX
	REDCSTEP(1,Q1,X1,X0)
	REDCSTEP(2,Q2,X2,X1)
	REDCSTEP(3,Q3,X3,X2)
	REDCSTEP(4,Q4,X4,X3)
	REDCSTEP(5,Q5,X5,X4)
	MOVQ 48(SI)(BASE*8), X5
	ADDQ PCARRY, X5
	MOVQ $0, PCARRY
	SETCS PCARRY
	ADDQ DX, X5
	ADCQ $0, PCARRY
	INCQ BASE
	CMPL BASE, $6
	JNE redc_loop
	REDUCE_X
	MOVQ X0, D0
	OP(MOVQ, 	X1, X2, X3, X4, X5, 	D1, D2, D3, D4, D5)
	RET

TEXT ·lfqMul(SB),4,$0-24
	GET_A(DI)
	GET_B(SI)
	GET_C(CPTR)
	MOVQ 0(DI), INPUT
	MULINPUT(0)
	MOVQ AX, (CPTR)
	MULSTEP1(1, X0)
	MULSTEP1(2, X1)
	MULSTEP1(3, X2)
	MULSTEP1(4, X3)
	MULSTEP1(5, X4)
	MOVQ DX, X5
	MOVQ $1, BASE
 mul_loop:
	MOVQ (DI)(BASE*8), INPUT
	MULINPUT(0)
	ADDQ AX, X0 
	MOVQ X0, (CPTR)(BASE*8)
	ADCQ $0, DX
	MULSTEP2(1, X1, X0)
	MULSTEP2(2, X2, X1)
	MULSTEP2(3, X3, X2)
	MULSTEP2(4, X4, X3)
	MULSTEP2(5, X5, X4)
	MOVQ DX, X5
	INCQ BASE
	CMPL BASE, $6
	JNE mul_loop
	MOVQ X0, 48(CPTR)
	MOVQ X1, 56(CPTR)
	MOVQ X2, 64(CPTR)
	MOVQ X3, 72(CPTR)
	MOVQ X4, 80(CPTR)
	MOVQ X5, 88(CPTR)
	RET

