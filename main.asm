; -------------------------	;
; ---[ MAIN LOOP START ]--- ;
; ------------------------- ;	
MainLoop:
	LDA PPU_STATUS
	BPL MainLoop
	
	
	
	
; ---[ SET X SCROLL ]---
	LDX x_scroll
	
	LDA scroll_direction
	CMP #$FF
	BEQ @scroll_left
	CMP #$00
	BEQ @scroll_right

	JMP @done_scrolling ;no_scroll
	
	@scroll_right:
		INX
		STX x_scroll
		CPX #$00
		BEQ @switch_nametable
		
		JMP @scroll_direction_set
	@scroll_left:
		DEX
		STX x_scroll
		CPX #$FF
		BEQ @switch_nametable
		
	@scroll_direction_set:
	


	JMP @done_scrolling
	
	@switch_nametable:	
		LDA current_nametable
		BEQ @next_nametable
		;previous_nametable
			LDA #%00
			JMP @nametable_chosen
		@next_nametable:
			LDA #%01
		@nametable_chosen:
			STA current_nametable

	@set_nametable:
		LDA ppu_ctrl_1
		EOR #%00000011
		STA ppu_ctrl_1

	@done_scrolling:
	
	



	
	
	
	
	

; ---[ RIGHT RACKET PLACEMENT ]---
	LDX #0 ; offset
	LDY #0 ; offset x4
RightRacket:
	; -[Y-KOORDINAT]-
	LDA right_racket_pos
	
	CPX #1
	BEQ @add_one
	CPX #2
	BEQ @add_two
	JMP @finished_adding
	
	@add_one:
		CLC
		ADC #8
		JMP @finished_adding
	@add_two:
		CLC
		ADC #16
	@finished_adding:
	STA right_racket_y, Y
	

	; -[X-KOORDINAT]-
	LDA #250
	STA right_racket_x, Y
	
	INX
	TXA
	ASL
	ASL ; y = x *4
	TAY
	
	CPX #3
	BNE RightRacket
	

	
; ---[ LEFT RACKET PLACEMENT ]---
	LDX #0 ; offset
	LDY #0 ; offset x4
LeftRacket:
	; -[Y-KOORDINAT]-
	LDA left_racket_pos
	
	CPX #1
	BEQ @add_one
	CPX #2
	BEQ @add_two
	JMP @finished_adding
	
	@add_one:
		CLC
		ADC #8
		JMP @finished_adding
	@add_two:
		CLC
		ADC #16
	@finished_adding:
	STA left_racket_y, Y
	
	; -[X-KOORDINAT]-
	LDA #0
	STA left_racket_x, Y
	
	INX
	TXA
	ASL
	ASL ; y = x *4
	TAY
	
	CPX #3
	BNE LeftRacket
	
	
	
	
	
	
	
	
	

		
; ---[RIGHT RACKET INPUT ]---
RightRacketInput:
		;A, B, Select, Start, Up, Down, Left, Right
		LDA #1
		STA PLAYER2
		LDA #0
		STA PLAYER2
		LDA PLAYER2 ; A
		LDA PLAYER2 ; B
		LDA PLAYER2 ; Select
		LDA PLAYER2 ; Start
		
		; -[CHECK UP BUTTON]-
		LDA PLAYER2 ; Up
		CMP #$41
		BNE @not_up
		LDA right_racket_pos
		SEC
		SBC #4
		CMP #214 ; 232 - 18
		BCC @up_not_OOR ; A < 232
		LDA #0
	@up_not_OOR:
		STA right_racket_pos

		JMP @end_of_task
		
	@not_up:
		; -[CHECK DOWN BUTTON]-
		LDA PLAYER2 ; Down
		CMP #$41
		BNE @end_of_task
		LDA right_racket_pos
		CLC
		ADC #4
		CMP #214 ; 232 - 18
		BCC @down_not_OOR ; A < 232
		LDA #214 ; 232 - 18
	@down_not_OOR:
		STA right_racket_pos
		
	@end_of_task:
	
	
	
	
	
	
