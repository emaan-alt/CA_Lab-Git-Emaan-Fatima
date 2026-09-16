main:
    li x22, 0      #i starting from zero
    li x25, 0x200  # array a= 4 bytes
    li x1, 10
    li x23, 0 # sum=0

Loop1:
    bge x22, x1, Exit1    # stopping condition of loop i>=10
    slli x2, x22, 2       # x2= temp register to store offset
    add x2, x2, x25
    sw x22, 0(x2)
    addi x22, x22, 1
    beq x0, x0, Loop1

Exit1:

    li x22, 0

Loop2:
    bge x22, x1, Exit2
    slli x4, x22, 2
    add x4, x4, x25
    lw x6, 0(x4)
    add x23, x23, x6      #x23=sum
    addi x22, x22, 1
    beq x0, x0, Loop2

Exit2: