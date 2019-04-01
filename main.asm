#import "memory.asm"
#import "libscreen.asm"
// #import "game.asm" // kinda......
// #import "game1.asm" //memory corruption
// #import "game2.asm" // testing
// #import "game3.asm" // testing
#import "game4.asm" // testing

.pc = $0801 "Basic Upstart"
:BasicUpstart2(start) 

.pc = $0810 "Main program"  
start:
    // set screen colors
    LIBSCREEN_SETCOLORS(DarkGray, Black, Black, Black, Black)
    // Fill 1000 bytes (40x25) of screen memory 
    LIBSCREEN_SET1000(SCREENRAM, SpaceCharacter)
    // Fill 1000 bytes (40x25) of color memory
    LIBSCREEN_SET1000(COLORRAM, Cyan)


    ldx #ActiveCellCharacter
	stx SCREENRAM+$cc
	stx SCREENRAM+$6c
	stx SCREENRAM+$4e
	stx SCREENRAM+$128
	stx SCREENRAM+$1c1
	stx SCREENRAM+$1fe
	stx SCREENRAM+$22b
	stx SCREENRAM+$378
	stx SCREENRAM+$337
	stx SCREENRAM+$3bd
	stx SCREENRAM+$3bd+1
	stx SCREENRAM+$3bd-1
	stx SCREENRAM+$3bd-3

    jsr gameUpdate
    jsr gameRender


    jmp mainloop

mainloop:
    // wait for the raster to reach the bottom of the screen
    LIBSCREEN_WAIT_V($ff)

    inc EXTCOL // start code timer change border color

    // jsr gameUpdate
    // jsr gameRender

	dec EXTCOL // end code timer reset border color

    jmp mainloop

