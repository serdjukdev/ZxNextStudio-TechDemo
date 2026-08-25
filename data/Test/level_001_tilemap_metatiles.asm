; level_001_tilemap_metatiles -- metatile definitions used by this map's Tilemap layer
; 2x2 tiles/metatile, 2 byte(s)/tile (tile index, then attribute byte: bits7:4 palette, bit3 MirrorX, bit2 MirrorY, bit1 Rotate)
; the grid file's index byte is LOCAL to this table (0..N-1 here), not this metatile's project-wide order
level_001_tilemap_metatiles_count: equ 17
level_001_tilemap_metatiles_size: equ 8 ; bytes per metatile record

level_001_tilemap_metatiles:
; [0] Blank
    db 0,0,0,0,0,0,0,0
; [1] metatile_9
    db 0,0,0,0,39,0,40,0
; [2] metatile_2
    db 25,0,26,0,29,0,30,0
; [3] metatile_3
    db 27,0,28,0,31,0,32,0
; [4] metatile_26
    db 0,0,0,0,44,0,45,0
; [5] metatile
    db 1,0,2,0,7,0,8,0
; [6] metatile_4
    db 15,0,16,0,21,0,22,0
; [7] metatile_5
    db 17,0,18,0,23,0,24,0
; [8] metatile_6
    db 3,0,4,0,11,0,13,0
; [9] metatile_7
    db 0,0,49,0,0,0,50,0
; [10] metatile_13
    db 35,0,0,0,36,0,0,0
; [11] metatile_15
    db 0,0,0,0,0,0,47,0
; [12] metatile_14
    db 0,0,0,0,33,0,0,0
; [13] metatile_27
    db 0,0,50,0,0,0,51,0
; [14] metatile_28
    db 36,0,0,0,41,0,0,0
; [15] metatile_29
    db 34,0,0,0,43,0,46,0
; [16] metatile_30
    db 0,0,0,0,45,0,46,0
