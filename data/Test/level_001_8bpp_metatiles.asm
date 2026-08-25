; level_001_8bpp_metatiles -- metatile definitions used by this map's 8bpp Tile layer
; 2x2 tiles/metatile, 1 byte(s)/tile (tile index only, no attribute)
; the grid file's index byte is LOCAL to this table (0..N-1 here), not this metatile's project-wide order
level_001_8bpp_metatiles_count: equ 10
level_001_8bpp_metatiles_size: equ 4 ; bytes per metatile record

level_001_8bpp_metatiles:
; [0] Blank_2
    db 0,0,0,0
; [1] metatile_8
    db 6,7,12,13
; [2] metatile_11
    db 2,3,8,9
; [3] metatile_18
    db 17,17,17,17
; [4] metatile_19
    db 17,17,20,17
; [5] metatile_20
    db 21,17,17,20
; [6] metatile_21
    db 27,25,17,17
; [7] metatile_22
    db 1,1,1,1
; [8] metatile_24
    db 26,29,29,30
; [9] metatile_25
    db 1,26,30,22
