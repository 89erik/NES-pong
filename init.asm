; ---[ VENTER 2 FRAMES TIL PPU KOMMER SEG ]---
	LDA $2002
	BPL Start
:	LDA $2002
	BPL :-
	
	; -[TURNS OFF RENDERING]-
	LDA #0
	STA PPU_CTRL_1
	STA PPU_CTRL_2
	

	; ---[ START LOAD PALETTE]---
	LDA #$3F
	STA $2006	; PPU output skal
	LDA #0		; settes til $3F00
	STA $2006		
	
	LDX #0
LastPalett:
	LDA palett, X
	STA $2007
	INX
	CPX #32
	BNE LastPalett
	; ---[ STOP LOAD PALETTE ]---
	
	
	
	
	
	
	
	
	
	

	;.include "screenshow.asm"

	
	
	
	
	
	
	
	
	
		; -[INIT BAKGRUNN]-
	LDX #0 ; column count
	LDY #0 ; row count
	
	
	LDA #$20
	STA PPU_ADRESS
	LDA #0
	STA PPU_ADRESS
Draw:
	CPX #1
	BEQ Draw_Row1
	JMP DrawNothing
	
Draw_Row1:	
	CPY #1
	BEQ Draw_L1
	JMP Draw_Finish
	
DrawNothing:
	LDA #$FF
	STA PPU_VALUE
	JMP Draw_Finish
	
	
Draw_L1:
	LDA #1
	STA PPU_VALUE
	JMP Draw_Finish

Draw_L2:
	LDA #2
	STA PPU_VALUE
	JMP Draw_Finish

Draw_L3:
	LDA #3
	STA PPU_VALUE
	JMP Draw_Finish

Draw_O1:
	LDA #4
	STA PPU_VALUE
	JMP Draw_Finish	
	
Draw_O2:
	LDA #5
	STA PPU_VALUE
	JMP Draw_Finish	
	
Draw_O3:
	LDA #6
	STA PPU_VALUE
	JMP Draw_Finish	
	
Draw_O4:
	LDA #7
	STA PPU_VALUE
	;JMP Draw_Finish	
	
Draw_Finish:	
	INX
	CPX #$20
	BEQ NextRow
	JMP Draw

NextRow:
	INY
	CPY #$1E
	BNE Draw
	
	
	
	
	
	.include "screentest.asm"
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
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
		
	; -[INIT PPU]-
	;bit# 76543210
	LDA #%10010000 ; V-Blank interrupt ON, Sprite size = 8x8,
	STA PPU_CTRL_1 ; BG tiles = $1000, Spr tiles = $0000, PPU adr inc = 1B
	;bit# 76543210
	LDA #%00011110 ; 
	STA PPU_CTRL_2