; ; Excersise from https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
; A slightly less simple boot sector program that prints a message and halts the system.
;
; Using a data section we will define a null-terminated string to save space
; Then we will call a routine that pronts the string to the screen
; Thus saving space and making the development process more streamlined
; In fact the compiled binary takes up less than half the space of the first hello.bin
;

[org 0x7c00]                    ; This tells the assembler where in memory the code will be loaded on boot

mov si, hello_string            ; load the string address into the Source Index register  
call print_string               ; the call directive tells the program to return here after the function is complete
mov si, version_string          ; The Source Index register is used as a pointer to a source in stream operations
call print_string

jmp $                           ; Use a simple CPU instruction that jumps to the current address, halting operation

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Begin Data;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hello_string: db 'Hello World!',13,10,0                 ;After the string we add 0x13 and 0x10 before the null
version_string: db 'Running SnekOS Ver 0.03',13,10,0    ;This triggers a CRLF to start a new line
;more_string: db '',13,10,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End Data;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Begin Routines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Print String ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string:
    mov ah, 0x0e                ; Load the teletype print flag for the print function

.run:
    lodsb                       ;Load Single Byte from the si register we placed the string into earlier.
                                ;Calling this again will cause it to load the subsequent byte of the string.
    cmp al, 0                   ;Check whether the character is NULL
    je .done                    ;   If it is, end function and return, 
    int 0x10                     ;       otherwise print to screen 
    jmp .run                    ;           Then loop back to start and load the next byte 

.done:
    ret                         ; End function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End Routines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    times 510 -($-$$) db 0      ; pad out the sector
    dw 0xaa55                   ; and finish with the magic number