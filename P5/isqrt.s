#Jeremy Thomas
#UID: 118511054
#jthoma38
	
.data
newline:    .asciiz "\n"

.text
	
isqrt:
    # PROLOGUE 
    subu $sp, $sp, 8        # grow stack
    sw   $ra, 8($sp)        # $ra
    sw   $fp, 4($sp)        # $fp
    addu $fp, $sp, 8        # $fp to $ra

    li $t2, 1               #used in bgt
    bgt $a0, $t2, rec      # if  $a0 > 2, go to rec
    move $v0, $a0           # return n

    j end
    
rec:
    sub $sp, $sp, 4         # allocating space for n 
    sw $a0, 4($sp)        # put n on stack

    srl $a0, $a0, 2         # shift n right by 2 bits

    jal isqrt               # do recursive call
  
    lw $t4, 4($sp)              

    move $t0, $v0           # $t0 is return val
    sll $t1, $t0, 1        # t1 is  small, moved byte
    add $t2, $t1, 1         # t2 is large
    
    mul $t3, $t2, $t2     # t3 is large * large
    move $v0, $t1           # return value for small

    bgt $t3, $t4, end     # if large * large > n, return
    move $v0, $t2           # if t3 is <n then return  large
end:
    # EPILOGUE
    move $sp, $fp           # $sp
    lw   $ra, 0($fp)         #  $ra
    lw   $fp, -4($sp)       #  $fp
    jr   $ra                # jump 

