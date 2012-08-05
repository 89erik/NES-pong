.include "constants.inc"

.segment "INES"
	.byte "NES",$1A,1,1,1
	;      012   3  4 5 6
	;http://wiki.nesdev.com/w/index.php/INES
	
.segment "VECTORS"
	.word NMI						; Located in "v_blank.asm"
	.word Start						; Located in "init.asm"
	.word 0 						; IRQ not used

.segment "GFX"
	.incbin "sprites.spr"			; Graphics for moving things (binary file)
	.incbin "bakgrunn.chr"			; Graphics for background (binary file)
	
.segment "CODE"
	.include "init.asm" 			; Initialization procedure
	.include "main_loop.asm"		; Physics to be performed per framerate
	.include "v_blank.asm"			; Drawing the screen
	
.segment "DATA"	
	.include "data.asm"
	
.segment "ZERO_PAGE"
	.include "ram.asm"				; Variables in RAM