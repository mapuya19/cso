	.file	"c_animals.c"
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "yes\0"
.LC1:
	.ascii "y\0"
.LC2:
	.ascii "no\0"
.LC3:
	.ascii "n\0"
.LC4:
	.ascii "Please enter \"yes\" or \"no\" > \0"
	.text
	.globl	yes_response_c
	.def	yes_response_c;	.scl	2;	.type	32;	.endef
	.seh_proc	yes_response_c
yes_response_c:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$240, %rsp
	.seh_stackalloc	240
	.seh_endprologue
.L7:
	leaq	-208(%rbp), %rax
	movl	$200, %edx
	movq	%rax, %rcx
	call	read_line
	leaq	-208(%rbp), %rax
	leaq	.LC0(%rip), %rdx
	movq	%rax, %rcx
	call	strcasecmp
	testl	%eax, %eax
	je	.L2
	leaq	-208(%rbp), %rax
	leaq	.LC1(%rip), %rdx
	movq	%rax, %rcx
	call	strcasecmp
	testl	%eax, %eax
	jne	.L3
.L2:
	movl	$1, -4(%rbp)
	jmp	.L4
.L3:
	leaq	-208(%rbp), %rax
	leaq	.LC2(%rip), %rdx
	movq	%rax, %rcx
	call	strcasecmp
	testl	%eax, %eax
	je	.L5
	leaq	-208(%rbp), %rax
	leaq	.LC3(%rip), %rdx
	movq	%rax, %rcx
	call	strcasecmp
	testl	%eax, %eax
	jne	.L6
.L5:
	movl	$0, -4(%rbp)
	jmp	.L4
.L6:
	leaq	.LC4(%rip), %rcx
	call	printf
	jmp	.L7
.L4:
	movl	-4(%rbp), %eax
	addq	$240, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.globl	new_node_c
	.def	new_node_c;	.scl	2;	.type	32;	.endef
	.seh_proc	new_node_c
new_node_c:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movl	$216, %ecx
	call	malloc
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, 208(%rax)
	movq	-8(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 200(%rax)
	movq	-8(%rbp), %rax
	movq	16(%rbp), %rdx
	movq	%rax, %rcx
	call	strcpy
	movq	-8(%rbp), %rax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC5:
	.ascii "I give up! What animal is it? > \0"
.LC6:
	.ascii "I'm guessing: %s\12\0"
.LC7:
	.ascii "Am I right? > \0"
.LC8:
	.ascii "I win!\0"
	.align 8
.LC9:
	.ascii "\12oops.  What animal were you thinking of? > \0"
	.align 8
.LC10:
	.ascii "Enter a yes/no question to distinguish between a %s and a %s > \0"
	.align 8
.LC11:
	.ascii "What is the answer for a %s (yes or no) > \0"
.LC12:
	.ascii "%s (yes/no) > \0"
	.text
	.globl	guess_animal_c
	.def	guess_animal_c;	.scl	2;	.type	32;	.endef
	.seh_proc	guess_animal_c
guess_animal_c:
	pushq	%rbp
	.seh_pushreg	%rbp
	subq	$256, %rsp
	.seh_stackalloc	256
	leaq	128(%rsp), %rbp
	.seh_setframe	%rbp, 128
	.seh_endprologue
	movq	.refptr.root(%rip), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L12
	movl	$216, %ecx
	call	malloc
	movq	%rax, 120(%rbp)
	movq	120(%rbp), %rax
	movq	$0, 208(%rax)
	movq	120(%rbp), %rax
	movq	208(%rax), %rdx
	movq	120(%rbp), %rax
	movq	%rdx, 200(%rax)
	leaq	.LC5(%rip), %rcx
	call	printf
	movq	120(%rbp), %rax
	movl	$200, %edx
	movq	%rax, %rcx
	call	read_line
	movq	.refptr.root(%rip), %rax
	movq	120(%rbp), %rdx
	movq	%rdx, (%rax)
	jmp	.L21
.L12:
	movq	.refptr.root(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, 120(%rbp)
.L20:
	movq	120(%rbp), %rax
	movq	200(%rax), %rax
	testq	%rax, %rax
	jne	.L14
	movq	120(%rbp), %rax
	movq	208(%rax), %rax
	testq	%rax, %rax
	jne	.L14
	movq	120(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rcx
	call	printf
	leaq	.LC7(%rip), %rcx
	call	printf
	call	yes_response
	testl	%eax, %eax
	je	.L15
	leaq	.LC8(%rip), %rcx
	call	puts
	jmp	.L13
.L15:
	leaq	.LC9(%rip), %rcx
	call	printf
	leaq	-96(%rbp), %rax
	movl	$200, %edx
	movq	%rax, %rcx
	call	read_line
	leaq	-96(%rbp), %rax
	movq	%rax, %rcx
	call	new_node_c
	movq	%rax, 112(%rbp)
	movq	120(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %r8
	movq	%rax, %rdx
	leaq	.LC10(%rip), %rcx
	call	printf
	leaq	-96(%rbp), %rax
	movl	$200, %edx
	movq	%rax, %rcx
	call	read_line
	movq	112(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC11(%rip), %rcx
	call	printf
	call	yes_response
	testl	%eax, %eax
	je	.L16
	movq	120(%rbp), %rax
	movq	112(%rbp), %rdx
	movq	%rdx, 200(%rax)
	movq	120(%rbp), %rax
	movq	%rax, %rcx
	call	new_node_c
	movq	%rax, %rdx
	movq	120(%rbp), %rax
	movq	%rdx, 208(%rax)
	jmp	.L17
.L16:
	movq	120(%rbp), %rax
	movq	112(%rbp), %rdx
	movq	%rdx, 208(%rax)
	movq	120(%rbp), %rax
	movq	%rax, %rcx
	call	new_node_c
	movq	%rax, %rdx
	movq	120(%rbp), %rax
	movq	%rdx, 200(%rax)
.L17:
	movq	120(%rbp), %rax
	leaq	-96(%rbp), %rdx
	movq	%rax, %rcx
	call	strcpy
	jmp	.L13
.L14:
	movq	120(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC12(%rip), %rcx
	call	printf
	call	yes_response
	testl	%eax, %eax
	je	.L18
	movq	120(%rbp), %rax
	movq	200(%rax), %rax
	movq	%rax, 120(%rbp)
	jmp	.L20
.L18:
	movq	120(%rbp), %rax
	movq	208(%rax), %rax
	movq	%rax, 120(%rbp)
	jmp	.L20
.L13:
.L21:
	nop
	addq	$256, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (GNU) 7.4.0"
	.def	read_line;	.scl	2;	.type	32;	.endef
	.def	strcasecmp;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	strcpy;	.scl	2;	.type	32;	.endef
	.def	yes_response;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr.root, "dr"
	.globl	.refptr.root
	.linkonce	discard
.refptr.root:
	.quad	root
