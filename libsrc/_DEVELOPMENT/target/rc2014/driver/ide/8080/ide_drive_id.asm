
SECTION code_driver

PUBLIC ide_drive_id

EXTERN __IO_IDE_COMMAND

EXTERN __IO_IDE_HEAD

EXTERN __IDE_CMD_ID

EXTERN ide_wait_ready, ide_wait_drq

EXTERN ide_write_byte
EXTERN ide_read_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do the identify drive command, and return with the buffer 
; filled with info about the drive.
; uses AF, DE, HL
; the buffer to fill is in HL
; return carry on success

.ide_drive_id
    call ide_wait_ready

    ld de,__IO_IDE_HEAD<<8|11100000b
    call ide_write_byte         ;select the master device, LBA mode
    call ide_wait_ready

    ld de,__IO_IDE_COMMAND<<8|__IDE_CMD_ID
    call ide_write_byte         ;issue the command
    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it's got the data

    call ide_read_block         ;grab the data buffer in (HL++)
    scf                         ;carry = 1 on return = operation ok
    ret

