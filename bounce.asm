.include "constants.inc"

.segment "INES"
	.byte "NES", $1A,1,1,1
	;      012    3  4 5 6
	;http://wiki.nesdev.com/w/index.php/INES
;1001
.segment "VECTORS"
	.word NMI 
	.word Start
	.word IRQ

.segment "GFX"
spr_tiles:
	.incbin "sprites.spr"
bg_tiles:
	.incbin "bakgrunn.chr"
	
.segment "CODE"

.include "init.asm"
.include "main.asm"
	
	
palett:
	; Bakgrunnsgrafikk
	.byte 0, $12, $3C, $09
	.byte 0, $15, $3C, $09
	.byte 0, $15, $3C, $09
	.byte 0, $15, $3C, $09
	
	.byte $11, $2A, $28, $15
	.byte $11, $15, $3C, $09
	.byte $11, $3F, $37, $00
	.byte $11, 0, 0, 0
	


NMI: ; ---[ V-BLANK INTERRUPT ]---
	PHA
	TXA
	PHA

	LDA PPU_STATUS		; clear adress part latch
	
	JSR PanickMode
		
	; -[SCROLL]-
	LDA x_scroll
	STA PPU_SCROLL
	LDA y_scroll
	STA PPU_SCROLL
	
	; -[UPDATE PPU CONTROLL REGISTERS]-
	LDA ppu_ctrl_1
	STA PPU_CTRL_1
	
	; -[DMA OAM UPDATE]-
	LDA #$00
	STA $2003
	LDA #$02
	STA $4014
	
	LDA #1
	STA wait_for_v_blank
	
	PLA
	TAX
	PLA
	RTI ; ReTurn from Interrupt
	
IRQ:
	jmp IRQ
	
.segment "RAM"
	; Midlertidige variabler
	derp:						.byte 0
	tmp1:						.byte 0
	tmp2:						.byte 0
	tmp3:						.byte 0
	
	; State variables
	panick_mode:				.byte 0
	bg_color:					.byte 0
	p1_score:					.byte 0
	p2_score:					.byte 0
	hit_count:					.byte 0
	wait_for_v_blank:			.byte 0
	
	; Scrolling
	x_scroll:					.byte 0
	y_scroll:					.byte 0
	scroll_direction:			.byte 0
		
	; Registers
	ppu_ctrl_1:					.byte 0

	
	; The ball
	x_vector: 					.byte 0
	y_vector: 					.byte 0
	
	; The rackets
	racket:						.byte 0
	left_racket_pos: 			.byte 0
	right_racket_pos: 			.byte 0
	
	delta_racket_hit:			.byte 0
	delta_racket_hit_positive:	.byte 0
	
	; Object Attribute Memory
	.org $0200
	ball_y:						.byte 0
	ball_tile:					.byte 0
	ball_attribute:				.byte 0
	ball_x:						.byte 0

	right_racket_y:				.byte 0
	right_racket_tile:			.byte 0
	right_racket_attribute:		.byte 0
	right_racket_x:				.byte 0
								.byte 0,0,0,0	; kopi
								.byte 0,0,0,0	; kopi

							
	left_racket_y:				.byte 0
	left_racket_tile:			.byte 0
	left_racket_attribute:		.byte 0
	left_racket_x:				.byte 0
								.byte 0,0,0,0	; kopi
								.byte 0,0,0,0	; kopi
								
	p1_score_y:					.byte 0
	p1_score_tile:				.byte 0
	p1_score_attribute:			.byte 0
	p1_score_x:					.byte 0
								.byte 0,0,0,0	; high digit
							
	p2_score_y:					.byte 0
	p2_score_tile:				.byte 0
	p2_score_attribute:			.byte 0
	p2_score_x:					.byte 0
								.byte 0,0,0,0	; high digit
	
							
	nametable_offset:		.byte 0
	nametable:
	row1: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row2: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row3: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row4: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row5: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row6: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row7: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row8: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row9: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row10: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row11: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row12: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row13: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row14: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row15: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row16: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row17: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row18: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row19: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row20: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row21: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row22: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row23: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row24: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row25: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row26: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row27: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row28: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row29: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	row30: 	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0