#Jeremy Thomas
#UID: 118511054
#jthoma38

.data
newline:    .asciiz "\n"

.text

reverse_prefix_sum:
    # PROLOGUE

    subu $sp, $sp, 8        # Grow stack by 8 
    sw   $ra, 8($sp)        # Save $ra
    sw   $fp, 4($sp)        # Save $fp
    addu $fp, $sp, 8        # Set $fp to $ra

    # BODY
    lw $t3, 0($a0)           # Load the first element in t3
    li $t2, -1              # t2 is saved as -1
    bne $t3, $t2, rec        # If *arr != -1, go to rec

    li $v0, 0               # Return 0 if else
    subu $a0, $a0, 4        # Remove element from the stack
    j end

rec:
    subu $sp, $sp, 4          # Add space for word on the stack
    sw $t3, 4($sp)          # Store word on the stack in t3   
    addu $a0, $a0, 4          # Go to the next call of arr
    jal reverse_prefix_sum  # Go to reverse_prefix_sum

    lw $t0, 4($sp)          # t0 is the previous value
    addu $v0, $v0, $t0      # r = v0
    sw $v0, 0($a0)            # v0 is the array element
    subu $a0, $a0, 4        # Remove element from the stack

end:
    # EPILOGUE
    move $sp, $fp           # Restore $sp
    lw   $ra, 0($fp)        # Restore $ra
    lw   $fp, -4($sp)       # Restore $fp
    jr   $ra                # Return to the previous call
