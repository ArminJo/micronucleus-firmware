/* Name: usbdrvasm.S
 * Project: V-USB, virtual USB port for Atmel's(r) AVR(r) microcontrollers
 * Author: Christian Starkjohann
 * Creation Date: 2007-06-13
 * Tabsize: 4
 * Copyright: (c) 2007 by OBJECTIVE DEVELOPMENT Software GmbH
 * License: GNU GPL v2 (see License.txt), GNU GPL v3 or proprietary (CommercialLicense.txt)
 */

/*
General Description:
This module is the assembler part of the USB driver. This file contains
general code (preprocessor acrobatics and CRC computation) and then includes
the file appropriate for the given clock rate.
*/

#define __SFR_OFFSET 0      /* used by avr-libc's register definitions */
#include "usbportability.h"
#include "usbdrv.h"         /* for common defs */

/* register names */
#define x1      r16
#define x2      r17
#define shift   r18
#define cnt     r19
#define x3      r20
#define x4      r21
#define x5		r22
#define bitcnt  x5
#define phase   x4
#define leap    x4

/* Some assembler dependent definitions and declarations: */

#ifdef __IAR_SYSTEMS_ASM__
    extern  usbRxBuf, usbDeviceAddr, usbNewDeviceAddr, usbInputBufOffset
    extern  usbCurrentTok, usbRxLen, usbRxToken, usbTxLen
    extern  usbTxBuf, usbTxStatus1, usbTxStatus3
    public  usbCrc16Append

    COMMON  INTVEC
    ORG     USB_handler
    rjmp    USB_handler
    RSEG    CODE

#else /* __IAR_SYSTEMS_ASM__ */

    .text
    .global USB_handler
    .type   USB_handler, @function
    .global usbCrc16Append
#endif /* __IAR_SYSTEMS_ASM__ */


#if USB_INTR_PENDING < 0x40 /* This is an I/O address, use in and out */
#   define  USB_LOAD_PENDING(reg)   in reg, USB_INTR_PENDING
#   define  USB_STORE_PENDING(reg)  out USB_INTR_PENDING, reg
#else   /* It's a memory address, use lds and sts */
#   define  USB_LOAD_PENDING(reg)   lds reg, USB_INTR_PENDING
#   define  USB_STORE_PENDING(reg)  sts USB_INTR_PENDING, reg
#endif

#define usbTxLen1   usbTxStatus1
#define usbTxBuf1   (usbTxStatus1 + 1)
#define usbTxLen3   usbTxStatus3
#define usbTxBuf3   (usbTxStatus3 + 1)


;----------------------------------------------------------------------------
; Utility functions
;----------------------------------------------------------------------------

#ifdef __IAR_SYSTEMS_ASM__
/* Register assignments for usbCrc16 on IAR cc */
/* Calling conventions on IAR:
 * First parameter passed in r16/r17, second in r18/r19 and so on.
 * Callee must preserve r4-r15, r24-r29 (r28/r29 is frame pointer)
 * Result is passed in r16/r17
 * In case of the "tiny" memory model, pointers are only 8 bit with no
 * padding. We therefore pass argument 1 as "16 bit unsigned".
 */
RTMODEL "__rt_version", "3"
/* The line above will generate an error if cc calling conventions change.
 * The value "3" above is valid for IAR 4.10B/W32
 */
#   define argLen   r18 /* argument 2 */
#   define argPtrL  r16 /* argument 1 */
#   define argPtrH  r17 /* argument 1 */

#   define resCrcL  r16 /* result */
#   define resCrcH  r17 /* result */

#   define ptrL     ZL
#   define ptrH     ZH
#   define ptr      Z
#   define byte     r22
#   define bitCnt   r19
#   define polyL    r20
#   define polyH    r21
#   define scratch  r23

#else  /* __IAR_SYSTEMS_ASM__ */
/* Register assignments for usbCrc16 on gcc */
/* Calling conventions on gcc:
 * First parameter passed in r24/r25, second in r22/23 and so on.
 * Callee must preserve r1-r17, r28/r29
 * Result is passed in r24/r25
 */
#   define argLen   r22 /* argument 2 */
#   define argPtrL  r24 /* argument 1 */
#   define argPtrH  r25 /* argument 1 */

#   define resCrcL  r24 /* result */
#   define resCrcH  r25 /* result */

