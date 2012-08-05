; ------------------------------------------------- ;
; ---------------------[ RAM ]--------------------- ;
; ------------------------------------------------- ;
; This is a part of the RAM segment and everything  ;
; in this file represents places in the memory,     ;
; and can be refered to by the labels.				;
; ------------------------------------------------- ;	
	
	
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
	last_racket_hit:			.byte 0
	
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
.segment "OAM"
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
