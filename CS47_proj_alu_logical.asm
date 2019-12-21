.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
# TBD: Complete it
# Caller RTE store (TBD)
	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52
	
	#don't use t0
	#don't use t2
	li $v0,0x0
	li $v1,0x0
	mthi $zero
	mtlo $zero
	
	li $t3,0x0000002B
	li $t4,0x0000002D
	li $t5,0x0000002A
	li $t6,0x0000002F
	beq $a2,$t3,addition
	beq $a2,$t4,subtraction
	beq $a2,$t5,multiplication
	beq $a2,$t6,division	
	
addition:
	li $a2,0x00000000
	jal add_Sub
	b return
subtraction:
	li $a2,0xFFFFFFFF
	jal add_Sub
	b return
multiplication:
	#mult $a0,$a1
	#mfhi $v1
	#mflo $v0
	jal mul_signed
	b return
division:
	#div $a0,$a1
	#mfhi $v1
	#mflo $v0
	jal div_signed
	b return




return:
	lw   	$fp, 52($sp)
	lw   	$ra, 48($sp)
	lw	$a0,44($sp)
	lw	$a1,40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	
	jr	$ra
	
	
	
#####################################################################
# Uses $s0-$s7,$t2 but not really just for macro
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2:0x00000000 ||0xFFFFFFFFF
# Return:
#	$v0: ($a0+$a1) 
#	$v1: carryout
# Notes:
#####################################################################
add_Sub:

	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52
	
	li $s0,0x0
	li $s1,0x0

	extract_nth_bit($s2,$a2,$s0)
	beqz $s2,start
	not $a1,$a1
	
start:	
	extract_nth_bit($s3,$a0,$s0)
	extract_nth_bit($s4,$a1,$s0)
	xor $s5,$s3,$s4
	and $s6,$s3,$s4
	xor $s7,$s2,$s5
	and $s2,$s2,$s5
	or $s2,$s2,$s6
	insert_one_to_nth_bit ($v0, $s0, $s7, $t2)
	addi $s0,$s0,0x1
	bne $s0,0x20,start
	move  $v1,$s2
	
return_from_Add_Sub:

	lw 	$fp,52($sp)
	lw	$ra,48($sp)
	lw   	$a0, 44($sp)
	lw   	$a1, 40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	
	jr	$ra

#####################################################################
# Uses 
# Argument:
# 	$a0: First number
# Return:
#	$v0: two's complement of $a0 
# Notes:
#####################################################################
twos_complement:
	addi	$sp,$sp,-12
	sw   	$fp, 12($sp)
	sw   	$ra, 8($sp)
	addi 	$fp,$sp,12
	
	not $a0,$a0
	li $a1,0x1
	li $a2,0x0
	move $t4,$v1
	jal add_Sub
	move $v1,$t4
	
return_from_twos_complement:

	lw   	$fp, 12($sp)
	lw   	$ra, 8($sp)
	addi 	$sp,$sp,12
	
	jr	$ra
	

#####################################################################
# Uses 
# Argument:
# 	$a0: First number
# Return:
#	$v0: two's complement of $a0 
# Notes:
#####################################################################
twos_complement_if_neg:
	addi	$sp,$sp,-12
	sw   	$fp, 12($sp)
	sw   	$ra, 8($sp)
	addi 	$fp,$sp,12
	
	bltz	$a0,get_Twos_complement
	move	 $v0,$a0
	beqz 	$a0,return_from_twos_complement_if_neg		
	bgtz 	$a0,return_from_twos_complement_if_neg
	
get_Twos_complement:

	jal twos_complement					
									
return_from_twos_complement_if_neg:
	
	lw   	$fp, 12($sp)
	lw   	$ra, 8($sp)
	addi 	$sp,$sp,12
	
	jr	$ra	
	
	

#####################################################################
# Uses s0,s1
# Argument:
# 	$a0: Lo of the Number
#	$a1: Hi of the number
# Return:
#	$v0: Lo parttwo's complement of $a0 
#	$v1: Hi part of 2's complemented 64 bit
# Notes:
#####################################################################
twos_complement_64bit:
	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52
	
	not $a0,$a0	#invert a0
	not $s0,$a1	#invert a1, store in s0
	li  $a1,0x1
	li  $a2,0x0	#set a1 to 1
	jal add_Sub	#add a0 and a1, a0 and 1
	move $s1,$v0	#move a0 to s1, move complemented a0 into storage
	move $a0,$s0	#repeat process with s0, the inverted a1
	move $a1,$v1
	li  $a2,0x0	#prepare a1 to add s0, the inverted a1, with the carryin from a0's inversion
	jal add_Sub	#adds inverted a1 with carry in
	move $v1,$v0	#moves result of a1's addition with carry in to proper output
	move $v0,$s1	#moves a0's inversion and addition into the proper output
	
