main:
    li   x11, 0x1000       # address of source string y
    li   x10, 0x2000       # address of destination string x
    li   x28, 72           # ASCII value of 'H'
    sb   x28, 0(x11)

    li   x28, 105          # ASCII value of 'i'
    sb   x28, 1(x11)

    li   x28, 0            # null character marks end of string
    sb   x28, 2(x11)

    jal  ra, strcpy        # call strcpy and save return address in ra

end_main:
    j    end_main          # stay here after function finishes

strcpy:
    addi sp, sp, -8        # create space on stack
    sw   x19, 0(sp)        # save x19 before using it
    add  x19, x0, x0       # initialize i = 0

loop:
    add  x5, x19, x11      # get address of y[i]
    lb   x6, 0(x5)         # load y[i] into x6
    add  x7, x19, x10      # get address of x[i]
    sb   x6, 0(x7)         # copy y[i] into x[i]
    beq  x6, x0, exit      # if copied byte is 0, string is finished
    addi x19, x19, 1       # increment i
    jal  x0, loop          # repeat the loop

exit:
    lw   x19, 0(sp)        # restore original x19
    addi sp, sp, 8         # restore stack pointer
    jalr x0, 0(ra)         # return back to main