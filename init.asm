; ------------------------------------------------ ;
; ---------------[ INITIALIZATION ]--------------- ;
; ------------------------------------------------ ;
; The CPU starts here at boot. This part of the    ;
; code will set up the memory and PPU.			   ;
; ------------------------------------------------ ;

Start:
	; -[WAIT 2 FRAMES FOR PPU BOOT]-
		LDA $2002
		BPL Start
	:	LDA $2002
		BPL :-
	
	; -[TURN OFF RENDERING]-
		LDA #0
		STA PPU_CTRL_1
		STA PPU_CTRL_2
	
	; -[LOAD PALETTE]-
		LDA #$3F
		STA PPU_ADRESS	; PPU adress = start of palette
		LDA #$00
		STA PPU_ADRESS		
		
		LDX #0
		@load_palette:
			LDA Palette, X
			STA PPU_VALUE
			INX
			CPX #32
			BNE @load_palette
	
	; -[FILL BACKGROUND]-
		.include "fill_background.asm"
	
	
	; -[INIT STACK]-
		LDX #$FF
		TXS
	
	; -[INIT STATE VARIABLES]-
		LDA #0
		STA panick_mode
		STA bg_color
		STA p1_score
		STA p2_score
		STA hit_count
		STA x_scroll
		STA y_scroll
		STA scroll_direction
	
	; -[INIT RACKET POSITION]-
		;LDA #0 (A already 0)
		STA right_racket_pos
		STA left_racket_pos

	; -[INIT BALL POSITION]-
		LDA #50
		STA ball_x
		;LDA #50
		STA ball_y
	
	; -[INIT BALL VECTOR]-
		LDA #2
		STA x_vector
		LDA #1
		STA y_vector
	
	
	
	; -[INIT GAME-INDEPENDENT OAM DATA]-
		; BALL
			LDA #2
			STA ball_tile
			LDA #%00000001; (Palett 1)
			STA ball_attribute
			
		; RIGHT RACKET
			LDX #4 ; first offset
			LDY #8 ; second offset
		
			LDA #1 ; tile
			STA right_racket_tile
			STA right_racket_tile, X
			STA right_racket_tile, Y
			
			LDA #0; flags
			STA right_racket_attribute
			STA right_racket_attribute, X
			STA right_racket_attribute, Y
			
		; LEFT RACKET
			;LDX #4 ; first offset
			;LDY #8 ; second offset
			
			LDA #1 ; tile
			STA left_racket_tile
			STA left_racket_tile, X
			STA left_racket_tile, Y
			
			LDA #0; flags
			STA left_racket_attribute
			STA left_racket_attribute, X
			STA left_racket_attribute, Y
			
		; PLAYER 1 AND 2 SCORES	
			;LDX #4 ; offset for high digit
			
			LDA #32 ; y pos
			STA p1_score_y			; p1 low digit
			STA p2_score_y			; p2 low digit
			STA p1_score_y, X		; p1 high digit
			STA p2_score_y, X		; p2 high digit
			
			LDA #$10 ; tile number
			STA p1_score_tile			; p1 low digit
			STA p2_score_tile			; p2 low digit
			STA p1_score_tile, X		; p1 high digit
			STA p2_score_tile, X		; p2 high digit
			
			LDA #0 ; attribute byte
			STA p1_score_attribute			; p1 low digit
			STA p2_score_attribute			; p2 low digit
			STA p1_score_attribute, X		; p1 high digit
			STA p2_score_attribute, X		; p2 high digit
			
			; x pos player 1
			LDA #32 
			STA p1_score_x, X		; p1 high digit
			LDA #40
			STA p1_score_x			; p1 low digit
			
			; x pos player 2
			LDA #200
			STA p2_score_x, X		; p2 high digit
			LDA #208
			STA p2_score_x			; p1 low digit

		
	; -[INIT PPU (ENABLES RENDERING)]-
		LDA #%10010000 ; V-Blank interrupt ON, Sprite size = 8x8, Nametable 0
		STA ppu_ctrl_1 ; BG tiles = $1000, Spr tiles = $0000, PPU adr inc = 1B
		STA PPU_CTRL_1
		LDA #%00011110
		STA PPU_CTRL_2