#Jeremy Thomas
#UID: 118511054
#jthoma38

.data
newline:    .asciiz "\n"

.text

# strlen function definition
strlen:
    # PROLOGUE
    subu $sp, $sp, 8       # Grow stack by 8
    sw $ra, 8($sp)         # Save $ra
    sw $fp, 4($sp)         # Save $fp
    addu $fp, $sp, 8       # Set $fp to $ra

    # BODY
    li $t0, 0              # Initialize t0 to length 0
for:
    lb $t1, 0($a0)         # Load first char of string
    beqz $t1, strlenend    # End if last char
    add $t0, $t0, 1        # Length is increased
    add $a0, $a0, 1        # Next character is pointed to
    j for
strlenend:
    move $v0, $t0          # Move string length to return register

    # EPILOGUE
    move $sp, $fp          # Restore stack pointer
    lw $ra, 0($fp)         # Restore $ra
    lw $fp, -4($sp)        # Restore $fp
    jr $ra                 # Jump to $ra

# is_palindrome function definition
is_palindrome:
    # PROLOGUE
    subu $sp, $sp, 8       # Grow stack by 8
    sw $ra, 8($sp)         # Save $ra
    sw $fp, 4($sp)         # Save $fp
    addu $fp, $sp, 8       # Set $fp to $ra

    # BODY
    move $t5, $a0          # t5 is the string
    jal strlen             # Retrieve strlen
    li $t1, 0              # t1 index pointer

    subu $t2, $v0, 1        # len - 1
    add $t4, $t5, $t2       # t4 is end of string
    srl $v0, $v0, 1         # Divided by 2 and cut

while:
    addu $t5, $t5, $t1      # Stores $t1 string in t5
    subu $t4, $t4, $t1      # t4 is the string - 1
    lb $t6, 0($t5)          # First character of original string
    lb $t7, 0($t4)          # First char of the string before $t5
    bne $t6, $t7, not_pal   # If they are not equal, then not a palindrome
    addu $t1, $t1, 1        # t1 goes to next
    blt $t1, $v0, while

    li $v0, 1
    j end

not_pal:
    li $v0, 0               # Not a palindrome

end:
    # EPILOGUE
    move $sp, $fp          # Restore $sp
    lw $ra, ($sp)         # Restore $ra
    lw $fp, -4($sp)         # Restore $fp
    jr $ra                 # Jump to $ra