#   define ptrL     XL
#   define ptrH     XH
#   define ptr      x
#   define byte     r18
#   define bitCnt   r19
#   define polyL    r20
#   define polyH    r21
#   define scratch  r23

#endif


#if USB_USE_FAST_CRC

; This implementation is faster, but has bigger code size
; This version has been optimized in size compared to the original
; fast CRC by Shay Green, January 2014.

; Thanks to Slawomir Fras (BoskiDialer) for the original contribution.
; It implements the following C pseudo-code:
; unsigned table(unsigned char x)
; {
; unsigned    value;
;
;     value = (unsigned)x << 6;
;     value ^= (unsigned)x << 7;
;     if(parity(x))
;         value ^= 0xc001;
;     return value;
; }
; unsigned usbCrc16(unsigned char *argPtr, unsigned char argLen)
; {
; unsigned crc = 0xffff;
;
;     while(argLen--)
;         crc = table(lo8(crc) ^ *argPtr++) ^ hi8(crc);
;     return ~crc;
; }

; extern unsigned usbCrc16(unsigned char *argPtr, unsigned char argLen);
;   argPtr  r24+25 / r16+r17
;   argLen  r22 / r18
; temp variables:
;   byte    r18 / r22
;   scratch r23
;   resCrc  r24+r25 / r16+r17
;   ptr     X / Z

usbCrc16Append:
    movw    ptrL, argPtrL
    ldi     resCrcL, 0xFF
    ldi     resCrcH, 0xFF
    clr     bitCnt          ; zero
    rjmp    usbCrc16LoopTest
usbCrc16ByteLoop:
    ld      byte, ptr+
    eor     byte, resCrcL   ; scratch is now 'x' in table()
    mov     scratch, byte   ; compute parity of 'x'
    swap    byte
    eor     byte, scratch
    mov     resCrcL, byte
    lsr     byte
    lsr     byte
    eor     byte, resCrcL
    inc     byte
    andi    byte, 2        ; byte is now parity(x) << 1
    cp      bitCnt, byte   ; c = (byte != 0), then put in high bit
    ror     scratch        ; so that after xoring, shifting, and xoring, it gives
    ror     byte           ; the desired 0xC0 with resCrcH
    mov     resCrcL, byte
    eor     resCrcL, resCrcH
    mov     resCrcH, scratch
    lsr     scratch
    ror     byte
    eor     resCrcH, scratch
    eor     resCrcL, byte
usbCrc16LoopTest:
    subi    argLen, 1
    brsh    usbCrc16ByteLoop
    com     resCrcL
    com     resCrcH
    st      ptr+, resCrcL
    st      ptr+, resCrcH
    ret

#else   // USB_USE_FAST_CRC

; This implementation is slower, but has less code size
;
; extern unsigned usbCrc16(unsigned char *argPtr, unsigned char argLen);
;   argPtr  r24+25 / r16+r17
;   argLen  r22 / r18
; temp variables:
;   byte    r18 / r22
;   bitCnt  r19
;   poly    r20+r21
;   scratch r23
;   resCrc  r24+r25 / r16+r17
;   ptr     X / Z
usbCrc16Append:
    movw    ptrL, argPtrL
#    mov     ptrL, argPtrL
#    mov     ptrH, argPtrH
    ldi     resCrcL, 0
    ldi     resCrcH, 0
    ldi     polyL, lo8(0xa001)
    ldi     polyH, hi8(0xa001)
    com     argLen      ; argLen = -argLen - 1: modified loop to ensure that carry is set
    ldi     bitCnt, 0   ; loop counter with starnd condition = end condition
    rjmp    usbCrcLoopEntry
usbCrcByteLoop:
    ld      byte, ptr+
    eor     resCrcL, byte
usbCrcBitLoop:
    ror     resCrcH     ; carry is always set here (see brcs jumps to here)
    ror     resCrcL
    brcs    usbCrcNoXor
    eor     resCrcL, polyL
    eor     resCrcH, polyH
usbCrcNoXor:
    subi    bitCnt, 224 ; (8 * 224) % 256 = 0; this loop iterates 8 times
    brcs    usbCrcBitLoop
usbCrcLoopEntry:
    subi    argLen, -1
    brcs    usbCrcByteLoop
usbCrcReady:
    st      ptr+, resCrcL
    st      ptr+, resCrcH
    ret
