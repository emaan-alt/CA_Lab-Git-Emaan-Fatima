main:
    addi x10, x0, 12    # x10 = 12
    addi x11, x0, 12    # x11 = 12
    jal x1, sum

    addi x11, x10, 0    # x11 fixed reg for printing
    li x10, 1           # x10 used to tell os about printing
    ecall

    j exit
sum:
    add x10, x10, x11
    jalr x0, 0(x1)
exit: