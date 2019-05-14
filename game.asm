#importonce


// zero-page screen ram pointer 
.var SCREENRAMXLOW = $FB
.var SCREENRAMXHIGH = $FC

// zero-page work ram pointer
.var WORKRAMXLOW = $FD
.var WORKRAMXHIGH = $FE

// row and column counters
.var ROW = $EB
.var COL = $EC



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
    // check if the current cell is alive
    lda screenStartAddress,x
    cmp #ActiveCellCharacter
    beq liveCell
    
    deadCell:
        // check if the current dead cell has exactly 3 neighbors
        lda workStartAddress,x
        cmp #3
        bne clearCell  

        // current dead cell has 3 neighbors, so make it alive
        lda #ActiveCellCharacter
        sta screenStartAddress,x
        jmp done
    liveCell:
        // check how many neighbors the current live cell has
        lda workStartAddress,x
        checkMoreThanTwo:
            // if the current live cell has less than 2 neighbors, it dies
            cmp #2
            bpl checkLessThanFour
            jmp clearCell
        checkLessThanFour:
            // if the current live cell has more than 3 neighbors, it dies
            cmp #4
            bmi done
            jmp clearCell
    clearCell: 
        // set the current cell to dead
        lda #SpaceCharacter
        sta screenStartAddress,x
        jmp done

    done:
}



/// simulate automata
gameUpdate:
    CLEAR_WORK()

    // reset memory pointers and counters
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


    loopGameUpdate:
        PROCESS_CELL(SCREENRAMXLOW, WORKRAMXLOW)
        MOVE_NEXT()

        lda ROW
        cmp #25
        bne loopGameUpdateRepeat 

        rts
    loopGameUpdateRepeat:
        jmp loopGameUpdate

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
.macro PROCESS_CELL(screenStartAddress, workStartAddress) {

    checkSelf:
    // if this cell is active, increment "forward" neighbors
    ldy #0
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkRight
    
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 1, 39, -1)     // right
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 39, 0, 24)     // bottom left
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 40, -1, 24)    // bottom
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 41, 39, 24)    // bottom right

    checkRight:
    // if right is active, increment this cell
    ldy #1
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkBottomLeft
    
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 0, 39, -1)

    checkBottomLeft:
    // if bottom left is active, increment this cell
    ldy #39
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkBottom

    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 0, 0, 24)

    checkBottom:
    // if bottom is active, increment this cell
    ldy #40
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne checkBottomRight
    
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 0, -1, 24)

    checkBottomRight:
    // if bottom right is active, increment this cell
    ldy #41
    lda (screenStartAddress),y
    cmp #ActiveCellCharacter
    bne doneProcessingCell
    
    INCREMENT_CELL_NEIGHBOR_COUNT(workStartAddress, 0, 39, 24)

    doneProcessingCell:
}

.macro INCREMENT_CELL_NEIGHBOR_COUNT(startAddress, addressOffset, columnBounds, rowBounds) {
    lda COL
    cmp #columnBounds
    beq done // skip if at the column boundry
    lda ROW
    cmp #rowBounds
    beq done // skip if at the row boundry

    clc
    ldy #addressOffset
    lda (startAddress),y
    adc #1
    sta (startAddress),y

    done:
}

.macro MOVE_NEXT() {
    // move screen ram pointer to the next location
    clc
    lda SCREENRAMXLOW
    adc #1
    sta SCREENRAMXLOW
    lda SCREENRAMXHIGH
    adc #0
    sta SCREENRAMXHIGH

    // move work ram pointer to the next location
    clc
    lda WORKRAMXLOW
    adc #1
    sta WORKRAMXLOW
    lda WORKRAMXHIGH
    adc #0
    sta WORKRAMXHIGH

    // increment current screen/work column
    clc
    lda COL
    adc #1
    sta COL

    // check if maximum screen/work column exceeded (0..39) and move to done if not
    cmp #40
    bne moveNextDone

    // screen/work column exceeded
    
    // reset current column to 0 
    lda #0
    sta COL

    // increment the current row
    clc
    lda ROW
    adc #1
    sta ROW

    moveNextDone:
}