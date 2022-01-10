print_string:
    mov ah, 0x0E                ; Load the teletype print flag for the print function

.run:
    lodsb                       ;Load Single Byte from the si register we placed the string into earlier.
                                ;Calling this again will cause it to load the subsequent byte of the string.
    cmp al, 0                   ;Check whether the character is NULL
    je .done                    ;   If it is, end function and return, 
    int 0x10                    ;       otherwise print to screen 
    jmp .run                    ;           Then loop back to start and load the next byte 

.done:
    ret                         ; End function