; ---[LEFT RACKET INPUT ]---
LeftRacketInput:
		;A, B, Select, Start, Up, Down, Left, Right
		LDA #1
		STA PLAYER1
		LDA #0
		STA PLAYER1
		
		LDA PLAYER1 ; A
		LDA PLAYER1 ; B
		LDA PLAYER1 ; Select
		LDA PLAYER1 ; Start
		
		; -[CHECK UP BUTTON]-
		LDA PLAYER1 ; Up
		CMP #$41
		BNE @not_up
		LDA left_racket_pos
		SEC
		SBC #4
		CMP #214 ; 232 - 18
		BCC @up_not_OOR ; A < 232
		LDA #0
	@up_not_OOR:
		STA left_racket_pos
		JMP @end_of_task
		
	@not_up:
		; -[CHECK DOWN BUTTON]-
		LDA PLAYER1 ; Down
		CMP #$41
		BNE @end_of_task
		LDA left_racket_pos
		CLC
		ADC #4
		CMP #214 ; 232 - 18
		BCC @down_not_OOR ; A < 232
		LDA #214 ; 232 - 18
	@down_not_OOR:
		STA left_racket_pos
		
	@end_of_task:
		
		
		
	
	
	
	
	
	
	
	
	
	

; ---[ MOVE BALL ]---
	; -[OPPDATERER X]-
	LDA x_pos
	CLC
	ADC x_vector
	TAX
	STA x_pos
	STA ball_x ; update OAM
	
	; -[OPPDATERER Y]-
	LDA y_pos
	CLC
	ADC y_vector
	TAY
	STA y_pos
	STA ball_y ; update OAM	
	
	
	
	
; ---[ HIT ONE OF THE WALLS? ]---
		CPX #LEFT_WALL
		BCC @hit_left_wall
		CPX #RIGHT_WALL
		BCS @hit_right_wall
		; else
		JMP TestEdgeY
		
		@hit_left_wall:
			;LDA #1
			;STA racket
			LDY #-1
			JMP @wall_hit
		@hit_right_wall:
			;LDA #2
			;STA racket
			LDY #1
			JMP @wall_hit

		
	; -[CHECK IF BALL WAS CAUGHT BY A RACKET]-
	@wall_hit: 
		JSR CheckHitFlipper
		LDA delta_racket_hit
		CMP #$FF
		BEQ FlipperNoHit ; NO HIT (breaks loop)

	; -[RACKET HIT]-
		
	; -[CHECK AND SET PANICK MODE]-
		LDA panick_mode
		CMP #1
		BEQ @end_of_panick_check
		
		LDX hit_count
		INX
		STX hit_count
		CPX #5
		JMP @end_of_panick_check ;BCC @end_of_panick_check ; X<5					;PANIC MODE DISABLED
		LDA #1
		STA panick_mode ; Enable panick mode
	@end_of_panick_check:
		
		
		
	; -[UPDATE Y-VECTOR]-
		LDA delta_racket_hit_positive
		CMP #1
		BEQ @negative_vector
		
	;@positive_vector
		LDA y_vector
		CLC
		ADC delta_racket_hit
		
		;CMP #10 				; KONSTANT.MAX_Y_VECTOR
		;BCC @size_ok
		;LDA #10					; KONSTANT.MAX_Y_VECTOR
		;JMP @size_ok
		
	@negative_vector:
		LDA y_vector
		SEC
		SBC delta_racket_hit
		;CMP #-10				; KONSTANT.MIN_Y_VECTOR
		;BCS @size_ok
		;LDA #-10				; KONSTANT.MIN_Y_VECTOR
		JMP @size_ok

	@size_ok:
		STA y_vector
		
		LDA #0
		SEC
		SBC x_vector
		STA x_vector
		JMP TestEdgeY
; -------------------------------
		
		
	
	
	; -[HIT ROOF OR FLOOR?]-
TestEdgeY:
	CPY #232
	BCS @roof_floor_hit ; y >= 232
	CPY #0
	BEQ @roof_floor_hit
	
	JMP MainLoop ; No hit
	
	
	; ---[ROOF/FLOOR HIT]---
@roof_floor_hit:
	LDA #0
	SEC
	SBC y_vector
	STA y_vector
	JMP MainLoop

; ----------------------- ;
; ---[ MAIN LOOP END ]--- ;
; ----------------------- ;
	
	
	
	
	
	
	
	
; ---[ FLIPPER MISS ]---------------------
FlipperNoHit:
;		LDX x_pos
		;CPX #LEFT_WALL
		CPY #1
		BEQ @p2_win
		;CPX #RIGHT_WALL
		CPY #-1
		BEQ @p1_win
		;JMP PanickMode
	@p1_win:
		LDX p1_score
		INX
		STX p1_score
		
		JMP WaitForUser
	@p2_win:
		LDX p2_score
		INX
		STX p2_score
		
		JMP WaitForUser
; ----------------------------------------


