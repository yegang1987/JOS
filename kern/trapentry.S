/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text
TRAPHANDLER_NOEC(e_00h, 0x00);
TRAPHANDLER_NOEC(e_01h, 0x01);
TRAPHANDLER_NOEC(e_02h, 0x02);
TRAPHANDLER_NOEC(e_03h, 0x03);
TRAPHANDLER_NOEC(e_04h, 0x04);
TRAPHANDLER_NOEC(e_05h, 0x05);
TRAPHANDLER_NOEC(e_06h, 0x06);
TRAPHANDLER_NOEC(e_07h, 0x07);
TRAPHANDLER(e_08h, 0x08);
TRAPHANDLER_NOEC(e_09h, 0x09);
TRAPHANDLER(e_0ah, 0x0a);
TRAPHANDLER(e_0bh, 0x0b);
TRAPHANDLER(e_0ch, 0x0c);
TRAPHANDLER(e_0dh, 0x0d);
TRAPHANDLER(e_0eh, 0x0e);
TRAPHANDLER_NOEC(e_10h, 0x10);
TRAPHANDLER_NOEC(msyscall, 0x30);

_alltraps:
	push %ds;	#tf_ds
	push %es;	#tf_es
	pushal;
	mov $(GD_KD), %edx
	mov %dx, %ds;
	mov %dx, %es;
	mov %dx, %fs;
	push %esp;	#push a pointer to trapframe
	call trap;
	addl $4, %esp;	#clean up argument
	popal;
	pop %es;
	pop %ds;
	addl $8, %esp;
	iret;


