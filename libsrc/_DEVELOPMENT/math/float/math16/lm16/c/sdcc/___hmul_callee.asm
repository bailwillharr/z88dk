
    SECTION code_fp_math16

    PUBLIC ___hmul_callee
    PUBLIC _m16_mul_callee

    EXTERN cm16_sdcc_mul_callee

    defc ___hmul_callee = cm16_sdcc_mul_callee
    defc _m16_mul_callee = cm16_sdcc_mul_callee
