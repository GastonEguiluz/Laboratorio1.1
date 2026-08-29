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
    cpi secuencia, 0
    breq LLAMAR_SECUENCIA_1
    cpi secuencia, 1
    breq LLAMAR_SECUENCIA_2
    cpi secuencia, 2
    breq LLAMAR_SECUENCIA_3
    cpi secuencia, 3
    breq LLAMAR_SECUENCIA_4
    cpi secuencia, 4
    breq LLAMAR_SECUENCIA_5
    cpi secuencia, 5
    breq LLAMAR_SECUENCIA_6
    cpi secuencia, 6
    breq LLAMAR_SECUENCIA_7
    rcall SECUENCIA_8
    ret

LLAMAR_SECUENCIA_1:
    rcall SECUENCIA_1
    ret

LLAMAR_SECUENCIA_2:
    rcall SECUENCIA_2
    ret

LLAMAR_SECUENCIA_3:
    rcall SECUENCIA_3
    ret

LLAMAR_SECUENCIA_4:
    rcall SECUENCIA_4
    ret

LLAMAR_SECUENCIA_5:
    rcall SECUENCIA_5
    ret

LLAMAR_SECUENCIA_6:
    rcall SECUENCIA_6
    ret

LLAMAR_SECUENCIA_7:
    rcall SECUENCIA_7
    ret

SECUENCIA_1:
    cpi patron, 0
    brne MOSTRAR_SECUENCIA_1
    ldi patron, 0x01

MOSTRAR_SECUENCIA_1:
    out PORTD, patron
    rcall RETARDO_PASO
    lsl patron
    ret

SECUENCIA_2:
    cpi patron, 0
    brne MOSTRAR_SECUENCIA_2
    ldi patron, 0x80

MOSTRAR_SECUENCIA_2:
    out PORTD, patron
    rcall RETARDO_PASO
    lsr patron
    ret

SECUENCIA_3:
    cpi patron, 0
    brne MOSTRAR_SECUENCIA_3
    ldi patron, 0x81

MOSTRAR_SECUENCIA_3:
    out PORTD, patron
    rcall RETARDO_PASO
    cpi patron, 0x81
    breq PATRON_42
    cpi patron, 0x42
    breq PATRON_24
    cpi patron, 0x24
    breq PATRON_18
    clr patron
    ret

PATRON_42:
    ldi patron, 0x42
    ret

PATRON_24:
    ldi patron, 0x24
    ret

PATRON_18:
    ldi patron, 0x18
    ret

SECUENCIA_4:
    cpi patron, 0
    brne MOSTRAR_SECUENCIA_4
    ldi patron, 0x18

MOSTRAR_SECUENCIA_4:
    out PORTD, patron
    rcall RETARDO_PASO
    cpi patron, 0x18
    breq PATRON_24_EXTERIOR
    cpi patron, 0x24
    breq PATRON_42_EXTERIOR
    cpi patron, 0x42
    breq PATRON_81_EXTERIOR
    clr patron
    ret

PATRON_24_EXTERIOR:
    ldi patron, 0x24
    ret

PATRON_42_EXTERIOR:
    ldi patron, 0x42
    ret

PATRON_81_EXTERIOR:
    ldi patron, 0x81
    ret
SECUENCIA_5:
    ret

SECUENCIA_6:
    ret

SECUENCIA_7:
    ret

SECUENCIA_8:
    ret

RETARDO_PASO:
    ret

LEER_BOTONES:
    ret
