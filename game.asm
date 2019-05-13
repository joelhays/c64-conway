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





























.var SCREENRAMXLOW = $FB
.var SCREENRAMXHIGH = $FC
.var WORKRAMXLOW = $FD
.var WORKRAMXHIGH = $FE
.var ROW = $EB
.var COL = $EC

.macro INCREMENT_NEIGHBOR(startAddress, memoryOffset, columnBounds, rowBounds) {
    lda COL
    cmp #columnBounds
    beq done // skip if at the column boundry
    lda ROW
    cmp #rowBounds
    beq done // skip if at the row boundry

    clc
    ldy #memoryOffset
    lda (startAddress),y
    adc #1
    sta (startAddress),y

    done:
}

/// check all neighbors of the current cell and increment neighbor count if the current cell is active
.macro COUNT_SINGLE_CELL_NEIGHBORS2(screenStartAddress, workStartAddress) {

    checkSelf:
    ldy #0
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkRight

        incrementRightNeighbor:
        INCREMENT_NEIGHBOR(workStartAddress, 1, 39, -1)
        // lda COL
        // cmp #39
        // beq incrementBottomLeftNeighbor // skip if at the right edge
        // clc
        // ldy #1
        // lda (workStartAddress),y
        // adc #1
        // sta (workStartAddress),y

        incrementBottomLeftNeighbor:    
        INCREMENT_NEIGHBOR(workStartAddress, 39, 0, 24)
        // lda COL
        // cmp #0
        // beq incrementBottomNeighbor // skip if at the left edge
        // lda ROW
        // cmp #24
        // beq incrementBottomNeighbor // skip if at bottom edge
        // clc
        // ldy #39
        // lda (workStartAddress),y
        // adc #1
        // sta (workStartAddress),y

        incrementBottomNeighbor:
        INCREMENT_NEIGHBOR(workStartAddress, 40, -1, 24)
        // lda ROW
        // cmp #24
        // beq incrementBottomRightNeighbor // skip if at bottom edge
        // clc
        // ldy #40
        // lda (workStartAddress),y
        // adc #1
        // sta (workStartAddress),y

        incrementBottomRightNeighbor:
        INCREMENT_NEIGHBOR(workStartAddress, 41, 39, 24)
        // lda COL
        // cmp #39
        // beq checkRight // skip if at the right edge
        // lda ROW
        // cmp #24
        // beq checkRight // skip if at bottom edge
        // clc
        // ldy #41
        // lda (workStartAddress),y
        // adc #1
        // sta (workStartAddress),y

    checkRight:
    // lda COL
    // cmp #39
    // beq checkBottomLeft // skip if at the right edge
    ldy #1
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkBottomLeft
    
    INCREMENT_NEIGHBOR(workStartAddress, 0, 39, -1)
    // clc
    // ldy #0
    // lda (workStartAddress),y
    // adc #1
    // sta (workStartAddress),y

    checkBottomLeft:
    // lda COL
    // cmp #0
    // beq checkBottom // skip if at the left edge
    // lda ROW
    // cmp #24
    // beq checkBottom // skip if at the bottom edge
    ldy #39
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkBottom

    INCREMENT_NEIGHBOR(workStartAddress, 0, 0, 24)
    // clc
    // ldy #0
    // lda (workStartAddress),y
    // adc #1
    // sta (workStartAddress),y

    checkBottom:
    // lda ROW
    // cmp #24
    // beq checkBottomRight // skip if at the bottom edge
    ldy #40
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkBottomRight
    
    INCREMENT_NEIGHBOR(workStartAddress, 0, -1, 24)
    // clc
    // ldy #0
    // lda (workStartAddress),y
    // adc #1
    // sta (workStartAddress),y

    checkBottomRight:
    // lda COL
    // cmp #39
    // beq doneCountingNeighbor2 // skip if at the right edge
    // lda ROW
    // cmp #24
    // beq doneCountingNeighbor2 // skip if at the bottom edge
    ldy #41
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne doneCountingNeighbor2
    
    INCREMENT_NEIGHBOR(workStartAddress, 0, 39, 24)
    // clc
    // ldy #0
    // lda (workStartAddress),y
    // adc #1
    // sta (workStartAddress),y

    doneCountingNeighbor2:
}

/// simulate automata
gameUpdate2:
    CLEAR_WORK()


    lda #$00
    sta SCREENRAMXLOW
    lda #$04
    sta SCREENRAMXHIGH

    lda #$00
    sta WORKRAMXLOW
    lda #$20
    sta WORKRAMXHIGH

    lda #0
    sta COL
    sta ROW


    loopGameUpdate2:
        COUNT_SINGLE_CELL_NEIGHBORS2(SCREENRAMXLOW, WORKRAMXLOW)

        jsr moveNext

        lda ROW
        cmp #25
        bne loopGameUpdate2Repeat 

        rts
    loopGameUpdate2Repeat:
        jmp loopGameUpdate2

moveNext:
    clc
    lda SCREENRAMXLOW
    adc #1
    sta SCREENRAMXLOW
    lda SCREENRAMXHIGH
    adc #0
    sta SCREENRAMXHIGH

    clc
    lda WORKRAMXLOW
    adc #1
    sta WORKRAMXLOW
    lda WORKRAMXHIGH
    adc #0
    sta WORKRAMXHIGH

    clc
    lda COL
    adc #1
    sta COL
    cmp #40
    bne moveNextDone

    lda #0
    sta COL

    clc
    lda ROW
    adc #1
    sta ROW

    moveNextDone:

    rts