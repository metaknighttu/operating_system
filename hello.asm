; ; Excersise from https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
;A simple boot sector program that prints a message and halts the system.
;

mov ah, 0x0e    ; int 10/ ah = 0x0e -> scrolling teletype BIOS routine
                ; By placing hex value 0x0e into the high end of the a register
                ; and then filling the low end of the register with the hex code for a printable symbol
                ; the interrupt 0x10 tells the BIOS there is a screen related interrupt. It looks at ah and sees 0x0e
                ; indicating Teletype mode, it then prints the contents of al to the screen.

mov al, 'H'     ; We begin loading a letter into al, then we call a system interrupt which sees ax = 0x0e6f
int 0x10        ; For the duration we leave ah alone, it doesnt need to change while we are still printing.
mov al, 'e'     ; just change al to indicate the next letter to print
int 0x10        ; and call the interrupt to print the character to the screen.
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10
mov al, ' '
int 0x10
mov al, 'W'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10
mov al, '!'
int 0x10
mov al, ' '
int 0x10
mov al, 'S'
int 0x10
mov al, 'n'
int 0x10
mov al, 'e'
int 0x10
mov al, 'k'
int 0x10
mov al, 'O'
int 0x10
mov al, 'S'
int 0x10
mov al, ' '
int 0x10
mov al, 'R'     ; Yes, this method is very inefficient with our sector space
int 0x10        ; in fact when we look at the raw hex code of the binary, we can see that
mov al, 'u'     ; three quarters of the bytes used are repeated instructions and interrupts.
int 0x10
mov al, 'n'
int 0x10
mov al, 'n'
int 0x10
mov al, 'i'
int 0x10
mov al, 'n'
int 0x10
mov al, 'g'
int 0x10
mov al, ' '
int 0x10
mov al, 'V'
int 0x10
mov al, 'e'
int 0x10
mov al, 'r'
int 0x10
mov al, ' '
int 0x10
mov al, '0'
int 0x10
mov al, '.'     ; Our next project is to create a more efficient string printing method and use it
int 0x10        ;  to print as much text as possible.
mov al, '0'
int 0x10
mov al, '2'
int 0x10

jmp $                ; Use a simple CPU instruction that jumps to the current address, halting operation

times 510 -($-$$) db 0      ; When compiled , our program must fit into 512 bytes ,
                            ; with the last two bytes being the magic number ,
                            ; so here , tell our assembly compiler to pad out our
                            ; program with enough zero bytes (db 0) to bring us to the
                            ; 510 th byte.
dw 0xaa55                   ; Last two bytes ( one word ) form the magic number ,
                            ; so BIOS knows we are a boot sector.