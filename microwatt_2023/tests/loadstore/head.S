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

        // prepare
        LOAD_IMM64(%r3, 0x2000) // address
        li %r4,0x04 // some values
        li %r5,0x05
        li %r6,0x06
        li %r7,0x07
        li %r8,0x08
        li %r9,0x09


        nop
        // test store w/o update
        std %r4,0(%r3)
        std %r5,8(%r3)
        stw %r6,16(%r3)
        stw %r7,20(%r3)
        stw %r8,24(%r3)
        stw %r9,28(%r3)

        // get the data and test
        ld  %r10, 0(%r3)
        ld  %r11, 8(%r3)
        lwz %r12,16(%r3)
        add %r20,%r4,%r5 // inject some other operation to see if it doesn't interfere with loads        
        lwz %r13,20(%r3)
        lwz %r14,24(%r3)
        add %r21, %r13, %r14 // test dependent operation
        lwz %r15,28(%r3)
	
	// end marker
	lis     %r9,-8531
	ori     %r9,%r9,45054
	rldicr  %r9,%r9,32,31
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
