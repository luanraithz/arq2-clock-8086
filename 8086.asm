data segment         
   
    
    LINHA  DB ?
    COLUNA DB ?
    DIGITO DB ?               
    DIGITO_UNI DB ?
    DIGITO_DEZ DB ?
    MINUTOS DB ?
    SEGUNDOS DB ?                            
    ENTRY_SEGUNDOS DB ' Digite os segundos: ', '$'
    ENTRY_MINUTOS DB 'Digite os minutos: ', '$'
    

ZERO   DB "   ___  ", 10
       DB "  / _ \ ", 10
       DB " | | | |", 10
       DB " | |_| |", 10
       DB "  \___/ ", 0
   
UM     DB "    _    ", 10
       DB "   / |   ", 10
       DB "   | |   ", 10
       DB "   | |   ", 10
       DB "   |_|   ", 0

DOIS   DB " ____    ", 10
       DB "|___ \   ", 10
       DB "  __) |  ", 10
       DB " / __/   ", 10
       DB "|_____|  ", 0
   
TRES   DB " _____   ", 10
       DB "|___ /   ", 10
       DB "  |_ \   ", 10
       DB " ___) |  ", 10
       DB "|____/   ", 0
   
QUATRO DB " _  _    ", 10
       DB "| || |   ", 10
       DB "| || |_  ", 10
       DB "|__   _| ", 10
       DB "   |_|   ", 0
   
CINCO  DB " ____    ", 10
       DB "| ___|   ", 10
       DB "|___ \   ", 10
       DB " ___) |  ", 10
       DB "|____/   ", 0
   
SEIS  DB "  __     ", 10
      DB " / /_    ", 10
      DB "| '_ \   ", 10
      DB "| (_) |  ", 10
      DB " \___/   ", 0
   
SETE  DB " _____   ", 10
      DB "|___  |  ", 10
      DB "   / /   ", 10
      DB "  / /    ", 10
      DB " /_/     ", 0
   
OITO  DB "  ___    ", 10
      DB " ( _ )   ", 10
      DB " / _ \   ", 10
      DB "| (_) |  ", 10
      DB " \___/   ", 0
   
NOVE  DB "  ___    ", 10
      DB " / _ \   ", 10
      DB "| (_) |  ", 10
      DB " \__, |  ", 10
      DB "   /_/   ", 0

PONTOS  DB "       ",10
        DB "  ::   ",10
        DB "       ",10
        DB "  ::   ",10
        DB "       ",0
ends             
ends             
                 
stack segment
    dw   128  dup(0)
ends

code segment
start:

    mov ax, data
    mov ds, ax
    mov es, ax
    
    
    LEA DX,ENTRY_MINUTOS  
    MOV AH,09H 
    INT 21H
            
     ; Pega dezena do minuto
    MOV AH,08H 
    INT 21H 
    MOV MINUTOS, AL
    
    MOV DL, AL
    MOV AH, 2 
    INT 21H  
    ADD AL, -30h
    MOV MINUTOS, AL

    MOV AL, MINUTOS
    MOV DL, 10
    MUL DL
    MOV MINUTOS, AL
    

    
    MOV AH,08H 
    INT 21H
    MOV DIGITO_UNI, AL
    MOV DL, AL
    MOV AH, 2 
    INT 21H  
    MOV AL, DIGITO_UNI
    ADD AL, -30h
    ADD AL, MINUTOS
    MOV MINUTOS, AL
   
         
    LEA DX,ENTRY_SEGUNDOS
    MOV AH,09H 
    INT 21H
  
    ; Pega dezena do segundo
    MOV AH,08H 
    INT 21H 
    MOV SEGUNDOS, AL
    MOV DL, AL
    MOV AH, 2 
    INT 21H  
    MOV AL, SEGUNDOS
    ADD AL, -30h

    MOV SEGUNDOS, AL
    MOV AL, SEGUNDOS
    MOV DL, 10
    MUL DL
    MOV SEGUNDOS, AL
   
    MOV AH,08H 
    INT 21H 
    MOV DIGITO_UNI, AL
    MOV DL, AL
    MOV AH, 2 
    INT 21H  
    MOV AL, DIGITO_UNI
    ADD AL, -30h
    ADD AL, SEGUNDOS
    MOV SEGUNDOS, AL
    
    
    
    INT 10H
    ;DESLIGA CURSOR
   

