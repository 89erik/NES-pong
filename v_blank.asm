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
		
	
	
PanickMode:
		LDA panick_mode
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