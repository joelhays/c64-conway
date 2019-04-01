#importonce

.var WorkArea = $2000

.macro COUNT(startAddress, destAddress, value) {
    lda startAddress,x      // Set start + x
    cmp #value
    beq increment // work area neighbors
    jmp done
increment:
    // lda #$31
    // sta startAddress-1,x
    // sta startAddress+1,x
    // sta startAddress-41,x
    // sta startAddress-40,x
    // sta startAddress-39,x
    // sta startAddress+39,x
    // sta startAddress+40,x
    // sta startAddress+41,x

    inc startAddress-1,x
    inc startAddress+1,x
    inc startAddress-41,x
    inc startAddress-40,x
    inc startAddress-39,x
    inc startAddress+39,x
    inc startAddress+40,x
    inc startAddress+41,x

    inc destAddress+1,x
    inc destAddress-41,x
    inc destAddress-40,x
    inc destAddress-39,x
    inc destAddress+39,x
    inc destAddress+40,x
    inc destAddress+41,x
done:
}

.macro COUNT_NEIGHBORS() {
    ldx #250                // Set loop value
loop:
    dex                     // Step -1
    COUNT(SCREENRAM, WorkArea, ActiveCellCharacter)
    COUNT(SCREENRAM+250, WorkArea+250, ActiveCellCharacter)
    COUNT(SCREENRAM+500, WorkArea+500, ActiveCellCharacter)
    COUNT(SCREENRAM+750, WorkArea+750, ActiveCellCharacter)
    bne repeat                // If x<>0 loop
repeat:
    jmp loop
}


.macro RENDER(startAddress, destAddress, value) {
    // lda startAddress,x      // Set start + x
    lda #$55
    sta destAddress,x
}

.macro RENDER_NEIGHBORS() {
    ldx #250                // Set loop value
loop:
    dex                     // Step -1
    RENDER(WorkArea, SCREENRAM, $52)
    // CHECK(SCREENRAM, ActiveCellCharacter)
    // CHECK(SCREENRAM+250, ActiveCellCharacter)
    // CHECK(SCREENRAM+500, ActiveCellCharacter)
    // CHECK(SCREENRAM+750, ActiveCellCharacter)
    bne repeat                // If x<>0 loop
repeat:
    jmp loop
}

gameUpdate:
    LIBSCREEN_SET1000(WorkArea, 1)
    COUNT_NEIGHBORS()
    RENDER_NEIGHBORS()

    rts