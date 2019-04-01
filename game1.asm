#importonce

.var CellActiveMask          = %00000001
.var CellActivatingMask      = %00000010
.var CellInactiveMask        = %00000100
.var CellDeactivatingMask    = %00001000

.var cellRowIndex = $0
.var cellColIndex = $0
.var cellNeighborCount = $0
.var currentScreenOffset = $0


.macro GetCellState(state, mask) {
    lda state
    and #mask
} // test with bne on return

.macro GetTopLeft(currentCell) {

}

.macro InitFrame() {
    ldx #0
    stx cellRowIndex
    stx cellColIndex
    stx cellNeighborCount
    stx currentScreenOffset
}

.macro CheckLeft() {
    // ldy cellColIndex    //load the current column into Y register
    // beq done            //branch on result zero, col is 0 so no left neighbor


//     dey                 //decrement value in y register
    ldx COLORRAM+currentScreenOffset-1     //load accumulator with the left cell screen address

    cpx #Green           //compare acc to green, means cell is alive
    beq alive           //branch on result zero, color is not green

    cpx #Red                     //compare acc to green, means cell is dead
    bne dead   

    jmp done
alive:
    // lda #$54
    // sta SCREENRAM+currentScreenOffset
    // inc cellNeighborCount
    .eval cellNeighborCount++
    jmp done
dead:
    // lda #$55
    // sta SCREENRAM+currentScreenOffset
    jmp done
done:
}

.macro CheckRight() {
    ldx COLORRAM+currentScreenOffset+1

    cpx #Green           //compare acc to green, means cell is alive
    beq alive           //branch on result zero, color is not green

    cpx #Red                     //compare acc to green, means cell is dead
    bne dead   

    jmp done
alive:
    lda #$54
    sta SCREENRAM+currentScreenOffset
    // inc cellNeighborCount
    .eval cellNeighborCount++
    jmp done
dead:
    // lda #$55
    // sta SCREENRAM+currentScreenOffset
    jmp done
done:
}

// .macro MoveToNextCell() {
//     ldy cellColIndex    //load the current column into Y register
//     cmp #40
//     beq done            //branch on result zero, col is 0 so no left neighbor

//     ldy #0
//     sty cellColIndex
//     inc cellRowIndex
// done:
// }

gameUpdate:
    // InitFrame()

    // ldx #0
    // stx cellNeighborCount

    // CheckLeft();

    // inc currentScreenOffset
    // inc cellColIndex

    // rts

    .eval cellRowIndex = 0
    .eval cellColIndex = 0
    .eval cellNeighborCount = 0

    .eval currentScreenOffset = 1
    .while(currentScreenOffset < 999) {
        .eval cellNeighborCount = 0

        

        .if (cellColIndex > 0) {
            CheckLeft()
        }
        .if (cellColIndex < 40) {
            CheckRight()
        }
        

        .if (cellRowIndex > 0) {
            // CheckTop()
        }
        .if (cellRowIndex < 25) {
            // CheckBottom()
        }
        
        .if (cellColIndex > 0 && cellRowIndex > 0) {
            // CheckTopLeft
        }
        .if(cellColIndex < 40 && cellRowIndex > 0) {
            //CheckTopRight()
        }

        .if (cellColIndex > 0 && cellRowIndex < 25) {
            // CheckBottomLeft()
        }
        .if (cellColIndex < 40 && cellRowIndex < 25) {
            // CheckBottomRight
        }

        .if (cellNeighborCount > 0) {
            // lda #Blue
	        // sta COLORRAM+i

            // lda #$23
            // sta SCREENRAM+currentScreenOffset
        }

        .eval currentScreenOffset++
        .eval cellColIndex++

        .if (cellColIndex == 40) {
            .eval cellColIndex = 1
            inc cellRowIndex
        }
    }

    rts