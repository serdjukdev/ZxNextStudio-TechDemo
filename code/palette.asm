; --- nextreg $43 bits6:4: which palette a write targets ---
PALETTE_SEL_LAYER2_1ST:			equ	%00010000
PALETTE_SEL_SPRITES_1ST:		equ	%00100000
PALETTE_SEL_TILEMAP_1ST:		equ	%00110000


	module	Pal

init:
		nextreg	0x4B,0xE3   ; Sprite Transparency Index
		nextreg	0x14,0xE3   ; Global Transparency Colour
		nextreg	0x4C,0x0F   ; Tilemap Transparency Index

		call	set_layer2_pal
		call	set_sprites_pal
		call	set_tiles_pal

		ret

set_layer2_pal:
		nextreg	#43,PALETTE_SEL_LAYER2_1ST
		ld	hl,l2_pal
		jr	set_pal

set_sprites_pal:
		nextreg	#43,PALETTE_SEL_SPRITES_1ST
		ld	hl,spr_pal
		jr	set_pal

set_tiles_pal:
		nextreg	#43,PALETTE_SEL_TILEMAP_1ST
		ld	hl,tile_pal
		jr	set_pal

; + Set nexterg #43 for:
; +     sprites:	%00100000
; +     layer2:		%00010000
; +     tiles:		%00110000
; + HL - palette start address
set_pal:
		ld	b,0
.loop:
		ld	a,(hl)
		nextreg	#44,a
		inc	h
		ld	a,(hl)
		nextreg	#44,a
		dec	h
		inc	hl
		djnz	.loop
		ret

	endmodule