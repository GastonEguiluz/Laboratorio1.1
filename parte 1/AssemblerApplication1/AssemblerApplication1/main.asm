.include "m328pdef.inc"

.def carga      = r16
.def contador   = r17
.def temp       = r18
.def delay1     = r19
.def delay2     = r20
.def delay3     = r21

.equ LIGERA = 0
.equ MEDIA  = 1
.equ PESADA = 2

.cseg
.org 0x0000
    rjmp RESET