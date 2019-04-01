#importonce

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

// .var ActiveCellCharacter  = 42 // ASTERISK
.var ActiveCellCharacter  = 81 // DOT
// .var ActiveCellCharacter  = 160 // SOLID SQUARE
.var NeighborCellCharacter  = 86


// Sets the border and background colors
.macro LIBSCREEN_SETCOLORS(borderColor, bgColor0, bgColor1, bgColor2, bgColor3) {
    // /1 = Border Color       (Value)
    // /2 = Background Color 0 (Value)
    // /3 = Background Color 1 (Value)
    // /4 = Background Color 2 (Value)
    // /5 = Background Color 3 (Value)
                                
    lda #borderColor        // Color0 -> A
    sta EXTCOL              // A -> EXTCOL
    lda #bgColor0           // Color1 -> A
    sta BGCOL0              // A -> BGCOL0
    lda #bgColor1           // Color2 -> A
    sta BGCOL1              // A -> BGCOL1
    lda #bgColor2           // Color3 -> A
    sta BGCOL2              // A -> BGCOL2
    lda #bgColor3           // Color4 -> A
    sta BGCOL3              // A -> BGCOL3
}

// Sets 1000 bytes of memory from start address with a value
.macro LIBSCREEN_SET1000(startAddress, value) {
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
.macro LIBSCREEN_WAIT_V(scanline) {
    // /1 = Scanline (Value)
loop:
    lda #scanline           // Scanline -> A
    cmp RASTER              // Compare A to current raster line
    bne loop               // Loop if raster line not reached 255
}