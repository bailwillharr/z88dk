
; half __div_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_div_callee

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_mul_f24
EXTERN asm_f24_inv

.cm16_sccz80_div_callee

    ; divide sccz80 half by sccz80 half
    ;
    ; enter : stack = sccz80_half left, sccz80_half right, ret
    ;
    ; exit  :    HL = sccz80_half(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop bc                      ; pop return address
    pop hl                      ; get right operand off of the stack
    push bc

    call asm_f24_f16            ; expand to dehl
    call asm_f24_inv
    exx                         ; 1/y   d'  = eeeeeeee e' = s-------

    pop bc                      ; pop return address
    pop hl                      ; get left operand off of the stack

    push bc                     ; return address on stack

    call asm_f24_f16            ; expand to dehl
                                ; x      d  = eeeeeeee e  = s-------
                                ;        hl = 1mmmmmmm mmmmmmmm

    call asm_f24_mul_f24
    jp asm_f16_f24              ; return HL = sccz80_half

