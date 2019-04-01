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

.macro COUNT_SINGLE_CELL_NEIGHBORS(screenStartAddress, workStartAddress) {
    lda screenStartAddress,x
    cmp #ActiveCellCharacter
    bne doneCountingNeighbor
    inc workStartAddress-1,x
    inc workStartAddress+1,x
    inc workStartAddress-41,x
    inc workStartAddress-40,x
    inc workStartAddress-39,x
    inc workStartAddress+39,x
    inc workStartAddress+40,x
    inc workStartAddress+41,x
    
    doneCountingNeighbor:
}

.macro COUNT_NEIGHBORS() {
    // count neighbors
    ldx #250
    loopCountNeighbors:
        dex
        COUNT_SINGLE_CELL_NEIGHBORS(SCREENRAM, WORKAREA)
        COUNT_SINGLE_CELL_NEIGHBORS(SCREENRAM+250, WORKAREA+250)
        COUNT_SINGLE_CELL_NEIGHBORS(SCREENRAM+500, WORKAREA+500)
        COUNT_SINGLE_CELL_NEIGHBORS(SCREENRAM+750, WORKAREA+750)

    repeatCountNeighbors:
        cpx #0
        beq countNeighborsDone
        jmp loopCountNeighbors 
    countNeighborsDone:
}

gameUpdate:
    CLEAR_WORK()
    COUNT_NEIGHBORS()
    rts




.macro RENDER_SINGLE_CELL_NEIGHBOR(screenStartAddress, workStartAddress) {
    lda workStartAddress,x
    cmp #0
    beq renderDone
    lda screenStartAddress,x
    cmp #ActiveCellCharacter
    beq renderDone
    lda #NeighborCellCharacter
    sta screenStartAddress,x

    renderDone:
}

.macro RENDER_SINGLE_CELL(screenStartAddress, workStartAddress) {
    lda screenStartAddress,x
    cmp #ActiveCellCharacter
    beq liveCell
    
    deadCell:
        lda workStartAddress,x
        cmp #3
        bne clearCell  

        // if acc == 3, make cell alive
        lda #ActiveCellCharacter
        sta screenStartAddress,x
        jmp done
    liveCell:
        lda workStartAddress,x
        checkMoreThanTwo:
            cmp #2
            bpl checkLessThanFour // if a > 2 (acc - 2 > 0)
            jmp clearCell
        checkLessThanFour:
            cmp #4
            bmi done // if a < 4 (acc - 4 < 0)
            jmp clearCell
    clearCell: 
        lda #SpaceCharacter
        sta screenStartAddress,x
        jmp done

    done:
}

gameRender:
    // iterate each work cell
    // if screen char is active jmp processAlive
    // if screenchar is inactive jmp processDead
    // processAlive
    //      if workarea cell < 2: update screenchar = inactive
    //      if workarea cell > 3: update screenchar = inactive
    // processDead
    //      if workarea cell = 3: update screenchar = active

    ldx #250
    loopGameRender:
        dex
        
        RENDER_SINGLE_CELL(SCREENRAM, WORKAREA)
        RENDER_SINGLE_CELL(SCREENRAM+250, WORKAREA+250)
        RENDER_SINGLE_CELL(SCREENRAM+500, WORKAREA+500)
        RENDER_SINGLE_CELL(SCREENRAM+750, WORKAREA+750)

        // RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM, WORKAREA)
        // RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM+250, WORKAREA+250)
        // RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM+500, WORKAREA+500)
        // RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM+750, WORKAREA+750)

    repeatGameRender:
        cpx #0
        beq gameRenderDone
        jmp loopGameRender 
    gameRenderDone:
        rts