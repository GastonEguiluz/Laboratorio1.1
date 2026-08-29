.include "m328pdef.inc"

.def temp = r16
.def secuencia = r17
.def patron = r18
.def retardo1 = r19
.def retardo2 = r20
.def retardo3 = r21

.cseg
.org 0x0000
    rjmp RESET

RESET:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRD, temp
    clr temp
    out PORTD, temp

    clr temp
    out DDRB, temp
    ldi temp, (1<<PB0)|(1<<PB1)|(1<<PB2)
    out PORTB, temp

    clr secuencia
    clr patron

PRINCIPAL:
    rcall LEER_BOTONES
    rcall EJECUTAR_SECUENCIA
    rjmp PRINCIPAL
EJECUTAR_SECUENCIA:
    ret

RETARDO_PASO:
    ret

LEER_BOTONES:
    ret
