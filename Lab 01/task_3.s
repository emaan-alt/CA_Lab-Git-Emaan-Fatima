main:
    

    addi x3, x0, 5      #int a=5
    add x6, x0, x0      #int b=0+0
    addi x3, x6, 32     #a=b+32

    add x9, x3, x6     #c=a+b
    addi x12, x9, -5    #d=c-5
    sub x15, x3, x12    #a-d
    sub x18, x6, x3     #b-a
    add x21, x15, x18   #(a-d)+(b-a)
    add x24, x21, x12   #e=((a-d)+(b-a))+d
    add x27, x12, x24   #f=d+e
    add x24, x27, x9    #e=c+h
end:
    j end

