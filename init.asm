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
			LDA palett, X
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
		STA current_nametable
		STA scroll_direction
	
	; -[INIT RACKET POSITION]-
		;LDA #0 (A already 0)
		STA right_racket_pos
		STA left_racket_pos

	; -[INIT BALL POSITION]-
		LDA #50
		STA x_pos
		LDA #50
		STA y_pos
	
	; -[INIT BALL VECTOR]-
		LDA #2
		STA x_vector
		LDA #1
		STA y_vector
	
	
	
	; -[INIT POSITION-INDEPENDENT OAM DATA]-
	; BALL
		LDA #2
		STA ball_tile
		LDA #%00000001; (Palett 1)
		STA ball_attribute
		
	; RIGHT RACKET
		LDA #1 ; tile
		LDY #0
		STA right_racket_tile, Y
		LDY #4
		STA right_racket_tile, Y
		LDY #8
		STA right_racket_tile, Y
		
		LDA #0; flags
		LDY #0
		STA right_racket_attribute, Y
		LDY #4
		STA right_racket_attribute, Y
		LDY #8
		STA right_racket_attribute, Y
		
	; LEFT RACKET
		LDA #1 ; tile
		LDY #0
		STA left_racket_tile, Y
		LDY #4
		STA left_racket_tile, Y
		LDY #8
		STA left_racket_tile, Y
		
		LDA #0; flags
		LDY #0
		STA left_racket_attribute, Y
		LDY #4
		STA left_racket_attribute, Y
		LDY #8
		STA left_racket_attribute, Y

		
	; -[INIT PPU]-
		;bit# 76543210
		LDA #%10010000 ; V-Blank interrupt ON, Sprite size = 8x8, Nametable 0
		STA ppu_ctrl_1
		STA PPU_CTRL_1 ; BG tiles = $1000, Spr tiles = $0000, PPU adr inc = 1B
		;bit# 76543210
		LDA #%00011110 ; 
		STA PPU_CTRL_2