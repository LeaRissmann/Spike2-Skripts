;This sequencer file is for SSC Masterthesis Rissmann 2020
            SET    0.1,1,0         ;clock is set to 100 microseconds
;This code allows for EMG target to be met, followed by a shorten-hold. During hold, there are stims.
ZERO:   'z  DAC    0,0             ;Reset DAC 0 and 2 to 0V level
            DAC    1,0
            DIGOUT [00000000]      ;Turn off all digital outputs from the sequencer
            HALT                   ;Halt sequence and do not do anything until a keypress
;This code allows for EMG target to be met, followed by a stretch-hold. During hold, there are stims.
AWAY:   'A  DIGOUT [00000100]
            DELAY  ms(10) 
            DIGOUT [00000000]
            HALT   
TOWARD: 'T  DIGOUT [00001000]
            DELAY  ms(10) 
            DIGOUT [00000000]
            HALT   

;At whatever ankle angle, the EMG ramps are produced to guide EMG controlled iso contraction ISODF
READY:  'D  DAC    0,V15           ; isometric Send a signal out of DAC 0 at the voltage specified by V15 Starting value 1 (draws ramp 1)
            DAC    1,V16           ;Sends a signal our of DAC 2 at the voltage specified by V16 Starting value 2 (draws ramp2)
            DELAY  V25            ;give the user a number of seconds before ramp starts
            RAMP   0,V15,V4        ;Draws ramp1, as it increases to target value(amp/time=rate)
            RAMP   1,V16,V4        ;Draws ramp1, as it increases to target value(amp/time=rate)
WT1:        WAITC  0,WT1           ;wait for ramp to end before going on to next command
WT1a:       WAITC  1,WT1a          ;wait for ramp to end before going on to next command
            RAMP   0,V17,V4        ;Draws ramp1, as it increases to target value(amp/time=rate)
            RAMP   1,V18,V4        ;Draws ramp1, as it increases to target value(amp/time=rate)
WT2:        WAITC  0,WT2           ;wait for ramp to end before going on to next command
WT2a:       WAITC  1,WT2a          ;wait for ramp to end before going on to next command
            DELAY  V37             ;wait 5.913 seconds from the start of ramp to produce first stim
            DIGOUT [00000001]      ;Signal stim box from 1401 dat output 0 (first stim)
            DIGOUT [00000000]      ;Turn off signal
            DELAY  V38            ; Hold until 1s after last stim
            DAC    0,V15           ; immediately return value to resting values
            DAC    1,V16           ; immediately return value to resting values
            HALT                   ;end of this sequence

;This code allows for EMG target to be met, followed by a shortening-hold. During hold, there are stims SHO
OVER0:  'S  DAC    0,V15           ; shortening                         Send a signal out of DAC 0 at the voltage specified by V15 Starting value 1 (draws ramp 1)
            DAC    1,V16           ;Sends a signal our of DAC 2 at the voltage specified by V16 Starting value 2 (draws ramp2)
            DELAY  V25            ;give the user a number of seconds before ramp starts
            RAMP   0,V17,V4        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
            RAMP   1,V18,V4        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
WT3:        WAITC  0,WT3           ;wait for ramp to end before going on to next command
WT3a:       WAITC  1,WT3a          ;wait for ramp to end before going on to next command           
PULSE0:     DELAY  V39            ;One threshold is reached, wait 2.645 seconds before rotation
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarflexion rotation
            DELAY  ms(10) 
            DIGOUT [00000000]      ;Turn off signal 
            JUMP OVER1
;threshold crossing
OVER1: 'E   CHAN   V50,2            ;get the last data value for chan 2 (position signal)
            BLT    V50,0,PULSE1     ;compares data value to threshold value set by script in these condition statements
            JUMP   OVER1
PULSE1:     DIGOUT [00000001]      ;send stim
            DIGOUT [00000000]      ;stop stim
            RAMP   0,V19,1         ;Draws EMG ramp, as it increases to target value(amp/time=rate)
            RAMP   1,V20,1         ;Draws EMG ramp, as it increases to target value(amp/time=rate)
WT4:        WAITC  0,WT4           ;wait for ramp to end before going on to next command
WT4a:       WAITC  1,WT4a          ;wait for ramp to end before going on to next command  
            DELAY V40
            DIGOUT [00000001]      ;Signal stim box from 1401 dat output 0 (first stim)
            DIGOUT [00000000]      ;Turn off signal
            DELAY  V38             ; Hold until 1s after last stim
            DAC    0,V15           ; immediately return value to resting values
            DAC    1,V16           ; immediately return value to resting values  
            HALT

