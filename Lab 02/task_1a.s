# x19=f
# x20=g
# x21=h
# x22=i
# x23=j

main:
    li x19, 1
    li x20, 4
    li x21, 1
    li x22, 4
    li x23, 4

    bne x22, x23, else
    add x19, x20, x21
    beq x0, x0, exit
else: sub x19, x20, x21
exit:
end:
    j end