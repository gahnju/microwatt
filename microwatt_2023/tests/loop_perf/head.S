/* Copyright 2013-2014 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define STACK_TOP 0x2000

/* Load an immediate 64-bit value into a register */
#define LOAD_IMM64(r, e)			\
	lis	r,(e)@highest;			\
	ori	r,r,(e)@higher;			\
	rldicr	r,r, 32, 31;			\
	oris	r,r, (e)@h;			\
	ori	r,r, (e)@l;

	.section ".head","ax"

	/*
	 * Microwatt currently enters in LE mode at 0x0, so we don't need to
	 * do any endian fix ups
	 */
	. = 0
.global _start
_start:
	b	boot_entry

.global boot_entry
boot_entry:
	/* setup stack */
	LOAD_IMM64(%r1, STACK_TOP - 0x100)
	LOAD_IMM64(%r12, main)
	mtctr	%r12
	bctrl
	attn // terminate on exit
	b .


.globl	test_code
test_code:
	li 	%r4, 0 # use r4 as loop counter
	li	%r5, 100
	li	%r6, 1

start_marker:
	// LOAD_IMM64(%r9, 0xdeadbeefbadeaffe) 
	//addi %r9,%r9,1 // start marker
	lis     %r9,-8531
	ori     %r9,%r9,48879
	rldicr  %r9,%r9,32,31
	oris    %r9,%r9,47838
	ori     %r9,%r9,45054
	std 	%r9, 32(%r1)
	ori 	%r2, %r2, 0
	ld 	%r9, 32(%r1)
	addi 	%r9, %r9, 1
	std 	%r9, 32(%r1) // start marker, load 0xdeadbeefbadeaffe to r9 and add 1
	
loop:
	cmpd 	%r4, %r5
	beq     end_marker
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	li	%r3, 1
	add 	%r4, %r4, %r6
	bl 	loop

end_marker:
	lis     %r9, -8531
	ori     %r9, %r9, 45054
	rldicr  %r9, %r9, 32, 31
	oris    %r9,%r9,47838
	ori     %r9,%r9,48879
	std     %r9,32(%r1)
	ori     %r2,%r2,0
	ld      %r9,32(%r1)
	addi    %r9,%r9,1
	std     %r9,32(%r1) // end marker, load 0xbadeaffedeadbeef to r9 and add 1
	//LOAD_IMM64(%r9, 0xbadeaffedeadbeef) 
	//addi %r9,%r9,1 // end marker
	nop
	blr
