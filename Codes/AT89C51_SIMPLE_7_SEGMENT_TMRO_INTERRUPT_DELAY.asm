;====================================================================
; 8051 MCU INTYERFACING WITH 7 SEGMENT LED DISPLAY
; 
; Created     : Sun, Oct 30 2022
; Processor   : AT89S52 (With 11.0592MHz EXTERNAL Crystal Oscillator)
; Compiler    : MIDE-51 (WINASM)
; Simulator   : PROTEUS 8.9
; Hardware    : avrPRO (Ver.22.0) Development Board and  Tested OK
; Single Digit Common Cathode 7 Segment Display used (As IN Hardware)
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================
	PORT	EQU	P1

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================
      	ORG	00H		; Reset Vector Address
      	AJMP	START		; Jump TO Main Program

;====================================================================
	ORG 	0BH		; Timer0 Interrupt Vector Address
ISR:	CLR 	TR0		; Stop Timer0
	DJNZ 	R1,EXIT_INT	; Compare and jump if it reaches zero
	MOV	A,R0		; Value stores in A
	LCALL	DISP		; Calling Routine to show value in A
RELOAD:	MOV	R1,#14D		; Required to Adjust 1 Second Delay
	INC	R0		; Incrementing the Number to show
	CJNE	R0,#10D,EXIT_INT; Compare it reaches 10 count or not
RST_NO:	MOV	R0,#0H		; Reseting No. after reaching No. 9

EXIT_INT:			; Exiting for Interrupt Service 
	CLR	TF0		; Clearing TIMER0 Over Flow Flag
 	SETB 	TR0		; Start Timer0
	RETI

;====================================================================
; CODE SEGMENT
;====================================================================
	ORG	030H
START:
	MOV	PORT,#00H	; CLEARING 7 SEG DATA PORT
	MOV	R0,#0D
	MOV	R1,#14D		;Required tO Adjust AppROX. 1 Sec Del
INIT_TMR0:
      	MOV 	A,#0D
      	MOV 	TMOD,#01H
      	MOV 	TH0,#0D
      	MOV 	TL0,#0D
      	MOV 	IE,#82H
      	SETB 	TR0		; Start Timer0

LOOP1:	SJMP	LOOP1

;====================================================================
; DISP:  Subroutine to Display Decimal Numbers ( 0 to 9)
; Data Index is defined in A (Accumulator)
; Data Pattern Bytes are stored in  Program Memory as DB  
; Data Pointer Directive used to Access Addresses
;====================================================================
DISP: 	
	MOV 	DPTR,#SSD_CC	; Setting Data Bytes Start Address
	MOVC 	A,@a+DPTR	; Fixing Accurate Address Now
	MOV 	PORT,A		; Place Data Patterns on o/p Port.
	RET

;====================================================================
; Data Patterns Stored here (Common Cathode 7 Segment Display)
;====================================================================
	ORG  	300H
SSD_CC:	
	DB 	3FH,06H,05BH,04FH,066H,06DH, 07DH,07H,07FH,06FH
;====================================================================

	END			; end of program
;====================================================================
; ---------------------END of the Assembly Program-------------------
;====================================================================
