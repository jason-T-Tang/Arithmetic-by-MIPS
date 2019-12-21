.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
# Caller RTE store (TBD)
	addi	$sp,$sp,-12
	sw   	$fp, 12($sp)
	sw   	$ra, 8($sp)
	addi 	$fp,$sp,12
	
	li $t0,0x0000002B
	li $t1,0x0000002D
	li $t2,0x0000002A
	li $t3,0x0000002F
	beq $a2,$t0,addition
	beq $a2,$t1,subtraction
	beq $a2,$t2,multiplication
	beq $a2,$t3,division

addition:
	add   $v0,$a0,$a1
	b return
subtraction:
	sub $v0,$a0,$a1
	b return
multiplication:
	mult $a0,$a1
	mfhi $v1
	mflo $v0
	b return
division:
	div $a0,$a1
	mfhi $v1
	mflo $v0
	b return
return:
	lw   	$fp, 12($sp)
	lw   	$ra, 8($sp)
	addi 	$sp,$sp,12
	
	jr	$ra
	
