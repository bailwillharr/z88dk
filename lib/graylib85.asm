
; Graylib interrupt installer
; Ported and heavily modified by Stefano Bodrato - Mar 2000
;
; original code (graydraw.asm) by:
;
;------------------------------------------------------------
; Date:     Sun, 5 May 1996 12:44:17 -0400 (EDT)
; From:     Jingyang Xu  [br00416@bingsuns.cc.binghamton.edu]
; Subject:  LZ: Graydraw source!
;------------------------------------------------------------
;
; $Id: graylib85.asm,v 1.3 2001-05-11 07:58:59 stefano Exp $
;


	XDEF	graybit1
	XDEF	graybit2

defc	intcount = $8980

	ld hl,($8be5)   ;get end of VAT

        dec hl
        dec hl          ;make sure we're clear it..

           ; now we need to get the position of
           ; the nearest screen boundary

        ld a,h
        sub 4
        ld h,a
        ld l,0
        push hl

            ;Tests if there is a space for the 1K
            ;needed for the 2nd screen

        ld de,($8be1)
        or a
        sbc hl,de
        pop hl
        jr c,GrayError

           ;Save out the address of our 2nd Screen

        ld (graybit2),hl
        
	;push	hl
	;ld	de,p2save
	;ld	bc,1024
	;ldir
	;pop	hl

           ; test if our block of memory
           ; is within the range addressable
           ; by the LCD hardware

        and @11000000
        cp @11000000
        jr nz,GrayError

           ; It is, so save out the byte to send to port 0
           ; to switch to our 2nd screen

        ld a,h
        and @00111111
        ld (page2),a

        ; Set the IV for IM2 mode

	dec h
	ld a,h
        ld i,a
        
	; Set the IV table
        
        ld      (hl),Int_Rout&$FF
        inc     hl
        ld      (hl),Int_Rout/256
        ld	d,h
        ld	e,l
	dec	hl
        inc	de
        ld	bc,255
        ldir

	; Init counter

        xor	a
        ld	(intcount),a

	; Activate Interrupt

        im 2
        
        jp cont_jp

.GrayError
        ;scf            ;set carry flag - Error occured
        ret

.Int_Rout
	push	af
        in a,(3)
        bit 1,a           ; check that it is a vbl interrupt
        jr z,EndInt

        ld a,(intcount)
        cp 2
        jr z,Disp_2

.Disp_1
        inc a
        ld (intcount),a
        ld a,(page2)
        out (0),a
        jr EndInt
.Disp_2
        ld a,$3c
        out (0),a
        sub a
        ld (intcount),a
.EndInt
        pop	af
        ei
        reti
        ;jp      $38

.Int_RoutEnd

.graybit1 defw $fc00	;GRAPH_MEM
.graybit2 defw 0
.page2    defb 0


.cont_jp

;	ld hl,(graybit2)
;	ld d,h
;	ld e,l
;	inc de
;	ld (hl),0
;	ld bc,1023
;	ldir
