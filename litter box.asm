
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;litter box.c,11 :: 		void interrupt(void){
;litter box.c,13 :: 		if(PIR1 & 0x04){
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt0
;litter box.c,14 :: 		if(HL){
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt1
;litter box.c,15 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;litter box.c,16 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;litter box.c,17 :: 		HL = 0;
	CLRF       _HL+0
;litter box.c,18 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;litter box.c,19 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;litter box.c,20 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;litter box.c,21 :: 		}
	GOTO       L_interrupt2
L_interrupt1:
;litter box.c,23 :: 		CCPR1H = (40000 - angle) >> 8;
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;litter box.c,24 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;litter box.c,25 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;litter box.c,26 :: 		HL = 1;
	MOVLW      1
	MOVWF      _HL+0
;litter box.c,27 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;litter box.c,28 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;litter box.c,29 :: 		}
L_interrupt2:
;litter box.c,31 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;litter box.c,32 :: 		}
L_interrupt0:
;litter box.c,35 :: 		}
L_end_interrupt:
L__interrupt24:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;litter box.c,37 :: 		void main() {
;litter box.c,38 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;litter box.c,39 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;litter box.c,40 :: 		TRISB = 0xff;
	MOVLW      255
	MOVWF      TRISB+0
;litter box.c,42 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;litter box.c,43 :: 		PORTD=0x00;
	CLRF       PORTD+0
;litter box.c,44 :: 		ATD_init();
	CALL       _ATD_init+0
;litter box.c,45 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;litter box.c,46 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;litter box.c,48 :: 		HL = 1;
	MOVLW      1
	MOVWF      _HL+0
;litter box.c,49 :: 		CCP1CON = 0x08;        // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;litter box.c,51 :: 		T1CON = 0x01;          // TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts == 65535)==> 32.767ms
	MOVLW      1
	MOVWF      T1CON+0
;litter box.c,53 :: 		INTCON = 0xC0;         // Enable GIE and peripheral interrupts
	MOVLW      192
	MOVWF      INTCON+0
;litter box.c,54 :: 		PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;litter box.c,55 :: 		angle = 900;
	MOVLW      132
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;litter box.c,56 :: 		msDelay(3000);
	MOVLW      184
	MOVWF      FARG_msDelay_mscnt+0
	MOVLW      11
	MOVWF      FARG_msDelay_mscnt+1
	CALL       _msDelay+0
;litter box.c,57 :: 		angle = 900;
	MOVLW      132
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;litter box.c,59 :: 		while(1){
L_main3:
;litter box.c,60 :: 		k = ATD_read();  // 0-1023
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _k+0
	MOVF       R0+1, 0
	MOVWF      _k+1
;litter box.c,61 :: 		v = ((k*5)/1023);
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _v+0
	MOVF       R0+1, 0
	MOVWF      _v+1
	MOVF       R0+2, 0
	MOVWF      _v+2
	MOVF       R0+3, 0
	MOVWF      _v+3
;litter box.c,62 :: 		if(v>=3){
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      64
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
;litter box.c,63 :: 		PORTD=0x01;
	MOVLW      1
	MOVWF      PORTD+0
;litter box.c,64 :: 		}
	GOTO       L_main6
L_main5:
;litter box.c,66 :: 		PORTD=0x00;
	CLRF       PORTD+0
;litter box.c,67 :: 		}
L_main6:
;litter box.c,72 :: 		if(c1 == 0 && PORTB==0x00){
	MOVLW      0
	XORWF      _c1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main26
	MOVLW      0
	XORWF      _c1+0, 0
L__main26:
	BTFSS      STATUS+0, 2
	GOTO       L_main9
	MOVF       PORTB+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main9
L__main22:
;litter box.c,73 :: 		msDelay(2000);c1=1;}
	MOVLW      208
	MOVWF      FARG_msDelay_mscnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_mscnt+1
	CALL       _msDelay+0
	MOVLW      1
	MOVWF      _c1+0
	MOVLW      0
	MOVWF      _c1+1
L_main9:
;litter box.c,75 :: 		if(c1==1 &&  PORTB==0x02){
	MOVLW      0
	XORWF      _c1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main27
	MOVLW      1
	XORWF      _c1+0, 0
L__main27:
	BTFSS      STATUS+0, 2
	GOTO       L_main12
	MOVF       PORTB+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main12
L__main21:
;litter box.c,76 :: 		msDelay(60000);
	MOVLW      96
	MOVWF      FARG_msDelay_mscnt+0
	MOVLW      234
	MOVWF      FARG_msDelay_mscnt+1
	CALL       _msDelay+0
;litter box.c,77 :: 		angle = 2500;
	MOVLW      196
	MOVWF      _angle+0
	MOVLW      9
	MOVWF      _angle+1
;litter box.c,78 :: 		msDelay(5000);
	MOVLW      136
	MOVWF      FARG_msDelay_mscnt+0
	MOVLW      19
	MOVWF      FARG_msDelay_mscnt+1
	CALL       _msDelay+0
;litter box.c,79 :: 		angle = 900;
	MOVLW      132
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;litter box.c,80 :: 		c1=0;
	CLRF       _c1+0
	CLRF       _c1+1
;litter box.c,81 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_mscnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_mscnt+1
	CALL       _msDelay+0
;litter box.c,82 :: 		}
L_main12:
;litter box.c,86 :: 		}
	GOTO       L_main3
;litter box.c,88 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ATD_init:

;litter box.c,91 :: 		void ATD_init(void){
;litter box.c,92 :: 		ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
	MOVLW      65
	MOVWF      ADCON0+0
;litter box.c,93 :: 		ADCON1=0xCE;           // RA0 Analog, others are Digital, Right Allignment,
	MOVLW      206
	MOVWF      ADCON1+0
;litter box.c,94 :: 		TRISA=0x01;
	MOVLW      1
	MOVWF      TRISA+0
;litter box.c,95 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;litter box.c,96 :: 		unsigned int ATD_read(void){
;litter box.c,97 :: 		ADCON0=ADCON0 | 0x04;  // GO
	BSF        ADCON0+0, 2
;litter box.c,98 :: 		while(ADCON0&0x04);    // wait until DONE
L_ATD_read13:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read14
	GOTO       L_ATD_read13
L_ATD_read14:
;litter box.c,99 :: 		return (ADRESH<<8)|ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;litter box.c,100 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_msDelay:

;litter box.c,102 :: 		void msDelay(unsigned int mscnt) {
;litter box.c,105 :: 		for (ms = 0; ms < mscnt; ms++) {
	CLRF       R1+0
	CLRF       R1+1
L_msDelay15:
	MOVF       FARG_msDelay_mscnt+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay31
	MOVF       FARG_msDelay_mscnt+0, 0
	SUBWF      R1+0, 0
L__msDelay31:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay16
;litter box.c,106 :: 		for (cnt = 0; cnt < 155; cnt++);//1ms
	CLRF       R3+0
	CLRF       R3+1
L_msDelay18:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay32
	MOVLW      155
	SUBWF      R3+0, 0
L__msDelay32:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay19
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_msDelay18
L_msDelay19:
;litter box.c,105 :: 		for (ms = 0; ms < mscnt; ms++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;litter box.c,107 :: 		}
	GOTO       L_msDelay15
L_msDelay16:
;litter box.c,108 :: 		}
L_end_msDelay:
	RETURN
; end of _msDelay
