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

    // inc startAddress-1,x
    // inc startAddress+1,x
    // inc startAddress-41,x
    // inc startAddress-40,x
    // inc startAddress-39,x
    // inc startAddress+39,x
    // inc startAddress+40,x
    // inc startAddress+41,x

    lda #1
    sta destAddress+1,x
    sta destAddress-41,x
    sta destAddress-40,x
    sta destAddress-39,x
    sta destAddress+39,x
    sta destAddress+40,x
    sta destAddress+41,x
done:
}

.macro COUNT_NEIGHBORS() {
    ldx #250                // Set loop value
loop:
    dex                     // Step -1
    lda #0

    sta WorkArea
    sta WorkArea+1,x
    sta WorkArea-41,x
    sta WorkArea-40,x
    sta WorkArea-39,x
    sta WorkArea+39,x
    sta WorkArea+40,x
    sta WorkArea+41,x

    sta WorkArea+250
    sta WorkArea+250+1,x
    sta WorkArea+250-41,x
    sta WorkArea+250-40,x
    sta WorkArea+250-39,x
    sta WorkArea+250+39,x
    sta WorkArea+250+40,x
    sta WorkArea+250+41,x

    sta WorkArea+500
    sta WorkArea+500+1,x
    sta WorkArea+500-41,x
    sta WorkArea+500-40,x
    sta WorkArea+500-39,x
    sta WorkArea+500+39,x
    sta WorkArea+500+40,x
    sta WorkArea+500+41,x

    sta WorkArea+750
    sta WorkArea+750+1,x
    sta WorkArea+750-41,x
    sta WorkArea+750-40,x
    sta WorkArea+750-39,x
    sta WorkArea+750+39,x
    sta WorkArea+750+40,x
    sta WorkArea+750+41,x

    COUNT(SCREENRAM, WorkArea, ActiveCellCharacter)
    COUNT(SCREENRAM+250, WorkArea+250, ActiveCellCharacter)
    COUNT(SCREENRAM+500, WorkArea+500, ActiveCellCharacter)
    COUNT(SCREENRAM+750, WorkArea+750, ActiveCellCharacter)
    bne repeat                // If x<>0 loop
repeat:
    jmp loop
}


.macro RENDER(startAddress, destAddress, value) {
left:
    // lda startAddress-1
    // cmp #1
    // bne right
    lda #value
    sta destAddress-1,x
right:
    // lda startAddress+1,x
    // cmp #1
    // bne topleft
    lda #value
    sta destAddress+1,x
topleft:
    // lda startAddress-41,x
    // cmp #1
    // bne top
    lda #value
    sta destAddress-41,x
top:
    // lda startAddress-40,x
    // cmp #1
    // bne topright
    lda #value
    sta destAddress-40,x
topright:
    // lda startAddress-39,x
    // cmp #1
    // bne bottomleft
    lda #value
    sta destAddress-39,x
bottomleft:
    // lda startAddress+39,x
    // cmp #1
    // bne bottom
    lda #value
    sta destAddress+39,x
bottom:
    // lda startAddress+40,x
    // cmp #1
    // bne bottomright
    lda #value
    sta destAddress+40,x
bottomright:
    // lda startAddress+41,x
    // cmp #1
    // bne done
    lda #value
    sta destAddress+41,x
done:
}

.macro RENDER_NEIGHBORS() {
    ldx #250                // Set loop value
loop:
    dex                     // Step -1
    RENDER(WorkArea, SCREENRAM, NeighborCellCharacter)
    RENDER(WorkArea+250, SCREENRAM+250, NeighborCellCharacter)
    RENDER(WorkArea+500, SCREENRAM+500, NeighborCellCharacter)
    RENDER(WorkArea+750, SCREENRAM+750, NeighborCellCharacter)
    bne repeat                // If x<>0 loop
repeat:
    jmp loop
}

gameUpdate:
    // LIBSCREEN_SET1000(WorkArea, 0)
    COUNT_NEIGHBORS()
    RENDER_NEIGHBORS()

    rts