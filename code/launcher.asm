		device	ZXSPECTRUMNEXT
		cspectmap	"labels.map"


START_PROG:	equ	#8100

		org	START_PROG
		ld	sp,$
		nextreg	#07,%00000011		; 28 MHz
		nextreg	#15,%01010011
		nextreg	#68,%10000000
		nextreg	DISPLAY_CONTROL,%10000000
		call	Pal.init
		call	TM.init
		ld	a,L2_RES_320X256X8
		call	L2.init
		call	Sprite.init
main_loop:
		ei
		halt
		call	Input.update
		call	Collision.update
		call	Sprite.update
		jr	main_loop

		include	"render/layer2.asm"
		include	"render/sprite.asm"
		include	"render/tilemap.asm"
		include	"input.asm"
		include	"collision.asm"
		include	"palette.asm"

objects:
		include	"data/Test/object_types.asm"
		include	"data/Test/level_001_objects.asm"
sprites_data:
		include	"data/Test/sprite_4bpp_images_gfx.asm"
grid:
		include	"data/Test/level_001_tilemap_grid.asm"
metatiles:
		include	"data/Test/level_001_tilemap_metatiles.asm"

l2_grid:
		include	"data/Test/level_001_8bpp_grid.asm"
l2_metatiles:
		include	"data/Test/level_001_8bpp_metatiles.asm"
l2_tiles:
		incbin	"data/Test/tile_8bpp_images_gfx.til"

tile_pal:
		incbin	"data/Test/tile_4bpp_images_gfx.pal"
l2_pal:
		incbin	"data/Test/tile_8bpp_images_gfx.pal"
spr_pal:
		incbin	"data/Test/sprite_4bpp_images_gfx.pal"



		mmu	2,10
		org	TM_TILES_ADDR
		incbin	"data/Test/tile_4bpp_images_gfx.til"

		mmu	6 7,SPR_SLOT
		org	#C000
		incbin	"data/Test/sprite_4bpp_images_gfx.spr"


		SAVENEX	OPEN "build/game.nex",START_PROG
		SAVENEX	CORE 3,0,0		; Next core 2.0.0 minimum required
		SAVENEX	CFG 0,0,0,0		; green border, file handle in BC, reset NextRegs, 2MB required
		SAVENEX	AUTO
		SAVENEX	CLOSE
