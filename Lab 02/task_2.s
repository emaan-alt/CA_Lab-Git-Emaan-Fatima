#x20=x #x21=a #x22=b #x23=c
main:
    li x22, 3
    li x23, 4
    li x20, 3
    li x1, 1
    li x2, 2
    li x3, 3
    li x4, 4

    bne x20, x1, Case2
    add x21, x22, x23
    beq x0, x0, Exit
Case2:
    bne x20, x2, Case3
    sub x21, x22, x23
    beq x0, x0, Exit
Case3:
    bne x20, x3, Case4
    slli x21, x22, 1
    beq x0, x0, Exit
Case4:
    bne x20, x4, default
    srli x21, x22, 1
    beq x0, x0, Exit
default:
    li x21, 0
Exit:
end: