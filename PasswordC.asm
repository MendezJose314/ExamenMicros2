#include "p16F887.inc"   ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
 	__CONFIG	_CONFIG1,	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_ON & _FCMEN_ON & _LVP_OFF 
 	__CONFIG	_CONFIG2,	_BOR40V & _WRT_OFF

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

MAIN_PROG CODE                      ; let linker place main program
i EQU 0x20
j EQU 0x21
k EQU 0x30
m EQU 0x31
q EQU 0x34
r EQU 0x35
s EQU 0x36
t EQU 0x37
u EQU 0x38
aux EQU 0x32
aux2 EQU 0x33
suma1 EQU 0x22
suma2 EQU 0x23
p1 EQU 0x40
p2 EQU 0x41
p3 EQU 0x42
p4 EQU 0x43
p5 EQU 0x44
p6 EQU 0x45
p7 EQU 0x46
p8 EQU 0x47
u1 EQU 0x48
u2 EQU 0x49
u3 EQU 0x4A
u4 EQU 0x4B
u5 EQU 0x4C
u6 EQU 0x4D
u7 EQU 0x4E
u8 EQU 0x4F
START

    BANKSEL PORTA ;3
    CLRF PORTA ;Init PORTA
    BANKSEL ANSEL ;
    CLRF ANSEL ;digital I/O
    CLRF ANSELH
    BANKSEL TRISA ;
    CLRF TRISA
    CLRF TRISB
    CLRF TRISC
    MOVLW b'00000111'
    MOVWF TRISD
    CLRF TRISE
    BCF STATUS,RP1
    BCF STATUS,RP0
    MOVLW b'00101000'
    MOVWF TRISA
    CLRF TRISB
    CLRF TRISC
    CLRF TRISE
    
INITLCD
    BCF PORTA,0		;reset
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C		;first line
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
         
    MOVLW 0x3C		;cursor mode
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    
STARTL
    MOVLW 0x40
    MOVWF FSR
    MOVLW 0x92
    MOVWF q
    MOVLW d'8'
    MOVWF t
    CALL NEWPASS
RUTINA
    MOVLW b'00010000'
    MOVWF PORTD
    CALL CHECAR1
    RLF PORTD
    CALL CHECAR4
    RLF PORTD
    CALL CHECAR7
    RLF PORTD
    CALL CHECAR0
    GOTO RUTINA
    
COMPROBAR
    MOVLW 0x48
    MOVWF FSR
    MOVLW 0x92
    MOVWF s
    MOVLW d'8'
    MOVWF u
    CALL PIDE
RUTINA2
    MOVLW b'00010000'
    MOVWF PORTD
    CALL CHECAR12
    RLF PORTD
    CALL CHECAR42
    RLF PORTD
    CALL CHECAR72
    RLF PORTD
    CALL CHECAR02
    GOTO RUTINA2

OCULTARPASS
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '*'
    MOVWF PORTB
    CALL exec

    INCF q
    DECFSZ t
    GOTO OCULTARPASS
    CALL segundo
    RETURN

RESET2
    BCF PORTA,0		;reset
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C		;first line
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
         
    MOVLW 0x3C		;cursor mode
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    GOTO COMPROBAR
    
RESETTEST ;Pequeña rutina de tiempo y ocultar
    MOVLW 0x92
    MOVWF q
    MOVLW d'8'
    MOVWF t
    CALL OCULTARPASS
    BCF PORTA,0		;reset
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C		;first line
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
         
    MOVLW 0x3C		;cursor mode
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    GOTO COMPROBAR
    
exec

    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    RETURN

time
    CLRF i
    MOVLW d'10'
    MOVWF j
ciclo    
    MOVLW d'80'
    MOVWF i
    DECFSZ i
    GOTO $-1
    DECFSZ j
    GOTO ciclo
    RETURN
    
segundo
nop
movlw d'15' ;establecer valor de la variable m
movwf m
mloopcorto:
;nop
decfsz m,f
goto mloopcorto

 movlw d'42' ;establecer valor de la variable i
movwf i
iloopcorto:
nop ;NOPs de relleno (ajuste de tiempo)
movlw d'50' ;establecer valor de la variable j
movwf j
jloopcorto:
;nop ;NOPs de relleno (ajuste de tiempo)
movlw d'30' ;establecer valor de la variable k
movwf k
kloopcorto:
nop
decfsz k,f
goto kloopcorto
decfsz j,f
goto jloopcorto
decfsz i,f
goto iloopcorto
return ;salir de la rutina de tiempo y regresar al
    
GRANTED
    CALL LIMPIA
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x85	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC4	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'G'
    MOVWF PORTB
    CALL exec
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'D'
    MOVWF PORTB
    CALL exec
    MOVLW '!'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xD4	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'W'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'L'
    MOVWF PORTB
    CALL exec
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    MOVLW 'M'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW '!'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x97	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '='
    MOVWF PORTB
    CALL exec
    MOVLW ')'
    MOVWF PORTB
    CALL exec
    GOTO RESET3
    ;RETURN

DENIED
    
    CALL LIMPIA
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x85	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC4	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '!'
    MOVWF PORTB
    CALL exec
    MOVLW 'D'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'D'
    MOVWF PORTB
    CALL exec
    MOVLW '!'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xD3	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    MOVLW 'Y'
    MOVWF PORTB
    CALL exec
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'G'
    MOVWF PORTB
    CALL exec
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    MOVLW '!'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x97	;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '='
    MOVWF PORTB
    CALL exec
    MOVLW '('
    MOVWF PORTB
    CALL exec
    GOTO RESET3
    ;RETURN
    
NEWPASS
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x84		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    MOVLW 'G'
    MOVWF PORTB
    CALL exec
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC2		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'W'
    MOVWF PORTB
    CALL exec
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    MOVLW 'P'
    MOVWF PORTB
    CALL exec
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'W'
    MOVWF PORTB
    CALL exec
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    MOVLW 'D'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x90		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW b'01111110'
    MOVWF PORTB
    CALL exec
    
    RETURN
    
CHECAR1
    BTFSS PORTD, 0
    GOTO CHECAR2
    GOTO IMPRIMIR1
    
CHECAR2
    BTFSS PORTD, 1
    GOTO CHECAR3
    GOTO IMPRIMIR2
 
CHECAR3
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR3

CHECAR4
    BTFSS PORTD, 0
    GOTO CHECAR5
    GOTO IMPRIMIR4

CHECAR5
    BTFSS PORTD, 1
    GOTO CHECAR6
    GOTO IMPRIMIR5
 
CHECAR6
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR6

CHECAR7
    BTFSS PORTD, 0
    GOTO CHECAR8
    GOTO IMPRIMIR7

CHECAR8
    BTFSS PORTD, 1
    GOTO CHECAR9
    GOTO IMPRIMIR8
 
CHECAR9
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR9

CHECAR0
    BTFSS PORTD, 1
    GOTO CHECARR
    GOTO IMPRIMIR0
    
 CHECARR
    BTFSS PORTD, 2
    RETURN
    GOTO INITLCD

IMPRIMIR1
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '1'
    MOVWF PORTB
    CALL exec
    
    INCF q
    
    MOVLW '1'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST
    
IMPRIMIR2
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '2'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '2'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST
IMPRIMIR3
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '3'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '3'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST
IMPRIMIR4
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '4'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '4'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST
    
IMPRIMIR5
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '5'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '5'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST

IMPRIMIR6
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '6'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '6'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST

IMPRIMIR7
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '7'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '7'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST

IMPRIMIR8
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '8'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '8'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST

IMPRIMIR9
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '9'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '9'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST

IMPRIMIR0
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW q		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '0'
    MOVWF PORTB
    CALL exec

    INCF q
    
    MOVLW '0'
    MOVWF INDF
    INCF FSR
    
    DECFSZ t
    GOTO RUTINA
    GOTO RESETTEST
    
PIDE
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x85		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC3		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'P'
    MOVWF PORTB
    CALL exec
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'S'
    MOVWF PORTB
    CALL exec
    MOVLW 'W'
    MOVWF PORTB
    CALL exec
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    MOVLW 'D'
    MOVWF PORTB
    CALL exec
    MOVLW ':'
    MOVWF PORTB
    CALL exec
    
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x90		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW b'01111110'
    MOVWF PORTB
    CALL exec
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    GOTO RUTINA2
    
