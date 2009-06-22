;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double tan(double)
;Number in FA..

                INCLUDE  "fpp.def"

                XLIB    tan

                LIB	fsetup
                LIB	stkequ2

.tan
        call    fsetup
        fpp(FP_TAN)
        jp      stkequ2



