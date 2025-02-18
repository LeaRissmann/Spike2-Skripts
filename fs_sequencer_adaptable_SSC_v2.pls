SET    0.01, 1, 0    ; clock tick = 10 microseconds
VAR    V1; ;Rot variable 4 LEA
VAR    V2; ;
VAR    V3; ;
VAR    V4; ;
VAR    V5; ;
VAR    V6; ;
VAR    V7; ;

VAR    V10; ;USTime ;set var for US only
VAR    V11; ;ISOMED 1
VAR    V12; ;ISOMED 2
VAR    V13; ;DAC 3 (blocker)
VAR    V14; ;ISOMED 1 - XY
VAR    V15; ;ISOMED 2 - ISOMED 1
VAR    V16; ;ISOMED 2 - XY
VAR    V17; ;DAC 3 - XY
;I NEED ALL THEM BECAUSE I CAN'T DO CALCULATIONS IN THE LOOP AS WELL AS IT WILL TAKE ticks!

;DAC    0, 5    ;Power up the Goniometer
DAC    1, 0    ;IMUs/EMGs system --> this is a TTL, var2
DAC    2, 0    ;ultrasound --> this is a TTL with duty cycle of 100Hz, var1
DAC    3, 0    ;DAC 3 set to zero --> TTL for relay circuit, button switch <10us, var3
DIGOUT [....00..]    ;digital bits 2 and 3 control the isomed, initially one of them is set high to be able to simply invert them,
;!!!!! A WARNING should be send to the user before running the sequencer / the script that is calling it !!!!!
HALT



;MOVE ISOMED
ISOMED: 'I  DIGOUT [....ii..] ;move Isomed
            HALT

;DAC3   ON
RELAYON: 'Q  DAC 3, 5 ;Set DAC3 HIGH
             BEQ V7, 1, RELAYON
             HALT

;DAC3   OFF
RELAYOFF: 'W    DAC 3, 0 ;Set DAC3 LOW
                BEQ V7, 0, RELAYOFF
                HALT

;DEFINITIONS FOR TESTING PURPOSES APART FROM THE STUDY PROTOCOL
;INFINITE ULTRASOUND DUTYCYCLE
INFUS: 'U  DAC 2, 4 ;INFINITE US
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           BEQ V1, 1, INFUS    ;V1 is manually updated via a button click in the toolbar
           HALT


;DEFINITIONS FOR n SECOND USE OF SINGLE OR COMBINATION OF MEASUREMENT EQUIPMENT

;MOVE ONLY ISOMED AFTER 4 seconds
OISOMED: 'o DELAY V11 ;move only Isomed after time defined in the script
            DIGOUT [....ii..]
            HALT
NONE: 'n HALT

;ONLY ULTRASOUND AS XY WIDTH
;only TTL DAC2 WITH DUTY CYCLE @ 100Hz FOR THE US
ULTRAREP: 'u  DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DBNZ V10, ULTRAREP ;V10 IS DEFINED IN THE SCRIPT
           HALT

;US (DAC2) 100Hz FOR XY WIDTH AND MOVE ISOMED @ V11
ULTRAISO: 'm DAC 2, 4  ;duty cycle for US (DAC2) @100Hz and move isomed
ULTRAMOV:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V11, ULTRAMOV

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1

            DIGOUT [....ii..]

ULTRAMO2:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V14, ULTRAMO2
            HALT


;US (DAC2) DUTYCYCLE 100Hz, MYON (DAC1) TTL for the entire XY WIDTH & RELEASE DAC3 @ x
USMYION: 'H DAC 1, 4  ; TTL from DAC1 and duty cycle @ 100Hz DAC2 for US
USM:       DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DBNZ V13, USM

           DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DAC 3, 0   ;TTL DAC 3 LOW SO TRIGGER THE BOX FOR THE BLOCKER

USMO2:      DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V17, USMO2

          DAC 1, 0 ; DAC1 LOW
          HALT


;US (DAC2) 100Hz and TTL MYON (DAC1) FOR XY WIDTH AND MOVE ISOMED @sec V11
MYOUSIMO: 'J  DAC 1, 4  ;TTL from DAC1 and THEN duty cycle 100Hz DAC2 for US
ULTRAMU:    DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V11, ULTRAMU ;REP CYCLE TILL FIRST TRIGGER OF ISOMED

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DIGOUT [....ii..]

ULTRAMU2:   DAC 2, 4

            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V14, ULTRAMU2 ;Loop till end of XY width'
            DAC 1, 0    ;report DAC 1 to zero
            HALT


