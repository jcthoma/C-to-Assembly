   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 12
   .word 225
   .word 169
   .word 16
   .word 25
   .word 100
   .word 81
   .word 99
   .word 121
   .word 144
   .word 0 

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", isqrt(*j))
#     j++
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1           # result (in v0) = isqrt(*j)
   jal  isqrt              # 
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main #################################################
.data
newline:    .asciiz "\n"

.text

# isqrt function definition
isqrt:
    # PROLOGUE 
    subu $sp, $sp, 8        # Grow stack
    sw $ra, 8($sp)          # Save $ra
    sw $fp, 4($sp)          # Save $fp
    addu $fp, $sp, 8        # Set $fp to $ra

    li $t2, 1               # Used in bgt
    bgt $a0, $t2, rec       # If $a0 > 2, go to rec
    move $v0, $a0           # Return n
    j end

rec:
    sub $sp, $sp, 4         # Allocating space for n
    sw $a0, 4($sp)          # Put n on stack
    srl $a0, $a0, 2         # Shift n right by 2 bits
    jal isqrt               # Do recursive call
    lw $t4, 4($sp)         

    move $t0, $v0           # $t0 is return value
    sll $t1, $t0, 1         # $t1 is small, moved byte
    add $t2, $t1, 1         # $t2 is large
    
    mul $t3, $t2, $t2       # $t3 is large * large
    move $v0, $t1           # Return value for small

    bgt $t3, $t4, end       # If large * large > n, return
    move $v0, $t2           # If $t3 is < n, then return large

end:
    # EPILOGUE
    move $sp, $fp           # Restore stack pointer
    lw $ra, 8($fp)          # Restore $ra
    lw $fp, 4($fp)          # Restore $fp
    jr $ra                  # Jump to $ra
