main:
    li x10, 5
    jal x1, fact

    addi x11, x10, 0
    li x10, 1
    ecall
    j exit

fact:
    li x6, 1

Loop:
    bge x0, x10, done
    mul x6, x6, x10
    addi x10, x10, -1
    j Loop

done:
    add x10, x6, x0
    jalr x0, 0(x1)

exit:
end:
    j end