;This code allows for EMG target to be met, followed by a stretch-shortening-hold. During hold, there are stims SSC
OVER2:  'X  DAC    0,V15           ; shortening                         Send a signal out of DAC 0 at the voltage specified by V15 Starting value 1 (draws ramp 1)
            DAC    1,V16           ;Sends a signal our of DAC 2 at the voltage specified by V16 Starting value 2 (draws ramp2)
            DELAY  V25            ;give the user a number of seconds before ramp starts
            RAMP   0,V19,V12        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
            RAMP   1,V20,V12        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
WT8:        WAITC  0,WT8           ;wait for ramp to end before going on to next command
WT8a:       WAITC  1,WT8a          ;wait for ramp to end before going on to next command           
PULSE2:     DELAY  V41            ;One threshold is reached, wait 2.645 seconds before rotation
            DIGOUT [....1000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarflexion rotation
            DELAY  ms(10) 
            DIGOUT [00000000]      ;Turn off signal 
            DELAY  ms(632)
            DIGOUT [....0100]      ;send stim on DIG11, this goes to the dynamometer to produce plantarflexion rotation
            DELAY  ms(10) 
            DIGOUT [00000000]      ;Turn off signal 
            JUMP OVER3
;threshold crossing
OVER3: 'F   CHAN   V50,2            ;get the last data value for chan 2 (position signal)
            BLT    V50,0,PULSE3     ;compares data value to threshold value set by script in these condition statements
            JUMP   OVER3
PULSE3:     DIGOUT [00000001]      ;send stim
            DIGOUT [00000000]      ;stop stim 
            DELAY  V40
            DELAY  3
            DIGOUT [00000001]      ;Signal stim box from 1401 dat output 0 (first stim)
            DIGOUT [00000000]      ;Turn off signal
            DELAY  V38             ; Hold until 1s after last stim
            DAC    0,V15           ; immediately return value to resting values
            DAC    1,V16           ; immediately return value to resting values  
            HALT

;second EMG-matched isometric contraction ISOPF
OVER4:   'P DAC    0,V15           ; stretch                            Send a signal out of DAC 0 at the voltage specified by V15 Starting value 1 (draws ramp 1)
            DAC    1,V16           ;Sends a signal our of DAC 2 at the voltage specified by V16 Starting value 2 (draws ramp2)
            DELAY  V25            ;give the user a number of seconds before ramp starts
            RAMP   0,V19,V12        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
            RAMP   1,V20,V12        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
WT5:        WAITC  0,WT5           ;wait for ramp to end before going on to next command
WT5a:       WAITC  1,WT5a          ;wait for ramp to end before going on to next command
PULSE4:     DELAY  V37            ;One threshold is reached, wait 2 seconds before rotation
            DIGOUT [00000001]      ;Turn on signal   (second stim)
            DIGOUT [00000000]      ;Turn off signal
            DELAY  V38         ; Hold until 1s after last stim
            DAC    0,V15           ; immediately return value to resting values
            DAC    1,V16           ; immediately return value to resting values
            HALT        
;This code allows for EMG target to be met, followed by a stretch-hold. During hold, there are stims STR
OVER5:  'L  DAC    0,V15           ; shortening                         Send a signal out of DAC 0 at the voltage specified by V15 Starting value 1 (draws ramp 1)
            DAC    1,V16           ;Sends a signal our of DAC 2 at the voltage specified by V16 Starting value 2 (draws ramp2)
            DELAY  V25            ;give the user a number of seconds before ramp starts
            RAMP   0,V19,V12        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
            RAMP   1,V20,V12        ;Draws EMG ramp, as it increases to target value(amp/time=rate)
WT6:        WAITC  0,WT6           ;wait for ramp to end before going on to next command
WT6a:       WAITC  1,WT6a          ;wait for ramp to end before going on to next command           
PULSE5:     DELAY  V41            ;One threshold is reached, wait 2.645 seconds before rotation
            DIGOUT [....1000]      ;send stim on DIG11, this goes to the dynamometer to produce plantarflexion rotation
            DELAY  ms(10) 
            DIGOUT [00000000]      ;Turn off signal
            RAMP   0,V17,1         ;Draws EMG ramp, as it increases to target value(amp/time=rate)
            RAMP   1,V18,1         ;Draws EMG ramp, as it increases to target value(amp/time=rate)
WT7:        WAITC  0,WT7           ;wait for ramp to end before going on to next command
WT7a:       WAITC  1,WT7a          ;wait for ramp to end before going on to next command   
            DELAY  ms(641)
            DELAY  V40
            DIGOUT [00000001]      ;Signal stim box from 1401 dat output 0 (first stim)
            DIGOUT [00000000]      ;Turn off signal
            DELAY  V38             ; Hold until 1s after last stim
            DAC    0,V15           ; immediately return value to resting values
            DAC    1,V16           ; immediately return value to resting values  
            HALT