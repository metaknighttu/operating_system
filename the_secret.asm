; Excersise from https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
; A simple boot sector program that demonstrates segment offsetting
;
;[org 0x7c00]                   ; This tells the assembler where in memory the code will be loaded on boot
                                ; We are not using it for this excersise to demonstarte memory segments
    mov ah, 0x0e                ; int 10/ah = 0eh -> scrolling teletype BIOS routine
    mov al, [the_secret]
    int 0x10                    ; Does this print an X? > NO

    mov bx, 0x7c0               ; Can’t set ds directly , so set bx
    mov ds, bx                  ; then copy bx to ds.
    mov al, [the_secret]
    int 0x10                    ; Does this print an X? > YES

    mov al, [es:the_secret]     ; Tell the CPU to use the es (not ds) segment.
    int 0x10                    ; Does this print an X? > NO

    mov bx, 0x7c0
    mov es, bx
    mov al, [es:the_secret]
    int 0x10                    ; Does this print an X? > YES

    jmp $                       ; Jump forever.

the_secret:
    db "X"

; Padding and magic BIOS number.
times 510-($-$$) db 0
dw 0xaa55

;Takeaway
; The original memory offset for the program we set with ORG was 0x7c00. Since we are no longer using it, 
; we now need to tell the program what memory offset to use to find our character by loading the offset amount 
; into a segment register (ds or es). So why do we set the offset register to 0x7c0 instead of 0x7c00? 
; Because the cpu multiplies the value of the offset register by 16, which moves the value up one place in hex.
; Thus, when we don't tell the assembler to assume an offset of 0x7c00 with the org command,
; we can't load bytes properly without an offset to tell the CPU where the value is actually stored.
; If we were to use the org command to tell the assembler where it will be loaded, the results would be flipped,
; since then the additional offset values would be added to the ORG offset, overshooting the actual locations.