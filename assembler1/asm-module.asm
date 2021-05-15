bits 64
; posun doleva - nasobeni
; posun doprava -deleni

    section .data

    section .text

; int chmod (int cislo)
;                  RDI,   RSI,RDX,RCX, R8, R9 (RAX, R10, R11)
    global chmod
.chmod:
    enter 0,0



    leave
    ret

;int revolver (uint8_t naboje);
;                       RDI,   RSI,RDX,RCX, R8, R9 (RAX, R10, R11)

    global revolver
revolver:
    enter 0,0
    mov rax, 0
    mov r8, 0 ;citac
    mov rsi,1 ;pocet naboju
    mov dl,1  ;maska, co testuje, jestli tam je 1

.back:
    cmp r8, 8
    jge .end

    test dl, dil ; pokud and vyjde 0 -> neni tam 1 a pokracuj
    jz .continue

    or rax, rsi ;and vysel 1 -> pridej naboj na konec
    shl rsi,1

.continue:
    shr dil,1
    inc r8
    jmp .back

.end:
    leave
    ret

;int palindrom(char *string, int delka, int vysledek);
;                       RDI,       RSI,         RDX,        RCX, R8, R9 (RAX, R10, R11)

    global palindrom
palindrom:
    enter 0,0
    movsx rsi, esi ; prodlouzeni delky na 64 bitu
    mov r8, 0

.back:
    cmp rsi, 1
    je .ano
    sub rsi, 1

    mov dl, [rdi+rsi] ; posledni znak

    cmp [rdi+r8], dl ; porovnam posldeni znak s prvnim
    jz .continue ; pokud jsou stejne,skoc na .continue

    jmp .ne ; pokud nejsou stejne, skonc na .ne

.continue:
    inc r8
    jmp .back

.ano:
    mov eax, 1
    jmp .end

.ne:
    mov eax, 0

.end:
    leave
    ret


;int rousky_prepocet(int pocet_rousek, int* vysledek);
;                                 RDI,   RSI,         RDX, RCX, R8, R9 (RAX, R10, R11)

    global rousky_prepocet
rousky_prepocet:
    enter 0,0

    ; tohle tu delam proc? nejake pointrove kouzleni
    mov eax, [rsi]
    mov rcx, [rsi]

    mov edx, edi ; ulozim si pocet rousek do promene r8
    shl edi,1 ;nasobim cislo 2
    shr edx,2 ;delim cislo 4

    mov [rsi], edi ;presunu na prvni hodnotu v poli
    mov [rsi+4], edx ;presunu na druhou hodnotu v poli

    leave
    ret

;void set_bits (char *cisla_bitu, int len)
;                           RDI,   RSI,     RDX, RCX, R8, R9 (RAX, R10, R11)

    global set_bits
set_bits:
    enter 0,0
    mov rdx, 0 ;citac
    movsx rsi, esi
    mov rax, 0 ;zde bude ulozeny vysledek

.back:
    cmp rdx, rsi
    jge .end
    mov rcx, 0
    mov cl, [rdi+rdx] 
    mov r8, 1 
    shl r8, cl ;posunu 1 na pozici bitu, ktery chci nastavit
    or rax, r8 

    inc rdx
    jmp .back

.end:
    leave
    ret


; int over_cislo(char* retezec);
;                      RDI,     RSI, RDX, RCX, R8, R9 (RAX, R10, R11)

    global over_cislo
over_cislo:
    enter 0,0
    mov rax,0 ; ulozeni vysledku
    mov r8,0 ;citac
    mov rsi,0 ;pocet tecek

.back:
    cmp byte [ rdi+r8], 0
    je .dobre_cislo

    ;pokud je znak mimo rozsah cisel, skoc na continue
    cmp byte [rdi+r8], '0'
    jb .continue

    cmp byte [rdi+r8], '9'
    ja .continue

    inc r8
    jmp .back

.continue:
    ; pokud znak nebyl cislo, over, ze je to nektery z nasledujicich
  
    cmp byte [rdi+r8], '_'
    je .continue2

    cmp byte [rdi+r8], '-'
    je .over_pozici

    cmp byte [rdi+r8], '.'
    je .over_pocet

    jmp .spatne_cislo

.over_pozici:
    cmp r8, 0
    ja .spatne_cislo

.over_pocet:
    cmp rsi,1
    jae .spatne_cislo
    inc rsi

.continue2:
    inc r8
    jmp .back

.dobre_cislo:
    mov eax,1
    jmp .end

.spatne_cislo:
    mov eax, 0

.end:
    leave
    ret

;copy_char(char *t_vysledek, char *t_predloha, char nahrada )
;                      RDI,            RSI,          RDX,     RCX, R8, R9 (RAX, R10, R11)
    global copy_char
copy_char:
    enter 0,0
    mov r8,0 ; citac
    mov eax, 0 ; zde budu ukladat vysledek

