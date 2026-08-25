
L2_SCROLL_Y		equ #17	
L2_SCROLL_X		equ #16	
L2_SCROLL_X_H		equ #71	
L2_SLOT:	        equ 30
L2_RES_256X192X8        equ %00000000
L2_RES_320X256X8        equ %00010000
L2_RES_640X256X4        equ %00100000
L2_ACTIVE_BANK          equ #12   ; 16K RAM bank Layer2 reads pixels from
L2_CONTROL              equ #70   ; bits5:4=resolution, bits3:0=palette offset
DISPLAY_CONTROL		equ #69
DATA_SLOT:	        equ	40


        struct L2_DATA
RES:    byte
X:      word
Y:      byte
FROM:   word
W:      word
H:      byte
        ends


data:
        db      0
        dw      23
        db      17
        dw      #E000
        dw      160             ; / 2 for 640x256
        db      48

        module  L2
; + A - resolution bit
init:

        nextreg #18,0
        nextreg #18,159
        nextreg #18,0
        nextreg #18,255

	nextreg L2_CONTROL, a
        call    clear
	nextreg	#56,L2_SLOT
	nextreg	#57,DATA_SLOT
	nextreg	L2_ACTIVE_BANK,L2_SLOT / 2


        ld      ix,l2_grid
        ld      hl,#C000
        call    draw_metatiles_2x2
        ret
        
hide:
	nextreg	DISPLAY_CONTROL,%00000000 
        ret

; + IX - grid address 
; + HL - layer2 address
draw_metatiles_2x2:


        ld      b,level_001_8bpp_grid_height
.loop:
        push    bc
        push    hl
        ld      a,L2_SLOT
        nextreg #56,a
        exa
        ld      b,level_001_8bpp_grid_width
.line:
        push    bc

        ld      a,h
        cp      #E0
        jr      nz,.save_slot
        exa
        inc     a
        nextreg #56,a
        exa
        ld      h,#C0
.save_slot:
        ld      e,(ix)
        inc     ix
        ld      d,level_001_8bpp_metatiles_size
        mul     d,e
        add     de,l2_metatiles
        push    de
        pop     iy
        call    draw_tile
        add     hl,#0800
        call    draw_tile
        add     hl,#0000 - #07F8
        call    draw_tile
        add     hl,#0800
        call    draw_tile
        add     hl,#07F8

        pop     bc
        djnz    .line

        pop     hl
        add     hl,16

        pop     bc
        djnz    .loop

        ret

; + (IY) - tile id
; + HL - layer 2 address
draw_tile:
        ld      a,(iy)
        inc     iy
        ld      e,a
        ld      d,64    ; размер тайла для layer2 8bpp
        mul     d,e
        add     de,l2_tiles

        push    hl
        ex      de,hl
        ld      a,8
.next_column:
        push    de
        dup     8
        ldi
        edup
        pop     de
        inc     d
        dec     a
        jr      nz,.next_column
        pop     hl
        ret

; + DE - X position
; + L - Y position
; + return:
; +     HL - address
; +     A - slot offset
calc_addr_by_position:
        push    de
        ld      a,e
        and     %00011111
        or      #C0     ; high address byte
        ld      h,a     ; H - addr offset
        pop     de        
        ld      b,5
        bsrl    de,b
        ld      a,e     ; A - slot offest
        ret

clear:
	ld	b,10
	ld	a,L2_SLOT
.loop:
	nextreg	#56,a
	inc	a
	push	bc
	ld	hl,#C000
	ld	de,#C001
	ld	bc,8191
	ld	(hl),0
	ldir
	pop	bc
	djnz	.loop
	ret


        endmodule