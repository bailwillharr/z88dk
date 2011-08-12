	XLIB	read_joypad1
	
;==============================================================
; int read_joypad1()
;==============================================================
; Reads the joystick 1
;==============================================================
.read_joypad1
	in	a, ($dc)	; Reads joystick 1
	cpl			; Inverts all bits
	ld	h, 0
	ld	l, a		; Puts the result in HL
	ret