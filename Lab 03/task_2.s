main:
    addi x10, x0, 12      # g=12
    addi x11, x0, 10      # h=10
    addi x12, x0, 5       # i=5
    addi x13, x0, 4       # j=4
    jal x1, leaf_example   # function call and then save the address to x1
    addi x11, x10, 0      # move result into x11 for printing
    li x10, 1

    ecall
    j exit

leaf_example:
    addi sp, sp, -12
    sw x18, 0(sp)
    sw x19, 4(sp)
    sw x20, 8(sp)

    add x18, x10, x11
    add x19, x12, x13
    sub x20, x18, x19
    addi x10, x20, 0

    lw x18, 0(sp)
    lw x19, 4(sp)
    lw x20, 8(sp)
    addi sp, sp, 12
    jalr x0, 0(x1)

exit: