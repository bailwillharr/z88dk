
SECTION code_driver

PUBLIC ide_read_sector

EXTERN __IO_IDE_SEC_CNT, __IO_IDE_COMMAND

EXTERN __IDE_CMD_READ

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_setup_lba

EXTERN ide_write_byte, ide_write_byte_preset
EXTERN ide_read_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; read a sector
; LBA specified by the 4 bytes in BCDE
; the address of the buffer to fill is in HL
; HL is left incremented by 512 bytes
; uses AF, BC, DE, HL
; return carry on success

.ide_read_sector
    push de
    call ide_wait_ready         ;make sure drive is ready

    pop de
    call ide_setup_lba          ;tell it which sector we want in BCDE

    ld de,__IO_IDE_SEC_CNT<<8|1
    call ide_write_byte_preset  ;set sector count to 1

    ld de,__IO_IDE_COMMAND<<8|__IDE_CMD_READ
    call ide_write_byte_preset  ;ask the drive to read it

    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it's got the data
    call ide_read_block         ;grab the data into (HL++)

    scf                         ;carry = 1 on return = operation ok
    ret

