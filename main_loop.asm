; ----------------------------------------------- ;
; -----------------[ MAIN LOOP ]----------------- ;
; ----------------------------------------------- ;
; This part of the code runs once after every 	  ;
; V-blank and performs the physics of moving the  ;
; rackets according to input, and the ball   	  ;
; according to its vectors. This loops repeats    ;
; with the excact same frequency as the PPU 	  ;
; framerate. 			  						  ;
; ----------------------------------------------- ;


MainLoop:
	LDA wait_for_v_blank
	BEQ MainLoop
	
	LDA #0
	STA wait_for_v_blank

	
	; Loop procedures
	.include "main/scroll.asm"					; Scrolls the screen
	.include "main/racket_placement.asm"		; Places the rackets
	.include "main/ball_placement.asm"			; Places the ball

	; Subroutines
	.include "main/flipper_miss.asm"			; Subroutine used by "ball_placement.asm"
	.include "main/check_hit_flipper.asm"		; Subroutine used by "ball_placement.asm"