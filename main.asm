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
    LIBSCREEN_SET1000(COLORRAM, LightGreen)

    DRAW_GLIDER()
    // DRAW_SCREEN()

    jmp mainloop

mainloop:

    SLEEP(250)

    // inc EXTCOL // start code timer change border color

    jsr gameUpdate
    jsr gameRender

	// dec EXTCOL // end code timer reset border color

    jmp mainloop

.macro SLEEP(value) {
    ldx #value
    loop:
        dex
        // wait for the raster to reach the bottom of the screen
        LIBSCREEN_WAIT_V($ff)
        cpx #0
        bne loop

}



.macro DRAW_GLIDER() {
    ldx #ActiveCellCharacter
	stx SCREENRAM+$020A
	stx SCREENRAM+$020B
	stx SCREENRAM+$0232
	stx SCREENRAM+$0233
	stx SCREENRAM+$01C6
	stx SCREENRAM+$01C7
	stx SCREENRAM+$01ED
	stx SCREENRAM+$0214
	stx SCREENRAM+$023C
	stx SCREENRAM+$0264
	stx SCREENRAM+$028D
	stx SCREENRAM+$02B6
	stx SCREENRAM+$02B7
	stx SCREENRAM+$0240
	stx SCREENRAM+$01F1
	stx SCREENRAM+$021A
	stx SCREENRAM+$0242
	stx SCREENRAM+$026A
	stx SCREENRAM+$0243
	stx SCREENRAM+$0291
	stx SCREENRAM+$01ce
	stx SCREENRAM+$01cf
	stx SCREENRAM+$01f6
	stx SCREENRAM+$01f7
	stx SCREENRAM+$021e
	stx SCREENRAM+$021f
	stx SCREENRAM+$01a8
	stx SCREENRAM+$0248
	stx SCREENRAM+$0182
	stx SCREENRAM+$01aa
	stx SCREENRAM+$024a
	stx SCREENRAM+$0272
	stx SCREENRAM+$01dc
	stx SCREENRAM+$01dd
	stx SCREENRAM+$0204
	stx SCREENRAM+$0205
}

.macro DRAW_SCREEN() {
    ldx #ActiveCellCharacter
	stx SCREENRAM+$cc
	stx SCREENRAM+$cc+1
	stx SCREENRAM+$cc+2
	stx SCREENRAM+$cc+3
	stx SCREENRAM+$cc+4
	stx SCREENRAM+$cc+5
	stx SCREENRAM+$cc+6
	stx SCREENRAM+$cc+7
	stx SCREENRAM+$cc+9
	stx SCREENRAM+$cc+10
	stx SCREENRAM+$cc+11
	stx SCREENRAM+$cc+12
	stx SCREENRAM+$cc+13
	stx SCREENRAM+$cc+17
	stx SCREENRAM+$cc+18
	stx SCREENRAM+$cc+19
	stx SCREENRAM+$cc+26
	stx SCREENRAM+$cc+27
	stx SCREENRAM+$cc+28
	stx SCREENRAM+$cc+29
	stx SCREENRAM+$cc+30
	stx SCREENRAM+$cc+31
	stx SCREENRAM+$cc+32
	stx SCREENRAM+$cc+34
	stx SCREENRAM+$cc+35
	stx SCREENRAM+$cc+36
	stx SCREENRAM+$cc+37
	stx SCREENRAM+$cc+38


	stx SCREENRAM+$cc
	stx SCREENRAM+$6c
	stx SCREENRAM+$4e
	stx SCREENRAM+$128
	stx SCREENRAM+$1c1
	stx SCREENRAM+$1fe
	stx SCREENRAM+$22b
	stx SCREENRAM+$378
	stx SCREENRAM+$337
	stx SCREENRAM+$337+1
	stx SCREENRAM+$337+40
	stx SCREENRAM+$337+40
	stx SCREENRAM+$337-40

	stx SCREENRAM+$3bd
	stx SCREENRAM+$3bd+1
	stx SCREENRAM+$3bd-1
	stx SCREENRAM+$3bd-3
}