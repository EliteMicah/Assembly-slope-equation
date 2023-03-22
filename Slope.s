.data                               # data segment
Msg1:    
.string "Enter Slope m: "           # Prompt for slope m 
Msg2:
.string "\nEnter Value for x: "     # Prompt for value x
Msg3:
.string "\nEnter Y-intercept b: "   # Prompt for Y-intercept b
outMsg:    
.string "\nThe value of y is: "     # Output message    
.bss                            # uninitialized variables segment    
	.lcomm m, 32
	.lcomm x, 32
	.lcomm b, 32
	.lcomm y, 32
	 movl $0, y
.text                   # code segment
.global main
main:            

# Prompt user for m  
	movq $4, %rax       # sys_write    
	movq $1, %rbx       # $1 is stdout    
	movq $Msg1, %rcx    # message to write    
	movq $15, %rdx      # length of the message    
	int  $0x80          # system interrupt to kernel    
# Read m
	movq $3, %rax       # sys_read    
	movq $0, %rbx       # $0 is stdin    
	movq $m, %rcx       # m   
	movq $0x2, %rdx     # size    
	int $0x80           # system interrupt to kernel
	
# Prompt user for x
	movq $4, %rax       # sys_write    
	movq $1, %rbx       # $1 is stdout    
	movq $Msg2, %rcx    # message to write    
	movq $20, %rdx      # length of the message    
	int  $0x80          # system interrupt to kernel    
# Read x
	movq $3, %rax       # sys_read    
	movq $0, %rbx       # $0 is stdin    
	movq $x, %rcx       # m   
	movq $0x2, %rdx     # size    
	int $0x80           # system interrupt to kernel

# Prompt user for b
	movq $4, %rax       # sys_write    
	movq $1, %rbx       # $1 is stdout    
	movq $Msg3, %rcx    # message to write    
	movq $22, %rdx      # length of the message    
	int  $0x80          # system interrupt to kernel    
# Read b
	movq $3, %rax       # sys_read    
	movq $0, %rbx       # $0 is stdin    
	movq $b, %rcx       # b
	movq $0x2, %rdx     # size    
	int $0x80           # system interrupt to kernel

# Multipliation y = mx + b
    # Arithmetic done in the register

    movl y, %edx        # move y to edx register
    subl $0x30, %edx    # subtract ASCII value for '0' to convert to number
    
    movq m, %rax        # Multiply m
    imulq x, %rax       # by x and store result in register
    addq b, %rax        # add b and store result in register
    movq %rax, y        # return register value to y
    
    # Convert y back to ASCII
    addl $0x30, %edx    # add ASCII value for '0' to convert back to ASCII
    movl %edx, y        # store ASCII value back in y & remove y from register

# Output Message
    movq $4, %rax       # sys_write    
    movq $1, %rbx       # $1 is stdout    
    movq $outMsg, %rcx  # output message    
    movq $20, %rdx      # length of the message    
    int  $0x80          # system interrupt to kernel    
# Output y
    movq $4, %rax       # sys_write    
    movq $1, %rbx       # $1 is stdout    
    movq $y, %rcx       # output y
    movq $0x1, %rdx     # length of the message    
    int  $0x80          # system interrupt to kernel  

# Exit with return 0
	movl $1, %eax       # exit(0) - $1 is sys_exit    
	movl $0, %ebx       # 0 is return value    
	int  $0x80          # system interrupt to kernel    
	ret
