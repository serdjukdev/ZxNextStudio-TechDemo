
SPR_8BPP_SIZE:	equ	256
SPR_4BPP_SIZE:	equ	128
SPR_SLOT:	equ	50


portal_id:
		db	255
mirror_x:
		db	0

	struct	obj_data
ID:		byte    ; sprite pattern
X:		word
Y:		word
TYPE:		byte
LINKED:		byte
USER:		byte
	ends

	module	Sprite

DURATION:	equ	4
current_frame:
		db	0
duration:
		db	0

init:
		nextreg	#09,%00010000

		call	to_fpga
		call	get_objects

		ld	ix,level_001_objects
		ld	l,(ix+obj_data.X)
		ld	h,(ix+obj_data.X+1)
		ld	(Input.player_x),hl
		ld	(Input.player_next_x),hl
		ld	l,(ix+obj_data.Y)
		ld	h,(ix+obj_data.Y+1)
		ld	(Input.player_y),hl
		ld	(Input.player_next_y),hl
		ret
update:
		call	move
		call	next_frame
		ld	a,(current_frame)       ; sprite pattern index
		ld	l,a
		ld	a,(current_frame)       ; sprite pattern index
		call	get_4bpp_pal_index
		ld	h,a
		ld	a,(Input.player_x+1)
		or	h
		ld	h,a
		ld	a,(mirror_x)
		or	h
		ld	h,a
		ld	a,(Input.player_x)
		ld	e,a
		ld	a,(Input.player_y)
		ld	d,a
		xor	a                       ; sprite index
		call	set
		ret

; + IX - object data
teleport:
		ld	a,(portal_id)
		cp	(ix+obj_data.ID)
		ret	z
		ld	e,(ix+obj_data.LINKED)
		ld	d,8
		mul	d,e
		add	de,level_001_objects
		ld	a,(de)		; other portal id
		ld	(portal_id),a
		inc	de
	; copy X other portal
		ld	a,(de)
		ld	l,a
		inc	de
		ld	a,(de)
		ld	h,a
		inc	de
		ld	(Input.player_x),hl
		ld	(Input.player_next_x),hl
	; copy Y other portal
		ld	a,(de)
		ld	l,a
		inc	de
		ld	a,(de)
		ld	h,a
		ld	(Input.player_y),hl
		ld	(Input.player_next_y),hl
		ret
move:
		call	.horizontal
.vertical:
		ld	hl,(Input.player_y)
		ld	bc,(Input.player_next_y)
		or	a
		sbc	hl,bc
		ret	z
		ld	hl,(Input.player_y)
		jr	nc,.to_up
.to_down:
		inc	hl
		ld	(Input.player_y),hl
		ld	a,255
		ld	(portal_id),a
		ret
.to_up:
		dec	hl
		ld	(Input.player_y),hl
		ld	a,255
		ld	(portal_id),a
		ret

.horizontal:
		ld	hl,(Input.player_x)
		ld	bc,(Input.player_next_x)
		or	a
		sbc	hl,bc
		ret	z
		ld	hl,(Input.player_x)
		jr	nc,.to_left
.to_right:
		inc	hl
		ld	(Input.player_x),hl
		ld	a,255
		ld	(portal_id),a
		ret
.to_left:
		dec	hl
		ld	(Input.player_x),hl
		ld	a,255
		ld	(portal_id),a
		ret

get_objects:

		ld	ix,level_001_objects
		ld	iyl,0           ; sprite id
		ld	b,level_001_objects_count
.next_obj:
		push	bc
		ld	a,(ix+obj_data.ID)
		ld	l,a
		ld	a,(ix+obj_data.ID)
		call	get_4bpp_pal_index
		or	(ix+obj_data.X+1)
		ld	h,a
		ld	d,(ix+obj_data.Y)
		ld	e,(ix+obj_data.X)
		ld	a,iyl
		call	set
		ld	bc,8
		add	ix,bc
		inc	iyl
		pop	bc
		djnz	.next_obj
		ret

