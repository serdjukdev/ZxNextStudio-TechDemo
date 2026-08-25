; level_001_objects -- object (sprite) placements on this map
; One `db` line per object -- 8 bytes: spriteIndex (this sprite's rank within its own Sprite4Bpp/Sprite8Bpp category), X lo, X hi, Y lo, Y hi (X/Y int16 little-endian), type, connect, userByte
; type = obj_<name> equ index from object_types.asm (0xFF = no type); connect = index of the linked object below (0xFF = no link); userByte reserved, always 0 for now
level_001_objects_count: equ 3

level_001_objects:
; [0] hero_0_0 at (288,96), type character
    db 0,32,1,96,0,0,255,0
; [1] portal at (48,176), type portal, links to [2] portal
    db 6,48,0,176,0,1,2,0
; [2] portal at (256,80), type portal, links to [1] portal
    db 6,0,1,80,0,1,1,0
