.include "m328pdef.inc"

.def carga = r16
.def segundos = r17
.def repeticiones = r18
.def ciclos_secado = r19
.def temp = r20
.def delay1 = r21
.def delay2 = r22
.def delay3 = r23
.def leds_carga = r24
.def motor_guardado = r25

.equ LIGERA = 0
.equ MEDIA = 1
.equ PESADA = 2

.cseg
.org 0x0000
    rjmp RESET

RESET:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    clr temp
    out DDRC, temp
    ldi temp, (1<<PC0)|(1<<PC1)|(1<<PC2)|(1<<PC3)
    out PORTC, temp

    ldi temp, 0xFF
    out DDRD, temp
    clr temp
    out PORTD, temp

    ldi temp, (1<<PB0)|(1<<PB1)
    out DDRB, temp
    clr temp
    out PORTB, temp

    clr carga
    rcall ACTUALIZAR_CARGA

BUCLE_LISTO:
    rcall MOSTRAR_LISTO
    sbis PINC, PC1
    rcall SELECCIONAR_CARGA
    sbis PINC, PC0
    rcall VALIDAR_INICIO
    rjmp BUCLE_LISTO

VALIDAR_INICIO:
    rcall RETARDO_ANTIRREBOTE
    sbic PINC, PC0
    ret

ESPERAR_LIBERAR_INICIO:
    sbis PINC, PC0
    rjmp ESPERAR_LIBERAR_INICIO
    rcall RETARDO_ANTIRREBOTE
    sbic PINC, PC2
    ret
    sbic PINC, PC3
    ret
    rcall PROCESO_LAVADO
    ret

SELECCIONAR_CARGA:
    rcall RETARDO_ANTIRREBOTE
    sbic PINC, PC1
    ret
    inc carga
    cpi carga, 3
    brlo ACTUALIZAR_SELECCION
    clr carga

ACTUALIZAR_SELECCION:
    rcall ACTUALIZAR_CARGA
    rcall MOSTRAR_LISTO

ESPERAR_LIBERAR_SELECCION:
    sbis PINC, PC1
    rjmp ESPERAR_LIBERAR_SELECCION
    rcall RETARDO_ANTIRREBOTE
    ret

ACTUALIZAR_CARGA:
    ldi leds_carga, (1<<PD5)
    cpi carga, MEDIA
    breq MOSTRAR_CARGA_MEDIA
    cpi carga, PESADA
    breq MOSTRAR_CARGA_PESADA
    ret

MOSTRAR_CARGA_MEDIA:
    ldi leds_carga, (1<<PD6)
    ret

MOSTRAR_CARGA_PESADA:
    ldi leds_carga, (1<<PD7)
    ret

MOSTRAR_LISTO:
    mov temp, leds_carga
    ori temp, (1<<PD0)
    out PORTD, temp
    ret

MOSTRAR_LAVADO:
    mov temp, leds_carga
    ori temp, (1<<PD1)
    out PORTD, temp
    ret

PROCESO_LAVADO:
    rcall MOSTRAR_LAVADO
    ldi repeticiones, 5

BUCLE_LAVADO:
    rcall MOTOR_DERECHA
    ldi segundos, 2
    add segundos, carga
    rcall RETARDO_SEGUNDOS_SEGURO
    rcall MOTOR_DETENER
    ldi segundos, 1
    add segundos, carga
    rcall RETARDO_SEGUNDOS_SEGURO
    dec repeticiones
    brne BUCLE_LAVADO
    ret

MOTOR_DERECHA:
    ldi temp, (1<<PB0)
    out PORTB, temp
    ret

MOTOR_DETENER:
    clr temp
    out PORTB, temp
    ret

RETARDO_SEGUNDOS_SEGURO:
    tst segundos
    breq FIN_RETARDO_SEGUNDOS

BUCLE_RETARDO_SEGUNDOS:
    sbic PINC, PC2
    rjmp PUERTA_ABIERTA
    rcall RETARDO_UN_SEGUNDO
    dec segundos
    brne BUCLE_RETARDO_SEGUNDOS

FIN_RETARDO_SEGUNDOS:
    ret

PUERTA_ABIERTA:
    in motor_guardado, PORTB
    rcall MOTOR_DETENER

ESPERAR_PUERTA_CERRADA:
    sbic PINC, PC2
    rjmp ESPERAR_PUERTA_CERRADA
    out PORTB, motor_guardado
    rjmp BUCLE_RETARDO_SEGUNDOS

RETARDO_UN_SEGUNDO:
    ldi delay1, 82

RETARDO_UN_SEGUNDO_1:
    ldi delay2, 255

RETARDO_UN_SEGUNDO_2:
    ldi delay3, 255

RETARDO_UN_SEGUNDO_3:
    dec delay3
    brne RETARDO_UN_SEGUNDO_3
    dec delay2
    brne RETARDO_UN_SEGUNDO_2
    dec delay1
    brne RETARDO_UN_SEGUNDO_1
    ret

RETARDO_ANTIRREBOTE:
    ldi delay1, 2

RETARDO_ANTIRREBOTE_1:
    ldi delay2, 255

RETARDO_ANTIRREBOTE_2:
    ldi delay3, 255

RETARDO_ANTIRREBOTE_3:
    dec delay3
    brne RETARDO_ANTIRREBOTE_3
    dec delay2
    brne RETARDO_ANTIRREBOTE_2
    dec delay1
    brne RETARDO_ANTIRREBOTE_1
    ret
