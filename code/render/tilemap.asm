TM_CONTROLL  		equ #6B
; старший байт начала адреса тайловой карты
TM_MAP			equ #6E		
; старший байт начала адреса тайловых спрайтов
TM_TILES		equ #6F		
; индекс прозрачного цвета в 16 цветной палитре
TM_TRANSPARENT_INDEX	equ #4C		
TM_MAP_ADDR:		equ #6000
TM_TILES_ADDR:		equ #4000

TM_SCROLL_Y		equ #31	
TM_SCROLL_X		equ #30	
TM_SCROLL_X_H		equ #2F	
TM_CLIP_REG:		equ #1B


        module  TM


init:
	nextreg	TM_TRANSPARENT_INDEX, 15
	nextreg	TM_CONTROLL, %10000001
	nextreg	TM_MAP, high TM_MAP_ADDR
	nextreg	TM_TILES, high TM_TILES_ADDR
        call    clear
        ld      ix,grid
        ld      hl,TM_MAP_ADDR
        call    draw_metatile
        ret


clear:
        ld      hl,TM_MAP_ADDR
        ld      de,TM_MAP_ADDR + 2
        ld      bc,80 * 32 - 2
        ld      (hl),0
        inc     hl
        ld      (hl),0
        dec     hl
        ldir
        ret

; + IX - grid address 
; + HL - tilemap address
draw_metatile:

        ld      iyh,level_001_tilemap_grid_height
.loop:
        push    hl
        ld      iyl,level_001_tilemap_grid_width
.next:
        push    hl

        ld      e,(ix)
        ld      d,level_001_tilemap_metatiles_size
        mul     d,e
        add     de,metatiles
        ex      de,hl
        ldi
        ldi
        ldi
        ldi
        add     de,80-4
        ldi
        ldi
        ldi
        ldi
        pop     hl
        add     hl,4
        inc     ix
        dec     iyl
        jr      nz,.next
        pop     hl
        add     hl,160
        dec     iyh
        jr      nz,.loop
        ret

        endmodule