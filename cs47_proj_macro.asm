# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#
#
#regT nth bit specifier
#regS source
#regD return extract
.macro extract_nth_bit($regD, $regS, $regT)
li $t0,0x0
srlv  $t0,$regS,$regT
and $regD,$t0,0x1
.end_macro 

#regD pattern after inserting bit
#regS shitf amout
#regT bit value to insert
#maskReg temporary mask
#uses t1
.macro insert_one_to_nth_bit ($regD, $regS, $regT, $maskReg)
li $t1,0x1
sllv $maskReg ,$t1,$regS
not $maskReg,$maskReg
and $regD,$regD,$maskReg
sllv $t1,$regT,$regS
or $regD,$regD,$t1
.end_macro 
