include(__link__.m4)

#ifndef __ARCH_SCZ180_H__
#define __ARCH_SCZ180_H__

#include <arch.h>

// GLOBAL VARIABLES

// provide the location for stack pointers to be stored

extern uint16_t *bios_sp;       // bios SP here when other banks running
extern uint16_t *bank_sp;       // bank SP storage, in Page0 TCB 0x003B

// provide the location of the IO byte based on CP/M
// only bit 0 distinguished currently with TTY=0 CRT=1.

extern uint8_t bios_ioByte;     // intel I/O byte

// provide the simple mutex locks for hardware resources

extern uint8_t shadowLock;      //  mutex for alternate registers
extern uint8_t prt0Lock;        //  mutex for PRT0 
extern uint8_t prt1Lock;        //  mutex for PRT1
extern uint8_t dmac0Lock;       //  mutex for DMAC0
extern uint8_t dmac1Lock;       //  mutex for DMAC1
extern uint8_t csioLock;        //  mutex for CSI/O

extern uint8_t asci0RxLock;     //  mutex for Rx0
extern uint8_t asci0TxLock;     //  mutex for Tx0
extern uint8_t asci1RxLock;     //  mutex for Rx1
extern uint8_t asci1TxLock;     //  mutex for Tx1

extern uint8_t APULock;         //  mutex for APU

// provide the simple mutex locks for the BANK (for system usage)

extern uint8_t bankLockBase[];  // base address for 16 BANK locks

// provide the location of the bios stack canary
// this location holds 0xAA55 and if it does not
// it means that the bios stack has collided with code

extern uint16_t bios_stack_canary;      // two bytes of stack canary

// provide the location for important CP/M Page 0 bank addresses

extern uint8_t bank_cpm_iobyte;         // CP/M IOBYTE
extern uint8_t bank_cmp_default_drive;  // CP/M default drive
extern uint16_t *bank_cpm_bdos_addr;    // CPM/ BDOS entry address

// IO MAPPED REGISTERS

#ifdef __CLANG

extern uint16_t io_break;

extern uint16_t io_pio_port_a;
extern uint16_t io_pio_port_b;
extern uint16_t io_pio_port_b;
extern uint16_t io_pio_control;

extern uint16_t io_pio_ide_lsb;
extern uint16_t io_pio_ide_msb;
extern uint16_t io_pio_ide_ctl;
extern uint16_t io_pio_ide_config;

extern uint16_t io_apu_port_data;
extern uint16_t io_apu_port_control;
extern uint16_t io_apu_port_status;

#else

__sfr __banked __at __IO_BREAK io_break;

__sfr __banked __at __IO_PIO_PORT_A  io_pio_port_a;
__sfr __banked __at __IO_PIO_PORT_B  io_pio_port_b;
__sfr __banked __at __IO_PIO_PORT_C  io_pio_port_c;
__sfr __banked __at __IO_PIO_CONTROL io_pio_control;

__sfr __banked __at __IO_PIO_IDE_LSB    io_pio_ide_lsb;
__sfr __banked __at __IO_PIO_IDE_MSB    io_pio_ide_msb;
__sfr __banked __at __IO_PIO_IDE_CTL    io_pio_ide_ctl;
__sfr __banked __at __IO_PIO_IDE_CONFIG io_pio_ide_config;

__sfr __banked __at __IO_APU_DATA    io_apu_data;
__sfr __banked __at __IO_APU_CONTROL io_apu_control;
__sfr __banked __at __IO_APU_STATUS  io_apu_status;

#endif

// SYSTEM FUNCTIONS

// provide methods to get, try, and give the simple mutex locks

__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,lock_get,uint8_t * mutex)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',uint8_t,,lock_try,uint8_t * mutex)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,lock_give,uint8_t * mutex)

// provide bank relative address functions

__DPROTO(`b,c,d,e,h,iyh,iyl',`b,c,d,e,h,iyh,iyl',int8_t,,bank_get_rel,uint8_t bankAbs)
__DPROTO(`b,c,d,e,h,iyh,iyl',`b,c,d,e,h,iyh,iyl',uint8_t,,bank_get_abs,int8_t bankRel)

// provide memcpy_far function

__OPROTO(`iyh,iyl',`iyh,iyl',void,*,memcpy_far,void *str1, int8_t bank1, const void *str2, const int8_t bank2, size_t n)

// provide load_hex function

__DPROTO(`iyh,iyl',`iyh,iyl',void,,load_hex,uint8_t bankAbs)

// provide jp_far function

__OPROTO(`b,c,iyh,iyl',`b,c,iyh,iyl',void,,jp_far,void *str, int8_t bank)

// SYSTEM FUNCTION MACROS

// provide call_error, call_far, call_sys, & call_apu function macros


#ifdef __SCCZ80

#define call_error(code)                        \
    do{                                         \
        asm(                                    \
        "rst 8h     ; call_error(code)      \n" \
        "defb " #code "                     \n" \
            );                                  \
    }while(0)

#define call_far(addr, bank)                    \
    do{                                         \
        asm(                                    \
        "rst 10h    ; call_far(addr, bank)  \n" \
        "defw " #addr "                     \n" \
        "defb " #bank "                     \n" \
            );                                  \
    }while(0)

#define call_sys(addr)                          \
    do{                                         \
        asm(                                    \
        "rst 20h    ; call_sys(addr)        \n" \
        "defw " #addr "                     \n" \
            );                                  \
    }while(0)

#define call_apu(cmd)                           \
    do{                                         \
        asm(                                    \
        "rst 28h    ; call_apu(cmd)         \n" \
        "defb " #cmd  "                     \n" \
            );                                  \
    }while(0)

#endif

#ifdef __SDCC

#define call_error(code)                        \
    do{                                         \
        __asm                                   \
        rst 8h        ; call_error(code)        \
        defb code                               \
        __endasm;                               \
    }while(0)

#define call_far(addr, bank)                    \
    do{                                         \
        __asm                                   \
        rst 10h        ; call_far(addr, bank)   \
        defw addr                               \
        defb bank                               \
        __endasm;                               \
    }while(0)

#define call_sys(addr)                          \
    do{                                         \
        __asm                                   \
        rst 20h        ; call_sys(addr)         \
        defw addr                               \
        __endasm;                               \
    }while(0)

#define call_apu(cmd)                           \
    do{                                         \
        __asm                                   \
        rst 28h        ; call_apu(cmd)          \
        defb cmd                                \
        __endasm;                               \
    }while(0)

#endif

#endif
