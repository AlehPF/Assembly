; Professor: Ricardo Bohaczuk Venturelli
; Aluno: Alisson Pereira Ferreira

; O algoritmo l� dois n�meros da mem�ria, verifica se eles s�o menores que 80h e, em seguida, 
; realiza uma multiplica��o usando o algoritmo de Booth, esta por sua vez � realizada 08 por se tratar
; de n�meros de 8 bytes.

; Obs: Os n�meros devem ser colocados transformados de Binario para Hexadecimal.
; Exemplo: -03H x -05 = FDH x FBH, logo esta convers�o deve ser realiza para a plotagem dos valores.
; Exemplo 2: Caso o valor seja 80H, saira 00H 00H.

.ORG 0000H
NUMERO_1:
    LXI H, 4000H        ; Define o endere�o de mem�ria do primeiro n�mero
    MOV A, M            ; Move a mem�ria para o acumulador A
    CPI 80H             ; Compara o acumulador A com 80H
    JZ  OVERFLOW        ; Pula para OVERFLOW se forem iguais
    MOV B, A            ; Se for menor, move o acumulador A para o B
    JMP NUMERO_2        ; Pula para o NUMERO_2

NUMERO_2:
    INX H                ; Incrementa o H para o endere�o do segundo n�mero
    MOV A, M             ; Move o H para o acumulador A
    CPI 80H              ; Compara o acumulador A com 80H
    JZ  OVERFLOW         ; Pula para o OVERFLOW se forem iguais
    MOV C, A             ; Move o acumulador A para o  C
    JMP INICIALIZACAO    ; Pula para INICIALIZACAO

INICIALIZACAO:
    MVI D, 00H           ; Carrega o valor 00H para o D
    MVI E, 00H           ; Carrega o valor 00H para o E
    MVI H, 08H           ; Carrega o valor 08H para o H
    JMP LOOP             ; Pula para o LOOP

LOOP:
    MOV A, E             ; Move o E para o acumulador A
    ANI 01H              ; Realiza uma AND com o valor 01H
    MOV L, A             ; Move o acumulador A para o L
    MOV A, C             ; Move o C para o acumulador A
    ANI 01H              ; Realiza uma AND com o valor 01H
    RLC                  ; Rota��o � esquerda do acumulador A
    ADD L                ; Soma o L com o acumulador A
    CPI 00H              ; Compara o acumulador A com 00H
    JZ  ROTACAO          ; Pula para a ROTACAO se forem iguais
    CPI 03H              ; Compara o acumulador A com 03H
    JZ  ROTACAO          ; Pula para a ROTACAO se forem iguais
    CPI 01H              ; Compara o acumulador A com 01H
    JZ  SOMA             ; Pula para a SOMA se forem iguais
    CPI 02H              ; Compara o acumulador A com 02H
    JZ  SUBTRACAO        ; Pula para a SUBTRACAO se forem iguais

SOMA:
    MOV A, D             ; Move o D para o acumulador A
    ADD B                ; Adiciona o B ao acumulador A
    MOV D, A             ; Move o acumulador A para o D
    JMP ROTACAO          ; Pula para a ROTACAO

SUBTRACAO:
    MOV A, D             ; Move o D para o acumulador A
    SUB B                ; Subtrai o B do acumulador A
    MOV D, A             ; Move o acumulador A para o D
    JMP ROTACAO          ; Pula para a ROTACAO

ROTACAO:
    STC                  ; Define o bit de carry (C) como 1
    CMC                  ; Complementa o bit de carry (C)
    MOV A, D             ; Move o D para o acumulador A
    ANI 80H              ; Realiza uma AND com o valor 80H
    RAL                  ; Rota��o � esquerda do acumulador A atrav�s do carry
    MOV A, D             ; Move o D para o acumulador A
    RAR                  ; Rota��o � direita em A atrav�s do carry
    MOV D, A             ; Move o acumulador A para o D
    MOV A, C             ; Move o C para o acumulador A
    RAR                  ; Rota��o � direita em A atrav�s do carry
    MOV C, A             ; Move o acumulador A para o C
    MOV A, E             ; Move o E para o acumulador A
    RAL                  ; Rota��o � esquerda em A atrav�s do carry
    ANI 01H              ; Realiza uma AND com o valor 01H
    MOV E, A             ; Move o acumulador A para o E
    DCR H                ; Decrementa o valor de H
    JZ  RESULTADO        ; Pula para RESULTADO se for zero
    JMP LOOP             ; Pula para o LOOP

OVERFLOW:
    LXI H, 4002H         ; Carrega o par HL com o valor 4002H
    MVI M, 00H           ; Move o valor 00H para a mem�ria apontada por H
    INX H                ; Incrementa o H
    MVI M, 00H           ; Move o valor 00H para a mem�ria apontada por L
    JMP FIM              ; Pula para o FIM

RESULTADO:
    LXI H, 4002H         ; Carrega o par HL com o valor 4002H
    MOV M, C             ; Move o C para a mem�ria apontada por H
    INX H                ; Incrementa o H
    MOV M, D             ; Move o D para a mem�ria apontada por L
    JMP FIM              ; Pula para o FIM

FIM:
    HLT                  ; Finaliza o programa
