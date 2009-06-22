;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: int_inv_sgn.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfp.def"

		XLIB		int_inv_sgn


.int_inv_sgn
		xor     a
		sub     l
		ld      l,a
		sbc     a,h
		sub     l
		cp      h
		ld      h,a
		scf
		ret     nz
		cp      1
		ret

		