CHECAR12
    BTFSS PORTD, 0
    GOTO CHECAR22
    GOTO IMPRIMIR12
    
CHECAR22
    BTFSS PORTD, 1
    GOTO CHECAR32
    GOTO IMPRIMIR22
 
CHECAR32
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR32

CHECAR42
    BTFSS PORTD, 0
    GOTO CHECAR52
    GOTO IMPRIMIR42

CHECAR52
    BTFSS PORTD, 1
    GOTO CHECAR62
    GOTO IMPRIMIR52
 
CHECAR62
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR62

CHECAR72
    BTFSS PORTD, 0
    GOTO CHECAR82
    GOTO IMPRIMIR72

CHECAR82
    BTFSS PORTD, 1
    GOTO CHECAR92
    GOTO IMPRIMIR82
 
CHECAR92
    BTFSS PORTD, 2
    RETURN
    GOTO IMPRIMIR92

CHECAR02
    BTFSS PORTD, 1
    GOTO CHECARR2
    GOTO IMPRIMIR02
    
 CHECARR2
    BTFSS PORTD, 2
    RETURN
    GOTO RESET2
    
IMPRIMIR12
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '1'
    MOVWF PORTB
    CALL exec
    
    CALL OCULTO
    INCF s
    
    MOVLW '1'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR
    
IMPRIMIR22
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '2'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '2'
    MOVWF INDF
    
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR
    
IMPRIMIR32
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '3'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '3'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR
IMPRIMIR42
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '4'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '4'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR
    
IMPRIMIR52
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '5'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '5'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR

IMPRIMIR62
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '6'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '6'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR

IMPRIMIR72
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '7'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '7'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR

IMPRIMIR82
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '8'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '8'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR
    

IMPRIMIR92
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '9'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '9'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR

IMPRIMIR02
    CALL segundo
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '0'
    MOVWF PORTB
    CALL exec

    CALL OCULTO
    INCF s
    
    MOVLW '0'
    MOVWF INDF
    INCF FSR
    
    DECFSZ u
    GOTO RUTINA2
    GOTO VALIDAR
    
VALIDAR
    MOVFW p1
    XORWF u1
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p2
    XORWF u2
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p3
    XORWF u3
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p4
    XORWF u4
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p5
    XORWF u5
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p6
    XORWF u6
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p7
    XORWF u7
    BTFSS STATUS,Z
    GOTO DENIED
    MOVFW p8
    XORWF u8
    BTFSS STATUS,Z
    GOTO DENIED
    GOTO GRANTED
OCULTO
    CALL ESPERA
    BCF PORTA,0		;command mode
    CALL time
    
    MOVFW s		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW '*'
    MOVWF PORTB
    CALL exec
    RETURN
    
ESPERA
    nop
    movlw d'15' ;establecer valor de la variable m
    movwf m
    mloopcortoe:
    ;nop
    decfsz m,f
    goto mloopcortoe

    movlw d'42' ;establecer valor de la variable i
    movwf i
    iloopcortoe:
    nop ;NOPs de relleno (ajuste de tiempo)
    movlw d'50' ;establecer valor de la variable j
    movwf j
    jloopcortoe:
    ;nop ;NOPs de relleno (ajuste de tiempo)
    movlw d'50' ;establecer valor de la variable k
    movwf k
    kloopcortoe:
    nop
    decfsz k,f
    goto kloopcortoe
    decfsz j,f
    goto jloopcortoe
    decfsz i,f
    goto iloopcortoe
    return ;salir de la rutina de tiempo y regresar al
    
LIMPIA
    BCF PORTA,0		;reset
    MOVLW 0x01
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    
    MOVLW 0x0C		;first line
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
         
    MOVLW 0x3C		;cursor mode
    MOVWF PORTB
    
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    RETURN
    
RESET3
    MOVLW b'00010000'
    MOVWF PORTD
    RLF PORTD
    RLF PORTD
    RLF PORTD
    CALL CHECARINICIO
    goto RESET3
    
CHECARINICIO
    BTFSS PORTD, 0
    GOTO CHECARMEDIO
    GOTO INITLCD
 
CHECARMEDIO
    BTFSS PORTD, 2
    RETURN
    GOTO RESET2
 END