; ---[ WAITS FOR THE USER TO PUSH 'A' ]---
WaitForUser:
		LDA #1
		STA panick_mode
		LDA #1
		STA PLAYER1
		STA PLAYER2
		LDA #0
		STA PLAYER1
		STA PLAYER2
		
		LDA PLAYER1 ; A
		AND #1
		BNE @end_of_wait
		
		LDA PLAYER2 ; A
		AND #1
		BNE @end_of_wait
		
		JMP WaitForUser
	@end_of_wait:
		
		; -[DISABLE PANICK MODE]-
		LDA #0
		STA panick_mode 
	
		; -[SET BG COLOR]-
		LDA #$3F
		STA PPU_ADRESS
		LDA #$00
		STA PPU_ADRESS
		LDA #BG_COLOR
		STA PPU_VALUE
		

		
		CPY #1
		BEQ @p2_start
		
		@p1_start:
			; -[INIT BALL POSITION]-
			LDA #50
			STA x_pos
			LDA left_racket_pos
			STA y_pos
		
			; -[INIT BALL X VECTOR]-
			LDA #2
			STA x_vector
			
			; -[INIT SCROLL DIRECTION]-
			LDA #$00
			STA scroll_direction
			
			JMP @init_y_vector
			
		
		@p2_start:
			; -[INIT BALL POSITION]-
			LDA #200
			STA x_pos
			LDA right_racket_pos
			STA y_pos
		
			; -[INIT BALL X VECTOR]-
			LDA #-2
			STA x_vector
			
			; -[INIT SCROLL DIRECTION]-
			LDA #$FF
			STA scroll_direction
			
			;JMP @init_y_vector
			
		@init_y_vector:	
			LDA y_pos
			CMP #116
			BCS @ball_rise
			
			@ball_fall:
				LDA #1
				JMP :+
			@ball_rise:
				LDA #-1
			:	
			STA y_vector
		JMP MainLoop
; ----------------------------------------
	
	; La det stå "Player X is victorious!!" elns når player X vinner
	
	
	
	
; ------ [ FUNCTION CHECK HIT FLIPPER START ] ------
; Returns offset in delta_racket_hit
; $FF means no hit
; Uses variable 'racket'
; racket = 1 means check for player 1 racket
; racket = 2 means check for player 2 
; On call, Y should contain data for which 
; racket should be checked for.
; Y = -1 means left racket
; Y = 1 means right racket
CheckHitFlipper:
		PHA
		TXA
		PHA
		TYA
		PHA
		
		LDA racket
		CPY #-1
		BEQ @left_racket
		CPY #1
		BEQ @right_racket
		
	@left_racket:
		LDA left_racket_pos
		STA racket
		JMP @racket_selected
	@right_racket:
		LDA right_racket_pos
		STA racket
		;JMP @racket_selected
	@racket_selected:

		; -[SET UPPER LIMIT]-
		LDA racket
		SEC
		SBC #4
		CMP #233
		BCC @top_limit_set
		LDA #0
	@top_limit_set:
		TAX
		; -[SET LOWER LIMIT]-
		LDA racket
		CLC
		ADC #28
		CMP #233
		BCC @low_limit_set
		LDA #232 ; if (a>232)
	@low_limit_set:
		TAY
		
	; -[TEST UPPER LIMIT]-
		CPX y_pos
		BCS @no_hit ; if (X >= pos), (pos < X)
		
	; -[TEST LOWER LIMIT]-
		CPY y_pos
		BEQ @racket_hit
		BCC @no_hit ; if (Y <= pos), (pos > Y)
		
	; -[HIT]-
	@racket_hit:
		;set scroll
		LDA scroll_direction
		EOR #$FF
		STA scroll_direction
	
		LDA y_pos
		SEC
		SBC racket
		CMP #8
		BCC @high_hit ; ballpos < sweet_spot
		CMP #17
		BCS @low_hit ; ballpos > sweet_spot
	
	;RacketHitSweetSpot
		LDA #0
		JMP @hit_check_complete
	@high_hit:
		LDA #1
		STA delta_racket_hit_positive
		JMP @hit_check_complete
	@low_hit:
		LDA #0
		STA delta_racket_hit_positive
		LDA #1
		;JMP @hit_check_complete
		
	@hit_check_complete:	
		STA delta_racket_hit
		JMP @end_of_sub_routine
		
	@no_hit:
		LDA #$FF
		STA delta_racket_hit

	@end_of_sub_routine:
		PLA
		TAY
		PLA
		TAX
		PLA
		RTS ; return
; ------ [ FUNCTION CHECK HIT FLIPPER END ] ------




PanickMode:
		LDA panick_mode
		CMP #0
		BEQ @skip
		
		LDA #$3F
		STA PPU_ADRESS	; PPU output skal
		LDA #$00		; settes til $3F11 (bakgrunnsfarge)
		STA PPU_ADRESS	

		LDX bg_color
		STX PPU_VALUE
		
		INX
		STX bg_color
		
	@skip:
		RTS ; return