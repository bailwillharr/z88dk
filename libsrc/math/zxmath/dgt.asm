;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dgt.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    dgt

                LIB	fsetup
                LIB	f_yesno

.dgt
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_GREATER_0
	defb	ZXFP_END_CALC
	
	jp	f_yesno