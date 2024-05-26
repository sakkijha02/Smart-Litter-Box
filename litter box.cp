#line 1 "D:/mikroelectron/smart litter box/litter box.c"

unsigned int angle;
unsigned char HL;
void msDelay (unsigned int mscnt);
void ATD_init(void);
unsigned int ATD_read(void);
int k;
int c1;
float v;

void interrupt(void){

 if(PIR1 & 0x04){
 if(HL){
 CCPR1H = angle >> 8;
 CCPR1L = angle;
 HL = 0;
 CCP1CON = 0x09;
 TMR1H = 0;
 TMR1L = 0;
 }
 else{
 CCPR1H = (40000 - angle) >> 8;
 CCPR1L = (40000 - angle);
 CCP1CON = 0x08;
 HL = 1;
 TMR1H = 0;
 TMR1L = 0;
 }

 PIR1 = PIR1&0xFB;
 }


 }

void main() {
 TRISC = 0x00;
 PORTC = 0x00;
 TRISB = 0xff;

 TRISD = 0x00;
 PORTD=0x00;
 ATD_init();
 TMR1H = 0;
 TMR1L = 0;

 HL = 1;
 CCP1CON = 0x08;

 T1CON = 0x01;

 INTCON = 0xC0;
 PIE1 = PIE1|0x04;
 angle = 900;
 msDelay(3000);
 angle = 900;

 while(1){
 k = ATD_read();
 v = ((k*5)/1023);
 if(v>=3){
 PORTD=0x01;
 }
 else{
 PORTD=0x00;
 }




 if(c1 == 0 && PORTB==0x00){
 msDelay(2000);c1=1;}

 if(c1==1 && PORTB==0x02){
 msDelay(60000);
 angle = 2500;
 msDelay(5000);
 angle = 900;
 c1=0;
 msDelay(100);
 }



 }

}


void ATD_init(void){
 ADCON0=0x41;
 ADCON1=0xCE;
 TRISA=0x01;
}
unsigned int ATD_read(void){
 ADCON0=ADCON0 | 0x04;
 while(ADCON0&0x04);
 return (ADRESH<<8)|ADRESL;
}

void msDelay(unsigned int mscnt) {
 unsigned int ms;
 unsigned int cnt;
 for (ms = 0; ms < mscnt; ms++) {
 for (cnt = 0; cnt < 155; cnt++);
 }
}
