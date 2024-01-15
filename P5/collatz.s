#Jeremy Thomas
#UID: 118511054
#jthoma38

.data
newline:    .asciiz "\n"

.text

collatz:
    # PROLOGUE
    subu $sp, $sp, 8      # grow stack 8B
    sw   $ra, 8($sp)      # push $ra
    sw   $fp, 4($sp)      # push $fp
    addu $fp, $sp, 8      # fp is set to ra

    li   $t3, 1           # sets $t3 to 1
    beq $s1, $t3, end     # check if n == 1, terminate recursion
    li $t4, 2             # stores 2 into t4
    rem $t5, $s1, 2
    beq $t5, $t3, odd     # if t5 is equal to 1 then n is odd, goes to dd
	
even:

    li $t7, 2               # t7 stores the value of 2
    div $s1, $s1, $t7
	
    addi $s2, $s2, 1

    subu $sp, $sp, 8        # makes space for n and d
 
    sw $s1, 4($sp) 	
    sw $s2, 0($sp)

    jal  collatz            # go to collatz
    j    end
	
odd:

    li   $t6, 3             # sets 3 as t6

    mul $s1, $s1, $t6
    addi $s1, $s1, 1
	
    addi $s2, $s2, 1
	
    subu $sp, $sp, 8        # makes space for n and d
    sw $s1, 4($sp)
    sw $s2, 0($sp)
	

    jal  collatz            # go to collatz
    j    end


end:
    move $v0, $s2

    move $sp, $fp
    lw   $ra, 0($fp)
    lw   $fp, -4($sp)
    jr   $ra
