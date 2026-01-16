	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"Hello World :D"
	.text
	.globl	hello
	.type	hello, @function
hello:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	hello, .-hello
	.section	.rodata
.LC1:
	.string	"Nho em qua :("
	.text
	.globl	hello_callback_function
	.type	hello_callback_function, @function
hello_callback_function:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	hello_callback_function, .-hello_callback_function
	.globl	func
	.section	.data.rel.local,"aw"
	.align 8
	.type	func, @object
	.size	func, 8
func:
	.quad	hello_callback_function
	.text
	.globl	add
	.type	add, @function
add:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %edx
	movl	%esi, %eax
	movb	%dl, -4(%rbp)
	movb	%al, -8(%rbp)
	movzbl	-4(%rbp), %edx
	movzbl	-8(%rbp), %eax
	addl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	add, .-add
	.globl	func_ptr
	.section	.data.rel.local
	.align 8
	.type	func_ptr, @object
	.size	func_ptr, 8
func_ptr:
	.quad	hello
	.globl	fp
	.align 8
	.type	fp, @object
	.size	fp, 8
fp:
	.quad	add
	.section	.rodata
.LC2:
	.string	"%s"
.LC3:
	.string	"option1"
.LC4:
	.string	"option2"
.LC5:
	.string	"option3"
.LC6:
	.string	"exit"
.LC7:
	.string	"Tong 2 so a va b la: %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
.L14:
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movb	$0, -115(%rbp)
	movb	$0, -114(%rbp)
	movb	$0, -113(%rbp)
	leaq	-112(%rbp), %rax
	leaq	.LC3(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L6
	movb	$1, -115(%rbp)
	movb	$0, -114(%rbp)
	movb	$0, -113(%rbp)
	jmp	.L7
.L6:
	leaq	-112(%rbp), %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L8
	movb	$0, -115(%rbp)
	movb	$1, -114(%rbp)
	movb	$0, -113(%rbp)
	jmp	.L7
.L8:
	leaq	-112(%rbp), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L9
	movb	$0, -115(%rbp)
	movb	$0, -114(%rbp)
	movb	$1, -113(%rbp)
	jmp	.L7
.L9:
	leaq	-112(%rbp), %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L7
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L15
	jmp	.L16
.L7:
	movzbl	-115(%rbp), %eax
	testb	%al, %al
	je	.L11
	movq	func_ptr(%rip), %rdx
	movl	$0, %eax
	call	*%rdx
	jmp	.L14
.L11:
	movzbl	-114(%rbp), %eax
	testb	%al, %al
	je	.L13
	movq	fp(%rip), %rax
	movl	$5, %esi
	movl	$10, %edi
	call	*%rax
	movzbl	%al, %eax
	movl	%eax, %esi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L14
.L13:
	movq	func(%rip), %rax
	call	*%rax
	jmp	.L14
.L16:
	call	__stack_chk_fail@PLT
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
