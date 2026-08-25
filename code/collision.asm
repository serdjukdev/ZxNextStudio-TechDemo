        module   Collision

update:
	call	check_walls
	call	check_objects
	ret

check_objects:
	ld	ix,level_001_objects
	ld	b,level_001_objects_count
.loop:
	push	bc
	ld	a,(ix + obj_data.ID)
	or	a		; character id
	jr	z,.skip
	
	ld	hl,(Input.player_x)
	ld	c,(ix + obj_data.X)
	ld	b,(ix + obj_data.X + 1)
	or	a
	sbc	hl,bc
	jr	nz,.skip

	ld	hl,(Input.player_y)
	ld	c,(ix + obj_data.Y)
	ld	b,(ix + obj_data.Y + 1)
	or	a
	sbc	hl,bc
	jr	nz,.skip

	ld	a,(ix + obj_data.TYPE)
	cp	obj_portal
	call	z,Sprite.teleport	

.skip:
	ld	bc,8
	add	ix,bc
	pop	bc
	djnz	.loop
	ret

check_walls:
	ld	de,(Input.player_next_y)
	ld	b,4
	bsra	de,b
	ld	d,20 	; 2x2 metitiles tilemap row length
	mul	d,e
	ex	de,hl
	ld	de,(Input.player_next_x)
	bsra	de,b
	add	hl,de
	add	hl,grid
	ld	a,(hl)
	cp	5	; first five metatiles as empty
	ret	c
	; stop move
	ld	hl,(Input.player_x)
	ld	(Input.player_next_x),hl
	ld	hl,(Input.player_y)
	ld	(Input.player_next_y),hl
	ret

        endmodule