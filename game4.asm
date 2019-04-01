#importonce

.macro CLEAR_WORK() {
    ldx #250
    lda #0
    loopClearWork:
        // load, decrement, and store iterator
        dex
        sta WORKAREA,x
        sta WORKAREA+250,x
        sta WORKAREA+500,x
        sta WORKAREA+750,x
        cpx #0
        bne loopClearWork
}

gameUpdate:
    // clear the work area
    ldx #250
    lda #0
    loopClearWork:
        // load, decrement, and store iterator
        dex
        sta WORKAREA,x
        sta WORKAREA+250,x
        sta WORKAREA+500,x
        sta WORKAREA+750,x
        cpx #0
        bne loopClearWork

    // count neighbors
    ldx #250
    loopCountNeighbors:
        dex

        // count neighbors for first 250 screen characters
        checkSection1:
            lda SCREENRAM,x
            cmp #ActiveCellCharacter
            bne checkSection2
            inc WORKAREA-1,x
            inc WORKAREA+1,x
            inc WORKAREA-41,x
            inc WORKAREA-40,x
            inc WORKAREA-39,x
            inc WORKAREA+39,x
            inc WORKAREA+40,x
            inc WORKAREA+41,x

        // count neighbors for second 250 screen characters        
        checkSection2:
            lda SCREENRAM+250,x
            cmp #ActiveCellCharacter
            bne checkSection3
            inc WORKAREA+250-1,x
            inc WORKAREA+250+1,x
            inc WORKAREA+250-41,x
            inc WORKAREA+250-40,x
            inc WORKAREA+250-39,x
            inc WORKAREA+250+39,x
            inc WORKAREA+250+40,x
            inc WORKAREA+250+41,x
        
        // count neighbors for third 250 screen characters        
        checkSection3:
            lda SCREENRAM+500,x
            cmp #ActiveCellCharacter
            bne checkSection4
            inc WORKAREA+500-1,x
            inc WORKAREA+500+1,x
            inc WORKAREA+500-41,x
            inc WORKAREA+500-40,x
            inc WORKAREA+500-39,x
            inc WORKAREA+500+39,x
            inc WORKAREA+500+40,x
            inc WORKAREA+500+41,x

        // count neighbors for fourth 250 screen characters                
        checkSection4:
            lda SCREENRAM+750,x
            cmp #ActiveCellCharacter
            bne repeatCountNeighbors
            inc WORKAREA+750-1,x
            inc WORKAREA+750+1,x
            inc WORKAREA+750-41,x
            inc WORKAREA+750-40,x
            inc WORKAREA+750-39,x
            inc WORKAREA+750+39,x
            inc WORKAREA+750+40,x
            inc WORKAREA+750+41,x

    repeatCountNeighbors:
        cpx #0
        beq gameUpdateDone
        jmp loopCountNeighbors 

    gameUpdateDone:
        rts

gameRender:
    ldx #250
    loopGameRender:
        dex

        renderSection1:
            lda WORKAREA,x
            cmp #0
            beq renderSection2
            lda SCREENRAM,x
            cmp #ActiveCellCharacter
            beq renderSection2
            lda #NeighborCellCharacter
            sta SCREENRAM,x

        renderSection2:
            lda WORKAREA+250,x
            cmp #0
            beq renderSection3
            lda SCREENRAM+250,x
            cmp #ActiveCellCharacter
            beq renderSection3
            lda #NeighborCellCharacter
            sta SCREENRAM+250,x

        renderSection3:
            lda WORKAREA+500,x
            cmp #0
            beq renderSection4
            lda SCREENRAM+500,x
            cmp #ActiveCellCharacter
            beq renderSection4
            lda #NeighborCellCharacter
            sta SCREENRAM+500,x

        renderSection4:
            lda WORKAREA+750,x
            cmp #0
            beq repeatGameRender
            lda SCREENRAM+750,x
            cmp #ActiveCellCharacter
            beq repeatGameRender
            lda #NeighborCellCharacter
            sta SCREENRAM+750,x

    repeatGameRender:
        cpx #0
        beq gameRenderDone
        jmp loopGameRender 
    gameRenderDone:
        rts