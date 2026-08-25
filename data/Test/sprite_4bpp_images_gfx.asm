slot_000: equ 0

hero_0_0:
    db slot_000 ; 8KB bank
    db 1 ; 4bpp palette index (0-15)
    dw 0 ; byte offset within the bank
hero_16_0:
    db slot_000 ; 8KB bank
    db 1 ; 4bpp palette index (0-15)
    dw 128 ; byte offset within the bank
hero_32_0:
    db slot_000 ; 8KB bank
    db 1 ; 4bpp palette index (0-15)
    dw 256 ; byte offset within the bank
hero_48_0:
    db slot_000 ; 8KB bank
    db 1 ; 4bpp palette index (0-15)
    dw 384 ; byte offset within the bank
hero_64_0:
    db slot_000 ; 8KB bank
    db 1 ; 4bpp palette index (0-15)
    dw 512 ; byte offset within the bank
hero_80_0:
    db slot_000 ; 8KB bank
    db 1 ; 4bpp palette index (0-15)
    dw 640 ; byte offset within the bank
portal:
    db slot_000 ; 8KB bank
    db 0 ; 4bpp palette index (0-15)
    dw 768 ; byte offset within the bank