.back:

    cmp byte [rsi+r8], 0 ; testuju konec retezce
    je .end

    ; pokud znak neni velke pismeno, pokracuju na continue
    cmp byte [rsi+r8], 'A'
    jb .continue

    cmp byte [rsi+r8], 'Z'
    ja .continue

    mov [rdi+r8], dl ; pokud je pismeno velke, nahradim ho znakem, jinak pokracuju
    jmp .continue2

.continue:
     mov cl,  [rsi+r8]
     mov [rdi+r8], cl
     inc eax

.continue2:
    inc r8
    jmp .back

.end:
    leave
    ret

; void bubble (int *arr, int n);
;                  RDI,   RSI,      RDX,     RCX, R8, R9 (RAX, R10, R11)
; buble sort
    global bubble
bubble:
    enter 0,0

    movsx rsi, esi
    dec rsi 

    mov r8, 0 ;i=0

.fori:
    cmp r8, rsi ;i<n-1
    jge .endfori

    mov r9, 0 ; j=0
    mov rdx, rsi
    sub rdx, r8 ; n-i-1
.forj:
        cmp r9, rdx ; j<N-i
        jge .endforj

       
        mov ecx, [rdi+r9*4] 
        mov eax, [rdi+r9*4+4] ;arr [j+i]
        cmp ecx, eax
        jl .taknic

        ;swap
        mov [rdi+r9*4],eax ;arr[j]=rax
        mov [rdi+r9*4+4], ecx ;arr[j+1]=rcx
.taknic:
        inc r9
        jmp .forj

.endforj:
    inc r8
    jmp .fori

.endfori:
    leave
    ret


; void minmax_arr(int *arr, int n, int *minmax);
;                      RDI,   RSI,      RDX,     RCX, R8, R9 (RAX, R10, R11)

    global minmax_arr:
minmax_arr:
    enter 0,0
    push rbx 

     mov ebx, [rdi] ;minimum
     mov eax, [rdi] ;maximum
     movsx rsi, esi ; pocet prvku
     mov r11, 0 ; ridici promena

.back:
    cmp r11, rsi
    jge .end

    cmp eax, [rdi+r11*4] ;porovnam maximum
    jge .continue

    mov eax, [rdi+r11*4]
.continue:
    cmp ebx, [rdi+r11*4]  ;porovnam minimum
    jle .continue2
    mov ebx, [rdi+r11*4]  ;minimum
.continue2:
    inc r11
    jmp .back

.end:
    mov [rdx], ebx
    mov [rdx+4], eax
    pop rbx
    leave
    ret

; long str_len(char *s);
;                 RDI,   RSI,RDX, RCX, R8, R9 (RAX, R10, R11)

    global str_len
str_len:
    enter 0,0
    mov rax,0 ; delka i index

.back:
    cmp  [rdi+rax],byte  0 ; musim uvest velikost -> byte pred 0
    je .end

    inc rax
    jmp .back
.end:
    leave
    ret

 ;int suma_int_arr(int* arr, int d);
 ;                    RDI,     RSI,   RDX, RCX, R8, R9 (RAX, R10, R11)

    global suma_int_arr
suma_int_arr:
    enter 0,0
    mov rdx, 0 ;ridici promena
    movsx rsi, esi ; rozsireni N
    mov rax, 0 ;vynuluju akumulator

.back:
    cmp rdx, rsi
    jge .end

    ;movsx rcx, dword [rdi+rdx*4]
    add eax, [rdi+rdx*4] ; vracime jen 32 bitu, proto eax

    inc rdx
    jmp .back

.end:
    leave
    ret

;   long sum_lic(long a, int b, char c)
;                 RDI,     RSI,   RDX,    RCX, R8, R9 (RAX, R10, R11)
    global sum_lic
sum_lic:
    enter 0,0

    mov rax, rdi ; pridavam na akumulaor,kde bude vysledek
    movsx rsi, esi 
    movsx rdx, dl ;c
    add rax, rsi
    add rax, rdx


    leave
    ret

;int is_digit(char c, char hex)
;               RDI,      RSI, RDX, RCX, R8, R9 (RAX, R10, R11)

    global is_digit
is_digit:
    enter 0,0

    mov rax, 0
    cmp dil, '0' ; porovnavam, jestli je pod nulou
    jb .ret_false
    cmp dil, '9' ; vim, ze je mezi nulou a devitkou -> vratim true
    jbe .ret_true

    test sil, sil ; testuju, jestli je hexa
    and dil,  ~('a' -'A')

    jz .ret_false ; neni hexa a vracim false

    cmp dil, 'A' ; testuju, jestli je mezi pismeny
    jb .ret_false

    cmp dil, 'F'
    ja .ret_false ; neni mezi pismeny, vracim false

.ret_true:
    mov eax,1 ; vracim int  -> proto eax

.ret_false:
    leave
    ret

  ;int sum_2int (int a, int b)
  ;                RDI,   RSI, RDX, RCX, R8, R9 (RAX, R10, R11)
    global sum_2int
sum_2int:
    enter 0,0

    movsx rax, edi ;ret=a
    movsx rsi, esi ;prevod na spravnou velikost registru
    ;mov eax, edi
    add rax, rsi ;ret+=b
                 ;ret a

    leave
    ret