return_from_complement_64bit:
	
	
	lw   	$fp, 52($sp)
	lw   	$ra, 48($sp)
	lw	$a0,44($sp)
	lw	$a1,40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	
	jr	$ra
	
#####################################################################
# Uses 
# Argument:
# 	$a0: 0x0 or 0x1
# Return:
#	$v0: 0x00000000 or 0xFFFFFFFFF  
# Notes:
#####################################################################
bit_replicator:
	addi	$sp,$sp,-12
	sw   	$fp, 12($sp)
	sw   	$ra, 8($sp)
	addi 	$fp,$sp,12


	li $v0,0x00000000		#default answer
	beqz $a0,return_from_bit_replicator #if default is acceptable, end
	li $v0,0xFFFFFFFF		#else use this answer
	
return_from_bit_replicator:
	
	lw   	$fp, 12($sp)	
	lw   	$ra, 8($sp)
	addi 	$sp,$sp,12
	
	jr	$ra	

	
		
#####################################################################
# Uses $s0-$s7,$t2 but not really just for macro
# Argument:
# 	$a0: multiplicand
#	$a1: multiplier
# Return:
#	$v0: Lo of result 
#	$v1: Hi of result
# Notes:
#####################################################################			
mul_unsigned:
	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52

	li $s0,0x0	#s-=I=0
	li $s1,0x0	#s1=H=0
	move $s2,$a1	#s2=L=Multiplier
	move $s3, $a0	#s3=M=Multiplicand
	
start_mul_unsigned: 
	extract_nth_bit($s4, $s2, $zero)	#s4=R=extract 0th bit from L
	move $a0,$s4				#move s4 into A0 to be replicated
	jal bit_replicator			#replicate
	move $s4,$v0				#move replicated s4 back into s4
	
	and $s5,$s3,$s4				#s5=x=M and R
	
	move $a0,$s1				#move H into A0 for addition
	move $a1,$s5
	li $a2,0				#move X into A1 for addition
	jal add_Sub				#v0=H+X
	move $s1,$v0				#move S1=H=H+X
	
	srl $s2,$s2,0x1				#shift s2=L right by 1
	
	extract_nth_bit($s6, $s1, $zero)	#s6=H[0]
	li $t9,0x1F				#t1=31
	insert_one_to_nth_bit ($s2, $t9, $s6, $t8)	#insert H[0] into L[31]
	
	srl $s1,$s1,0x1				#shift s1=H to the right
	
	addi $s0,$s0,0x1			#add 1 to index s0=I
	bne $s0,0x20,start_mul_unsigned		#start the procedure again if index is not 32
	move $v1,$s1
	move $v0,$s2
return_from_mul_unsigned:
	
	
	lw   	$fp, 52($sp)
	lw   	$ra, 48($sp)
	lw	$a0,44($sp)
	lw	$a1,40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	
	jr	$ra	
	
#####################################################################
# Uses $s0-$s7,$t2 but not really just for macro
# Argument:
# 	$a0: multiplicand
#	$a1: multiplier
# Return:
#	$v0: Lo of result 
#	$v1: Hi of result
# Notes:
#####################################################################			
mul_signed:
	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52 
	
	
	
	move $s6,$a0
	move $s7,$a1
	li $t4,0x1F
	extract_nth_bit($s3, $a0, $t4)
	extract_nth_bit($s4, $a1, $t4)
	xor $s5,$s3,$s4
	
	jal twos_complement_if_neg 
	move $s0,$v0
	move $a0,$s7
	jal twos_complement_if_neg
	move $s1,$v0
				
	move $a0,$s0
	move $a1,$s1
	jal mul_unsigned
	
	beqz $s5,return_from_mul_signed
	move $a0,$v0
	move $a1,$v1
	jal twos_complement_64bit
	
