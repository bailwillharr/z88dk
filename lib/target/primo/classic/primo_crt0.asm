;
;	Startup for Primo A-XX models
;
;

	module primo_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code
        EXTERN    asm_im1_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        defc    TAR__clib_exit_stack_size = 4
        defc    TAR__register_sp = -1		; $c000
	defc	CRT_KEY_DEL = 8
	defc	__CPU_CLOCK = 2500000
        defc    CONSOLE_COLUMNS = 32
        defc    CONSOLE_ROWS = 24
        INCLUDE "crt/classic/crt_rules.inc"

        defc CRT_ORG_CODE = 0x4100

	org	  CRT_ORG_CODE

program:
	ld	(__sp),sp
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	hl,0
	add	hl,sp
	ld	(exitsp),hl
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	ld	hl,0
	push	hl	;argv
	push	hl	;argc
	call	_main
cleanup:
	ld	sp,(__sp)
	ret

l_dcal: jp      (hl)            ;Used for function pointer calls

__sp:	defw	0



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"
