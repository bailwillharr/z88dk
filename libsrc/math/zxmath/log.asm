;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


;double log(double)     - natural log
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    log

                LIB	fsetup1
                LIB	stkequ

.log
        call    fsetup1
	defb	ZXFP_LN
	defb	ZXFP_END_CALC
        jp      stkequ
