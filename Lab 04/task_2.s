main:
    li x10, 5
    jal x1, fact

    addi x11, x10, 0
    li x10, 1
    ecall
    j exit

fact:
    addi sp, sp, -8
    sw x1, 4(sp)
    sw x10, 0(sp)

    li x6, 1
    bge x0, x10, base

    addi x10, x10, -1
    jal x1, fact

    add x7, x10, x0
    lw x10, 0(sp)
    lw x1, 4(sp)
    addi sp, sp, 8
    add x10, x10, x7
    jalr x0, 0(x1)

base:
    li x10, 0
    lw x1, 4(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)

exit:
end:
    j end