; Thanks to Reimar Doeffinger for optimizing this CRC routine!

#endif // USB_USE_FAST_CRC

#undef argLen
#undef argPtrL
#undef argPtrH
#undef resCrcL
#undef resCrcH
#undef ptrL
#undef ptrH
#undef ptr
#undef byte
#undef bitCnt
#undef polyL
#undef polyH
#undef scratch


#if USB_CFG_HAVE_MEASURE_FRAME_LENGTH
#ifdef __IAR_SYSTEMS_ASM__
/* Register assignments for usbMeasureFrameLength on IAR cc */
/* Calling conventions on IAR:
 * First parameter passed in r16/r17, second in r18/r19 and so on.
 * Callee must preserve r4-r15, r24-r29 (r28/r29 is frame pointer)
 * Result is passed in r16/r17
 * In case of the "tiny" memory model, pointers are only 8 bit with no
 * padding. We therefore pass argument 1 as "16 bit unsigned".
 */
#   define resL     r16
#   define resH     r17
#   define cnt16L   r30
#   define cnt16H   r31
#   define cntH     r18

#else  /* __IAR_SYSTEMS_ASM__ */
/* Register assignments for usbMeasureFrameLength on gcc */
/* Calling conventions on gcc:
 * First parameter passed in r24/r25, second in r22/23 and so on.
 * Callee must preserve r1-r17, r28/r29
 * Result is passed in r24/r25
 */
#   define resL     r24
#   define resH     r25
#   define cnt16L   r24
#   define cnt16H   r25
#   define cntH     r26
#endif
#   define cnt16    cnt16L

; extern unsigned usbMeasurePacketLength(void);
; returns time between two idle strobes in multiples of 7 CPU clocks
.global usbMeasureFrameLength
usbMeasureFrameLength:
    ldi     cntH, 6         ; wait ~ 10 ms for D- == 0
    clr     cnt16L
    clr     cnt16H
usbMFTime16:
    dec     cntH
    breq    usbMFTimeout
usbMFWaitStrobe:            ; first wait for D- == 0 (idle strobe)
    sbiw    cnt16, 1        ;[0] [6]
    breq    usbMFTime16     ;[2]
    sbic    USBIN, USBMINUS ;[3]
    rjmp    usbMFWaitStrobe ;[4]
usbMFWaitIdle:              ; then wait until idle again
    sbis    USBIN, USBMINUS ;1 wait for D- == 1
    rjmp    usbMFWaitIdle   ;2
    ldi     cnt16L, 1       ;1 represents cycles so far
    clr     cnt16H          ;1
usbMFWaitLoop:
    in      cntH, USBIN     ;[0] [7]
    adiw    cnt16, 1        ;[1]
    breq    usbMFTimeout    ;[3]
    andi    cntH, USBMASK   ;[4]
    brne    usbMFWaitLoop   ;[5]
usbMFTimeout:
#if resL != cnt16L
    mov     resL, cnt16L
    mov     resH, cnt16H
#endif
    ret

#undef resL
#undef resH
#undef cnt16
#undef cnt16L
#undef cnt16H
#undef cntH

#endif  /* USB_CFG_HAVE_MEASURE_FRAME_LENGTH */

;----------------------------------------------------------------------------
; Now include the clock rate specific code
;----------------------------------------------------------------------------

#if !defined(USB_CFG_CLOCK_KHZ)
#   if defined(F_CPU)
#       define USB_CFG_CLOCK_KHZ (F_CPU/1000)
#   else
#       error "USB_CFG_CLOCK_KHZ not defined in usbconfig.h and no F_CPU set!"
#   endif
#endif

#if USB_CFG_CLOCK_KHZ == 12000
#    include "usbdrvasm12.inc"
#elif USB_CFG_CLOCK_KHZ == 12800
#    include "usbdrvasm128.inc"
#elif USB_CFG_CLOCK_KHZ == 15000
#    include "usbdrvasm15.inc"
#elif USB_CFG_CLOCK_KHZ == 16000
#    include "usbdrvasm16.inc"
#elif USB_CFG_CLOCK_KHZ == 16500
#    include "usbdrvasm165.inc"
#elif USB_CFG_CLOCK_KHZ == 20000
#    include "usbdrvasm20.inc"
#else
#    error "USB_CFG_CLOCK_KHZ is not one of the supported non-crc-rates!"
#endif