return_from_mul_signed:
	
	lw   	$fp, 52($sp)
	lw   	$ra, 48($sp)
	lw	$a0,44($sp)
	lw	$a1,40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	jr	$ra	
		
#####################################################################
#
# Argument:
# 	$a0: Dividend
#	$a1: Divisor
# Return:
#	$v0: Quotient 
#	$v1: remainder
# Notes:
#####################################################################			
div_unsigned:
	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52 #Start from here
	
	li $s0,0x0	#S0=I=0
	move $s1,$a0	#S1=A0=Q=DVND
	move $s2,$a1	#S2=A1=D=DVSR
	li $s3,0x0	#S3=R=0
	
start_div_unsigned:	
	sll $s3,$s3,0x1 #shift s3=R left by 1
	li $t2, 0x1F	#t2=31
	extract_nth_bit($t3, $s1, $t2) #extract 31st bit from s1=Q and put in t3 
	insert_one_to_nth_bit ($s3, $zero, $t3, $t4) #insert Q's[31] bit into s3=R=[0]
	
	sll $s1,$s1,0x1	#
	move $a0,$s3	#	#s3=R
	move $a1,$s2	#	#s2=D
	li $a2,0xFFFFFFFF	#a2=- operation
	jal add_Sub		#V0= R-D
	
	move $s4,$v0		#S4=S=V0=R-D
	
	bltz $s4,increment_index	#if S4=S>0 skip next lines
	#beqz $s4,increment_index	#if S4=S=0 skip next lines
	
	move $s3,$s4			#s3=R=S=S4
	li $t6 0x1			#t6=1
	insert_one_to_nth_bit ($s1, $zero, $t6, $t7) #insert 1 into S1=Q[0]
	
increment_index:
	addi $s0,$s0,0x1 #increment s0=I index
	bne  $s0,0x20, start_div_unsigned	#if index!=32 restart
	move $v0,$s1	#move s1=Q to V0
	move $v1,$s3	#move s3=R to V1
return_from_div_unsigned:
	
	lw   	$fp, 52($sp)
	lw   	$ra, 48($sp)
	lw	$a0,44($sp)
	lw	$a1,40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	jr	$ra	

				
#####################################################################
#
# Argument:
# 	$a0: Dividend
#	$a1: Divisor
# Return:
#	$v0: Quotient 
#	$v1: remainder
# Notes:
#####################################################################			
div_signed:
	addi	$sp,$sp,-52
	sw   	$fp, 52($sp)
	sw   	$ra, 48($sp)
	sw	$a0,44($sp)
	sw	$a1,40($sp)
	sw 	$s0, 36($sp)
	sw 	$s1, 32($sp)
	sw 	$s2, 28($sp)
	sw 	$s3, 24($sp)
	sw 	$s4, 20($sp)
	sw 	$s5, 16($sp)
	sw 	$s6, 12($sp)
	sw 	$s7, 8($sp)
	addi 	$fp,$sp,52 #Start from here
	
	move $s6,$a0
	move $s7,$a1
	li $t4,0x1F
	extract_nth_bit($s3, $a0, $t4)
	extract_nth_bit($s4, $a1, $t4)
	xor $s5,$s3,$s4
	
	jal twos_complement_if_neg 
	move $s0,$v0
	move $a0,$s7
	jal twos_complement_if_neg
	move $s1,$v0
				
	move $a0,$s0
	move $a1,$s1
	jal div_unsigned #This is it please don't skip it or else it'll be a big hedache and I hope this shows on the mips debugger
	
	move $s6,$v0
	beqz $s5,check_remainder
	move $a0,$v0
	jal twos_complement
	move $s6,$v0
	
check_remainder:	
	beqz $s3,return_from_div_signed
	#move $s6,$v0
	move $a0,$v1
	jal twos_complement
	move $v1,$v0
	move $v0,$s6
	
return_from_div_signed:
	
	lw   	$fp, 52($sp)
	lw   	$ra, 48($sp)
	lw	$a0,44($sp)
	lw	$a1,40($sp)
	lw 	$s0, 36($sp)
	lw 	$s1, 32($sp)
	lw 	$s2, 28($sp)
	lw 	$s3, 24($sp)
	lw 	$s4, 20($sp)
	lw 	$s5, 16($sp)
	lw 	$s6, 12($sp)
	lw 	$s7, 8($sp)
	addi 	$sp,$sp,52
	jr	$ra	
			