; + A - sprite pattern index
; + return:
; +     A - offset palette
get_4bpp_pal_index:
		rlca
		rlca
		ld	bc,hero_0_0
		add	bc,a
		inc	bc
		ld	a,(bc)
		swapnib
		ret

next_frame:
		ld	a,(duration)
		dec	a
		ld	(duration),a
		ret	p

		ld	a,DURATION
		ld	(duration),a
		ld	a,(current_frame)
		inc	a
		cp	6
		jr	c,.l1
		xor	a
.l1:
		ld	(current_frame),a
		ret

; + A = sprite index
; + D = Y
; + E = X
; + H = attribute 2
; + L = attribute 3
; + Если 4-ый бит регистра #09 выключен то будет происходить автоинкремент индекса спрайта.
; + То есть после заполнения 4 и 5 атрибута индекс спрайта увеличится автоматически на 1
; + В этом случае установка индекса спрайта в регистр #34 не будет иметь значения.
; + Что бы вызов процедуры работал с произвольными индексами спрайта, включите 4-ый бит регистра #09, и перед каждым вызовом устанавите требуемый индекс спрайта в регистр #34
set:
		nextreg	#34,a
		ld	c,#57     	; порт атрибутов спрайта
; ATTRIBUTE 0
; x coordinate
		out	(c),e       	; attribute 0
; ATTRIBUTE 1
; y coordinate
		out	(c),d       	; attribute 1
; ATTRIBUTE 2
; P P P P XM YM R X8/PR
; P = 4-bit Palette Offset
; XM = 1 to mirror the sprite image horizontally
; YM = 1 to mirror the sprite image vertically
; R = 1 to rotate the sprite image 90 degrees clockwise
; X8 = Ninth bit of the sprite’s X coordinate
; PR = 1 to indicate P is relative to the anchor’s palette offset (relative sprites only)
		out	(c),h       	; attribute 2

		ld	a,l
		sra	a
        ; jr 	nc,.even
	;	четные
		or	%11000000
; ATTRIBUTE 3
; V E N5 N4 N3 N2 N1 N0
; V = 1 to make the sprite visible
; E = 1 to enable attribute byte 4
; N = Sprite pattern to use 0-63
; If E=0, the sprite is fully described by sprite attributes 0-3. The sprite pattern is an 8-bit one identified by pattern N=0-63. The sprite is an anchor and cannot be made relative. The sprite is displayed as if sprite attribute 4 is zero.
; If E=1, the sprite is further described by sprite attribute 4.
		out	(c),a       	; attribute 3
		ld	a,%10000000
; ATTRIBUTE 4
; H N6 T X X Y Y Y8
; H = 1 if the sprite pattern is 4-bit
; N6 = 7th pattern bit if the sprite pattern is 4-bit
; T = 0 if relative sprites are composite type else 1 for unified type
; XX = Magnification in the X direction (00 = 1x, 01 = 2x, 10 = 4x, 11 = 8x)
; YY = Magnification in the Y direction (00 = 1x, 01 = 2x, 10 = 4x, 11 = 8x)
; Y8 = Ninth bit of the sprite’s Y coordinate
		out	(c),a       	; attribute 4
		ret
.even:
	;	не четные
		or	%11000000
		out	(c),a       	; attribute 3
		ld	a,%10000000
		out	(c),a       	; attribute 4
		ret

; + IX - sprites file path
to_fpga:
		nextreg	#56,SPR_SLOT
		nextreg	#57,SPR_SLOT+1
		ld	hl,#C000
		ld	e,7
.fill:
		ld	bc,#303b     	; Порт индексов шаблона спрайта
		out	(c),a       	; индекс шаблона
                        	; индекс шаблона определяет где находится спрайт в FPGA памяти для вызова и работы с ним
                        	; переполнение FPGA памяти приведет к неожиданным последствиям

		ld	c,#5b     	; порт загрузки шаблонов спрайтов в память FPGA
.sendByte:
		dup	SPR_4BPP_SIZE
		outinb
		edup
		dec	e
		jp	nz,.sendByte
		ei
		ret



	endmodule