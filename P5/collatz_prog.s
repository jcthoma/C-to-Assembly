.data

# array terminated by 0 (which is not part of the array)
xarr:
.word 2, 4, 6, 8, 10, 0
.data

arrow: .asciiz " -> "

.text

main:
    li      $sp,        0x7ffffffc      # initialize $sp

# PROLOGUE
    subu    $sp,        $sp,        8   # expand stack by 8 bytes
    sw      $ra,        8($sp)          # push $ra (ret addr, 4 bytes)
    sw      $fp,        4($sp)          # push $fp (4 bytes)
    addu    $fp,        $sp,        8   # set $fp to saved $ra

    subu    $sp,        $sp,        12  # save s0 and s1 on stack before using them
    sw      $s0,        12($sp)         # push $s0
    sw      $s1,        8($sp)          # push $s1
    sw      $s2,        4($sp)          # push $s2

    la      $s0,        xarr            # load address to s0

main_for:
    lw      $s1,        ($s0)           # use s1 for xarr[i] value
    li      $s2,        0               # use s2 for initial depth (steps)
    beqz    $s1,        main_end        # if xarr[i] == 0, stop.

# save args on stack rightmost one first
    subu    $sp,        $sp,        8   # save args on stack
    sw      $s2,        8($sp)          # save depth
    sw      $s1,        4($sp)          # save xarr[i]

    li      $v0,        1
    move    $a0,        $s1             # print_int(xarr[i])
    syscall 

    li      $v0,        4               # print " -> "
    la      $a0,        arrow
    syscall 

    jal     collatz                     # result = collatz(xarr[i])

    move    $a0,        $v0             # print_int(result)
    li      $v0,        1
    syscall 

    li      $a0,        10              # print_char('\n')
    li      $v0,        11
    syscall 

    addu    $s0,        $s0,        4   # make s0 point to the next element

    lw      $s2,        8($sp)          # save depth
    lw      $s1,        4($sp)          # save xarr[i]
    addu    $sp,        $sp,        8   # save args on stack
    j       main_for

main_end:
    lw      $s0,        12($sp)         # push $s0
    lw      $s1,        8($sp)          # push $s1
    lw      $s2,        4($sp)          # push $s2

# EPILOGUE
    move    $sp,        $fp             # restore $sp
    lw      $ra,        ($fp)           # restore saved $ra
    lw      $fp,        -4($sp)         # restore saved $fp
    jr      $ra                         # return to kernel
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
