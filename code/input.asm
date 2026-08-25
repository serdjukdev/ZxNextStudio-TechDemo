; half-row	DEC	HEX	BIN
; Space...B	32766	7FFE	01111111 11111110
; Enter...H	49150	BFFE	10111111 11111110
; P...Y		57342	DFFE	11011111 11111110
; 0...6		61438	EFFE	11101111 11111110
; 1...5		63486	F7FE	11110111 11111110
; Q...T		64510	FBFE	11111011 11111110
; A...G		65022	FDFE	11111101 11111110
; CS...V	65278	FEFE	11111110 11111110

	module	Input

is_horizontal_moving:
		db	0
is_vertical_moving:
		db	0
player_x:
		dw	0
player_y:
		dw	0

player_next_x:
		dw	0
player_next_y:
		dw	0

update:
		ld	hl,(player_x)
		ld	bc,(player_next_x)
		or	a
		sbc	hl,bc
		ret	nz
		ld	hl,(player_y)
		ld	bc,(player_next_y)
		or	a
		sbc	hl,bc
		ret	nz

		call	horizontal
		ld	hl,(player_x)
		ld	bc,(player_next_x)
		or	a
		sbc	hl,bc
		ret	nz
		ld	hl,(player_y)
		ld	bc,(player_next_y)
		or	a
		sbc	hl,bc
		ret	nz

		call	vertical
		ret


horizontal:

		ld	bc,#DFFE
		in	a,(c)
		rrca
		jr	nc,.to_right
		rrca
		ret	c
.to_left:
		ld	hl,(player_next_x)
		add	hl,#0000 - #0010
		ld	(player_next_x),hl
		ld	a,%00001000
		ld	(mirror_x),a
		ret

.to_right:
		ld	hl,(player_next_x)
		add	hl,#0010
		ld	(player_next_x),hl
		xor	a
		ld	(mirror_x),a
		ret

vertical:

		ld	bc,#FBFE
		in	a,(c)
		rrca
		jr	nc,.to_up
		ld	bc,#FDFE
		in	a,(c)
		rrca
		ret	c
.to_down:
		ld	hl,(player_next_y)
		add	hl,#0010
		ld	(player_next_y),hl
		ret
.to_up:
		ld	hl,(player_next_y)
		add	hl,#0000 - #0010
		ld	(player_next_y),hl
		ret


	endmodule