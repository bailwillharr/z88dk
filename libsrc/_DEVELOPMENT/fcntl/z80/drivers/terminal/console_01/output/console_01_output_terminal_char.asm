
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSOLE_01_OUTPUT_TERMINAL_CHAR
; library driver for output terminals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Windowed output terminal for fixed width fonts.
;
; A specific device driver can forward messages to this stub
; to gain windowed output terminal functionality.
;
; The driver services all messages detailed in
; console_01_output_terminal and can therefore be paired
; with a console_01_input_terminal without additional code.
;
; This driver stub generates some new messages which must
; be serviced from any specific driver that uses this stub:
;
; * OTERM_MSG_TTY
;
;   enter  :  c = char to output
;   exit   :  c = char to output (possibly modified)
;             carry set if tty emulation absorbs char
;   can use:  af, bc, de, hl
;
;   The driver should call the tty emulation module.
;
; * OTERM_MSG_PRINTC
;
;   enter  :  c = ascii code >= 32
;             b = foreground colour
;             l = absolute x coordinate
;             h = absolute y coordinate
;   can use:  af, bc, de, hl
;
;   Print the char to screen at given character coordinate.
;
; * OTERM_MSG_BELL
;
;   can use:  af, bc, de, hl
;
;   Sound the bell.
;
; * OTERM_MSG_SCROLL
;
;   can use:  af, bc, de, hl
;
;   Scroll the window upward one character row.
;
; * OTERM_MSG_SCROLL_PAUSE
;
;   can use:  af, bc, de, hl
;
;   The scroll count has reached zero so the driver should
;   pause the output somehow and then scroll the window
;   upward one character row.

SECTION seg_code_fcntl

PUBLIC console_01_output_terminal_char

EXTERN console_01_output_terminal
EXTERN console_01_output_char_oterm_msg_putc, console_01_output_char_stdio_msg_ictl
EXTERN console_01_output_char_iterm_msg_putc, console_01_output_char_iterm_msg_bs

EXTERN OTERM_MSG_PUTC, STDIO_MSG_ICTL, ITERM_MSG_PUTC, ITERM_MSG_BS, ITERM_MSG_READLINE
EXTERN ITERM_MSG_BS_PWD, ITERM_MSG_PRINT_CURSOR, ITERM_MSG_ERASE_CURSOR

console_01_output_terminal_char:

   ; messages generated by stdio

   cp OTERM_MSG_PUTC
   jp z, console_01_output_char_oterm_msg_putc
   
   cp STDIO_MSG_ICTL
   jp z, console_01_output_char_stdio_msg_ictl
   
   ; messages generated by input terminal
   
   cp ITERM_MSG_PUTC
   jp z, console_01_output_char_iterm_msg_putc
   
   jp c, console_01_output_terminal    ; forward to library
   
   cp ITERM_MSG_BS
   jp z, console_01_output_char_iterm_msg_bs
   
   cp ITERM_MSG_BS_PWD
   jp z, console_01_output_char_iterm_msg_bs
   
   cp ITERM_MSG_PRINT_CURSOR
   jp z, console_01_output_char_iterm_msg_putc
   
   cp ITERM_MSG_ERASE_CURSOR
   jp z, console_01_output_char_iterm_msg_bs
   
   cp ITERM_MSG_READLINE
   ret z                               ; don't need this information
   
   jp console_01_output_terminal       ; forward to library
