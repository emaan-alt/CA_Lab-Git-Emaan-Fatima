main:
    li x10, 0x400
    li x11, 5

    li x5, 4
    sw x5, 0(x10)
    li x5, 3
    sw x5, 4(x10)
    li x5, 4
    sw x5, 8(x10)
    li x5, 2
    sw x5, 12(x10)
    li x5, 10
    sw x5, 16(x10)

    jal x1, bubble
    j exit

bubble:
    beq x10, x0, Done
    beq x11, x0, Done

    li x28, 0
outer_loop:
    bge x28, x11, Done
    add x29, x28, x0

inner_loop:
    bge x29, x11, inner_done
    slli x5, x28, 2
    add x5, x5, x10
    slli x6, x29, 2
    add x6, x6, x10
    lw x7, 0(x5)
    lw x30, 0(x6)
    blt x7, x30, Do_swap
    j skip_swap

Do_swap:
    sw x30, 0(x5)
    sw x7, 0(x6)

skip_swap:
    addi x29, x29, 1
    j inner_loop

inner_done:
    addi x28, x28, 1
    j outer_loop

Done:
    jalr x0, 0(x1)

exit:
end:
    j end