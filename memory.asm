#importonce

//===============================================================================
// $00-$FF  PAGE ZERO (256 bytes)
 
                // $00-$01   Reserved for IO
.var ZeroPageTemp    = $02
                // $03-$8F   Reserved for BASIC
                // using $73-$8A CHRGET as BASIC not used for our game
.var ZeroPageParam1  = $73
.var ZeroPageParam2  = $74
.var ZeroPageParam3  = $75
.var ZeroPageParam4  = $76
.var ZeroPageParam5  = $77
.var ZeroPageParam6  = $78
.var ZeroPageParam7  = $79
.var ZeroPageParam8  = $7A
.var ZeroPageParam9  = $7B
                // $90-$FA   Reserved for Kernal
.var ZeroPageLow     = $FB
.var ZeroPageHigh    = $FC
.var ZeroPageLow2    = $FD
.var ZeroPageHigh2   = $FE
                // $FF       Reserved for Kernal

//===============================================================================
// $0100-$01FF  STACK (256 bytes)


//===============================================================================
// $0200-$9FFF  RAM (40K)

.var SCREENRAM       = $0400
.var SPRITE0         = $07F8

// $0801
// Game code is placed here by using the *=$0801 directive 
// in gameMain.asm 

.var WORKAREA = $2000


// 192 decimal * 64(sprite size) = 12288(hex $3000)
.var SPRITERAM       = 192
* = $3000 "Sprites"
    // .import binary "sprites.spr"

* = $3800 "Characters"
    // .import binary "sample/characters.bin"



//===============================================================================
// $A000-$BFFF  BASIC ROM (8K)


//===============================================================================
// $C000-$CFFF  RAM (4K)

//===============================================================================
// $D000-$DFFF  IO (4K)

// These are some of the C64 registers that are mapped into
// IO memory space
// Names taken from 'Mapping the Commodore 64' book

.var SP0X            = $D000
.var SP0Y            = $D001
.var MSIGX           = $D010
.var RASTER          = $D012
.var SPENA           = $D015
.var SCROLX          = $D016
.var VMCSB           = $D018
.var SPBGPR          = $D01B
.var SPMC            = $D01C
.var SPSPCL          = $D01E
.var EXTCOL          = $D020
.var BGCOL0          = $D021
.var BGCOL1          = $D022
.var BGCOL2          = $D023
.var BGCOL3          = $D024
.var SPMC0           = $D025
.var SPMC1           = $D026
.var SP0COL          = $D027
.var FRELO1          = $D400 //(54272)
.var FREHI1          = $D401 //(54273)
.var PWLO1           = $D402 //(54274)
.var PWHI1           = $D403 //(54275)
.var VCREG1          = $D404 //(54276)
.var ATDCY1          = $D405 //(54277)
.var SUREL1          = $D406 //(54278)
.var FRELO2          = $D407 //(54279)
.var FREHI2          = $D408 //(54280)
.var PWLO2           = $D409 //(54281)
.var PWHI2           = $D40A //(54282)
.var VCREG2          = $D40B //(54283)
.var ATDCY2          = $D40C //(54284)
.var SUREL2          = $D40D //(54285)
.var FRELO3          = $D40E //(54286)
.var FREHI3          = $D40F //(54287)
.var PWLO3           = $D410 //(54288)
.var PWHI3           = $D411 //(54289)
.var VCREG3          = $D412 //(54290)
.var ATDCY3          = $D413 //(54291)
.var SUREL3          = $D414 //(54292)
.var SIGVOL          = $D418 //(54296)      
.var COLORRAM        = $D800
.var CIAPRA          = $DC00
.var CIAPRB          = $DC01

//===============================================================================
// $E000-$FFFF  KERNAL ROM (8K) 


//===============================================================================
