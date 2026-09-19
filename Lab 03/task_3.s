main:
    addi sp, sp, -8
    li x5, 100
    sw x5, 0(sp)
    li x5, 200
    sw x5, 4(sp)          # v[1] = 200

    addi x10, sp, 0       # x10 = base address of v (pointer)
    addi x11, x0, 0       # x11 = k = 0 (swap v[0] and v[1])
    jal x1, swap           # call swap

    lw x11, 0(sp)         # load v[0] after swap for printing
    li x10, 1
    ecall                  # prints v[0], should now be 200

    j exit
swap:
    slli x5, x11, 2       # byte offset
    add x5, x10, x5       # x5 = address of v[k]
    lw x6, 0(x5)          # x6 = temp = v[k]
    lw x7, 4(x5)          # x7 = v[k+1]
    sw x7, 0(x5)          # v[k] = v[k+1]
    sw x6, 4(x5)          # v[k+1] = temp
    jalr x0, 0(x1)
exit:
    j exit