; US (DAC2) 100Hz FOR XY WIDTH AND MOVE ISOMED TWICE
USISSC: 'S DAC 2, 4  ;duty cycle 100Hz DAC2 for US
ULTRAUS:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V11, ULTRAUS ;REP CYCLE TILL FIRST TRIGGER OF ISOMED

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DIGOUT [....ii..]

ULTRAUSS:  DAC 2, 4
          DELAY s(1/200)-4
          DAC 2, 0
          DELAY s(1/200)-1
          DBNZ V15, ULTRAUSS ;Repeat till V12 second time trigger ISOMED

          DAC 2, 4
          DELAY s(1/200)-4
          DAC 2, 0
          DELAY s(1/200)-1
          DIGOUT [....ii..]

ULTRAUSC:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V16, ULTRAUSC ;Repeat till end of XY width
            HALT

;US (DAC2) 100Hz and TTL MYON (DAC1) FOR XY WIDTH AND MOVE ISOMED TWICE
MYUSISOS: 'k  DAC 1, 4  ;TTL from DAC1 and THEN duty cycle 100Hz DAC2 for US
ULTRAMUS:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V11, ULTRAMUS ;REP CYCLE TILL FIRST TRIGGER OF ISOMED

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DIGOUT [....ii..]

ULTRAMD:  DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V15, ULTRAMD ;Repeat till V12 second time trigger ISOMED

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DIGOUT [....ii..]

ULTRAMH:    DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V16, ULTRAMH ;Repeat till end of XY width
            DAC 1, 0    ;report dac 1 to zero
            HALT


;Multiple rotation isomed



MULTISO: 'P DAC 1, 4 ;TTL from DAC1 for HDEMG or whatever
            DELAY V1 ;v20 = 1st rot
            DIGOUT [....ii..]
            
            DELAY V2 ;v20 = 1st rot
            DIGOUT [....ii..]
            
            DELAY V3 ;v20 = 1st rot
            DIGOUT [....ii..]
            
            DELAY V4 ;v20 = 1st rot
            DIGOUT [....ii..]
            
            DELAY V5 ;v20 = 1st rot
            DIGOUT [....ii..]

            DELAY V6 ;v20 = 1st rot
            DIGOUT [....ii..]

            DELAY V7 ;vx = xy view - last var
            DAC 1, 0 ;DAC1 to 0 at the end of XY
            HALT

SSC1:   'a  DAC 1, 4                ;SSC with 1x rep
            DELAY  s(4)            
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation shortening;
            DELAY  s(11)          ;wait 7.5 seconds for end of command
            DIGOUT [00000000]
            DAC 1, 0
            HALT


SSC3:   'c  DAC 1, 4                ;SSC with 3x rep
            DELAY  s(4)            
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation shortening;
            DELAY  s(1.2)
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]
            DELAY  s(1.2)  
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation shortening;
            DELAY  s(5.5)          ;wait 5.5 seconds for end of command
            DIGOUT [00000000]
            DAC 1, 0
            HALT

SSCH:   'd  DAC 1, 4                ;SSC with first and third SSC 
            DELAY  s(4)            
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation shortening;
            DELAY  s(3.6)
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation shortening;
            DELAY  s(5.5)          ;wait 5.5 seconds for end of command
            DIGOUT [00000000]
            DAC 1, 0
            HALT



SHO1:   'h  DAC 1, 4                ;SHO with 1x rep
            DELAY  s(5.2)            
            DIGOUT [....1000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(11)          ;wait 5.5 seconds for end of command
            DIGOUT [00000000]
            DAC 1, 0
            HALT



SHO3:   'j  DAC 1, 4                ;SHO with 3x rep
            DELAY  s(10)            
            DIGOUT [....1000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(6)          ;wait 5.5 seconds for end of command
            DIGOUT [00000000]
            DAC 1, 0
            HALT

ISODP:  'x  DAC 1, 4                 ;ISO at any angle
            DELAY  s(17.5)            
            DAC 1, 0
            HALT

SSC13:  'f  DAC 1, 4                ;SSC with 1x at time point of third SSC
            DELAY  s(8.81)            
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation stretch; 
            DELAY  s(1.2)
            DIGOUT [00001000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarrotation shortening;
            DELAY  s(5.5)          ;wait 7.5 seconds for end of command
            DIGOUT [00000000]
            DAC 1, 0
            HALT