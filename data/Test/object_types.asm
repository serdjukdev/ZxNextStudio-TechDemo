; object_types.asm -- project-wide object type IDs, shared by every map's *_objects.asm
; obj_<name>: equ <type index> -- a map's objects row writes this index as an object record's `type` byte (0xFF = no type assigned)
obj_character: equ 0
obj_portal: equ 1
