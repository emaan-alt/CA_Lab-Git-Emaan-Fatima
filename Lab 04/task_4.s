main:
    li x10, 48
    li x11, 18
    jal x1, gcd          # Calculate gcd(48, 18)

    addi x11, x10, 0
    li x10, 1
    ecall
    j exit

gcd:
    addi sp, sp, -8
    sw x1, 4(sp)         # save return address
    sw x11, 0(sp)

    beq x11, x0, base    # if b == 0, base case: return a (already in x10)

    rem x5, x10, x11
    add x10, x11, x0
    add x11, x5, x0
    jal x1, gcd

    j exit_gcd

base:
    # x10 already holds a (the gcd), nothing to compute

exit_gcd:
    lw x1, 4(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)

exit:
end:
    j end