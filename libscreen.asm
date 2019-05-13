#importonce

// Screen lib derived from the book "Retro Game Dev C64 Edition" by Derek Morris

//===============================================================================
// Constants

.var Black           = 0
.var White           = 1
.var Red             = 2
.var Cyan            = 3 
.var Purple          = 4
.var Green           = 5
.var Blue            = 6
.var Yellow          = 7
.var Orange          = 8
.var Brown           = 9
.var LightRed        = 10
.var DarkGray        = 11
.var MediumGray      = 12
.var LightGreen      = 13
.var LightBlue       = 14
.var LightGray       = 15
.var SpaceCharacter  = 32

.var False           = 0
.var True            = 1 

.var ActiveCellCharacter  = 81 // 81 = DOT, 42 = ASTERISK, 160 = SOLID SQUARE
.var NeighborCellCharacter  = 86


// Sets the border and background colors
.macro LIBSCREEN_SETCOLORS(borderColor, bgColor0, bgColor1, bgColor2, bgColor3) {                   
    lda #borderColor
    sta EXTCOL
    lda #bgColor0
    sta BGCOL0
    lda #bgColor1
    sta BGCOL1
    lda #bgColor2
    sta BGCOL2
    lda #bgColor3
    sta BGCOL3
}

// Sets 1000 bytes of memory from start address with a value
.macro LIBSCREEN_FILL(startAddress, value) {
    lda #value              // Load acculator with value to set
    ldx #250                // Set loop value
loop:
    dex                     // Step -1
    sta startAddress,x      // Set start + x
    sta startAddress+250,x  // Set start + 250 + x
    sta startAddress+500,x  // Set start + 500 + x
    sta startAddress+750,x  // Set start + 750 + x
    bne loop                // If x<>0 loop
}

// Waits for a given scanline 
.macro LIBSCREEN_WAIT_FOR_RASTER(scanline) {
loop:
    lda #scanline           // Scanline -> A
    cmp RASTER              // Compare A to current raster line
    bne loop                // Loop if raster line not reached target scanline
}