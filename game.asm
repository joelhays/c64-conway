#importonce

/// iterate through work memory and clear all values
.macro CLEAR_WORK() {
    ldx #250
    lda #0
    loopClearWork:
        dex
        sta WORKAREA,x
        sta WORKAREA+250,x
        sta WORKAREA+500,x
        sta WORKAREA+750,x
        cpx #0
        bne loopClearWork
}

/// check all neighbors of the current cell and increment neighbor count if the current cell is active
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

/// iterate through screen and count neighbors for all active cells
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

/// simulate automata
gameUpdate:
    CLEAR_WORK()
    COUNT_NEIGHBORS()
    rts



/// debug: render a screen character indicating the neighbor count for a cell
.macro DEBUG_RENDER_SINGLE_CELL_NEIGHBOR(screenStartAddress, workStartAddress) {
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

/// render a screen character indicating the state of the current cell
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

/// render the state of the work area to the screen
/// for each cell in work area
///     if corresponding screen character is active, jmp processAlive
///     if corresponding screen chracter is inactive, jmp to processDead
///     processAlive:
///         if workarea cell < 2: update screenchar = inactive
///         else if workarea cell > 3: update screenchar = inactive
///     processDead:
///         if workarea cell = 3: update screenchar = active
///         else: update screenchar = inactive
gameRender:
    ldx #250
    loopGameRender:
        dex
        
        RENDER_SINGLE_CELL(SCREENRAM, WORKAREA)
        RENDER_SINGLE_CELL(SCREENRAM+250, WORKAREA+250)
        RENDER_SINGLE_CELL(SCREENRAM+500, WORKAREA+500)
        RENDER_SINGLE_CELL(SCREENRAM+750, WORKAREA+750)

        // DEBUG_RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM, WORKAREA)
        // DEBUG_RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM+250, WORKAREA+250)
        // DEBUG_RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM+500, WORKAREA+500)
        // DEBUG_RENDER_SINGLE_CELL_NEIGHBOR(SCREENRAM+750, WORKAREA+750)

    repeatGameRender:
        cpx #0
        beq gameRenderDone
        jmp loopGameRender 
    gameRenderDone:
        rts