MOSTRANDO:

    
    ; IMPRIME DEZ SS
    MOV AH,0
    MOV AL,SEGUNDOS 
    MOV BL,10
    DIV BL
    MOV DIGITO_DEZ, AL
    MOV DIGITO_UNI, AH

    MOV AL,DIGITO_DEZ
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 35
    CALL IMPRIME_DIGITO                             
               
    ; IMPRIME UNID SS           
    MOV AL,DIGITO_UNI
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 45
    CALL IMPRIME_DIGITO                          
                  
                  
    MOV LINHA,  5
    MOV COLUNA, 25
    CALL IMP_DOIS_PONTOS

    ; CL TEM SEGUNDOS             
    MOV AH,0
    MOV AL, MINUTOS 
    MOV BL,10
    DIV BL
    MOV DIGITO_DEZ, AL
    MOV DIGITO_UNI, AH
                  
    ; IMPRIME DEZ MM
    MOV AL,DIGITO_DEZ
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 5
    CALL IMPRIME_DIGITO                             
               
    ; IMPRIME UNID MM           
    MOV AL,DIGITO_UNI
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 15
    CALL IMPRIME_DIGITO

    CALL MINHA_INTERRUPCAO
    CALL DELAY
    JMP MOSTRANDO
   
    mov ax, 4c00h
    int 21h   

IMPRIME_DIGITO:
    CMP DIGITO,0
    JE IMP_ZERO
    CMP DIGITO,1
    JE IMP_UM
    CMP DIGITO,2
    JE IMP_DOIS
    CMP DIGITO,3
    JE IMP_TRES
    CMP DIGITO,4
    JE IMP_QUATRO
    CMP DIGITO,5
    JE IMP_CINCO
    CMP DIGITO,6
    JE IMP_SEIS
    CMP DIGITO,7
    JE IMP_SETE
    CMP DIGITO,8
    JE IMP_OITO
    CMP DIGITO,9
    JE IMP_NOVE


DELAY:   
  mov cx, 7      
  mov dx, 0A120h
  mov ah, 86h
  int 15h
  ret

MINHA_INTERRUPCAO:
	PUSHF
	INC SEGUNDOS ; INCREMENTA SEGUNDOS
	CMP SEGUNDOS,60 ; CHEGOU EM 60 SEGUNDOS
	JNE SAI_MINHA_INTERRUPCAO ; JMP IF NOT EQUAL
	MOV SEGUNDOS,0;  SIM, CHEGOU, ENTAO ZERO SSS
	INC MINUTOS; INCREMENTA MINUTOS
	CMP MINUTOS,60; CHEGAMOS EM 60 MINUTOS
	JNE SAI_MINHA_INTERRUPCAO
	MOV MINUTOS,0; ZERE MINUTOS
	JNE SAI_MINHA_INTERRUPCAO
SAI_MINHA_INTERRUPCAO:
		POPF
		RET

IMP_DOIS_PONTOS:
    LEA SI, PONTOS
    JMP IMPRIMINDO

IMP_ZERO:
    LEA SI, ZERO
    JMP IMPRIMINDO
IMP_UM:
    LEA SI, UM
    JMP IMPRIMINDO
IMP_DOIS:
    LEA SI, DOIS
    JMP IMPRIMINDO
IMP_TRES:
    LEA SI, TRES
    JMP IMPRIMINDO
IMP_QUATRO:
    LEA SI, QUATRO
    JMP IMPRIMINDO
IMP_CINCO:
    LEA SI, CINCO
    JMP IMPRIMINDO
IMP_SEIS:
    LEA SI, SEIS
    JMP IMPRIMINDO
IMP_SETE:
    LEA SI, SETE
    JMP IMPRIMINDO                  
IMP_OITO:
    LEA SI, OITO
    JMP IMPRIMINDO
IMP_NOVE:
    LEA SI, NOVE
    JMP IMPRIMINDO

IMPRIMINDO:
    ; POSICIONA CURSOR
    MOV AH,2
    MOV BH,0
    MOV DH, LINHA
    MOV DL, COLUNA   
    INT 10H     

PROCURA_FIM:
    mov dl,ds:[si]
    cmp dl,0
    je FIM_IMPRESSAO
    cmp dl,10
    je pula_linha
    mov ah,2     
    int 21h       
    INC SI
    JMP PROCURA_FIM
   
pula_linha:
   
    inc byte ptr linha
    inc si
    jmp IMPRIMINDO
                   
FIM_IMPRESSAO:
    RET                   
                   
ends

end start