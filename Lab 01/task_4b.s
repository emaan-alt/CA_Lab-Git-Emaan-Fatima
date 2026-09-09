main:

    li x10, 0x100
    li x11, 0x200
    li x12, 0x300

    # array A initialization
    li x5, 1
    sb x5, 0(x10)      # a[0] = 1

    li x5, 2
    sb x5, 1(x10)      # a[1] = 2

    li x5, 3
    sb x5, 2(x10)      # a[2] = 3

    li x5, 4
    sb x5, 3(x10)      # a[3] = 4


    # array B initialization
    li x6, 10
    sh x6, 0(x11)      # b[0] = 10

    li x6, 20
    sh x6, 2(x11)      # b[1] = 20

    li x6, 30
    sh x6, 4(x11)      # b[2] = 30

    li x6, 40
    sh x6, 6(x11)      # b[3] = 40


    # first iteration when i = 0
    lb x1, 0(x10)
    lh x2, 0(x11)
    add x3, x1, x2
    sw x3, 0(x12)


    # second iteration when i = 1
    lb x1, 1(x10)
    lh x2, 2(x11)
    add x3, x1, x2
    sw x3, 4(x12)


    # third iteration when i = 2
    lb x1, 2(x10)
    lh x2, 4(x11)
    add x3, x1, x2
    sw x3, 8(x12)


    # fourth iteration when i = 3
    lb x1, 3(x10)
    lh x2, 6(x11)
    add x3, x1, x2
    sw x3, 12(x12)

end:
    j end