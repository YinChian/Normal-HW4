
KEY_CTL    DATA   0EAH
KEY1_DAtA   DATA  0EBH
KEY2_DATA   DATA  0ECH

IR_TX_CTL   DATA  0F1H
IR_TX1      DATA  0F2H
IR_TX2      DATA  0F3H
IR_TX3      DATA  0F4H
IR_TX4      DATA  0F5H

        ORG      300h
KEYCODE_TABLE:  
            DB  0F0H    // K0
            DB  031H    // K1
            DB  001H    // K2
            DB  000H    // K3
            DB  010H    // K4
            DB  020H    // K5
            DB  030H    // K6
            DB  040H    // K7
            DB  050H    // K8
            DB  060H    // K9
            DB  070H    // K10
            DB  080H    // K11
            DB  090H    // K12
            DB  021H    // K13
            DB  0A1H    // K14
            DB  0E1H    // K15

  // reset start
    ORG     0000h
    JMP     MAIN
    
    ORG     0040h    
MAIN: 
    MOV     SP,#70H     // INIT STACK POINTER                   
    MOV     KEY_CTL,#01H  // ENABLE KEY SCAN
             
MAIN_0: 
    MOV     A,KEY_CTL
    JB      ACC.4,KEY_PRESSED       // CHECK BIT4 == 1
    JB      ACC.5,KEY_REPEAT        // CHECK BIT5 == 1  
    JMP     MAIN_0
    
KEY_REPEAT:
    MOV     IR_TX_CTL,#02H             // SEND REPEAT CODE
KEY_REPEAT_0:
    MOV     A,IR_TX_CTL
    JNB     ACC.4,KEY_REPEAT_0      // WAIT TX_COMPLETE = 1   
	MOV     IR_TX_CTL,#00H          // CLEAR FLAG
    JMP     MAIN_0    
    
KEY_PRESSED:
    MOV     R7,#0                  // keycode index
    MOV     R1,#08H    
        
    MOV     A,KEY1_DATA
KEY_PRESSED_0:
    JB      ACC.0,KEY_FIND
    RR      A
    INC     R7         
    DJNZ    R1,KEY_PRESSED_0
    
    MOV     R1,#08H
    MOV     A,KEY2_DATA
KEY_PRESSED_1:
    JB      ACC.0,KEY_FIND
    RR      A
    INC     R7         
    DJNZ    R1,KEY_PRESSED_1    
    
    
KEY_FIND:                 
    
    MOV     IR_TX1,#068H           //customer code
    MOV     IR_TX2,#0B6H
    
    
    MOV     DPTR,#KEYCODE_TABLE
    MOV     A,R7                   // key code
    MOVC    A,@A+DPTR
    MOV     IR_TX3,A
    
    XRL     A,#0FFH                // reverse byte
    MOV     IR_TX4,A
    
    MOV     IR_TX_CTL,#01H         // SEND TX
    
KEY_PRESSED_WAIT:    
    MOV     A,IR_TX_CTL
    JNB     ACC.4,KEY_PRESSED_WAIT      // WAIT TX_COMPLETE = 1
	MOV     IR_TX_CTL,#00H         // CLEAR FLAG
    JMP     MAIN_0
  
    
    END