bits 64

section .data


section .text

;int slova(char *slova)
;                 rdi,     rsi, rdx, rcx, r8, r9 ... rax, r10, r11

    global slova
slova:
    enter 64 ,0 ;4*16

    mov r8, 0; citac znaky
    mov r9, 0 ;citac delky slova
    mov rsi, 0 ;nejcetnejsi vyskyt
    mov rax, 0 ;pozice nejcastejsiho vyskytu

.back:
    cmp [rdi+r8], byte  0 ;sleduji konec retezce
    je .end

    cmp [rdi+r8], byte ' ' ;
    je .mezera

    cmp [rdi+r8], byte '.'
    je .mezera

    inc r9
    jmp .continue

.mezera:
    mov rdx, r9
    sub r9,1 ;potrebuju by v rozmezi 0-15
    inc dword [rbp-64+r9] ;zvysim hodnotu na dane pozici na zasobniku

    cmp esi,[rbp-64+r9] ; porovnam aktualni maximu s nove zvysenou hodnotou na zasobniku
    cmovl eax, edx 

     mov r9, 0

.continue:
    inc r8
    jmp .back

.end:
    leave
    ret

;void poslopunosti(char *str);
;                         rdi,     rsi, rdx, rcx, r8, r9 ... rax, r10, r11
    global posloupnosti
posloupnosti:
    enter 128, 0 ; retezec bude mit maximalni velikost 128 bytu
    mov r8, 0 ; i, prochazi slovo
    mov r9, 0 ; citac v lokani pameti
.back:
    cmp [rdi+r8], byte 0
    je .end


    cmp [rdi+r8], byte 'd'
    je .kopiruj_cisla

    cmp [rdi+r8], byte 'm'
    je .kopiruj_mala

    cmp [rdi+r8], byte 'v'
    je .kopiruj_velka

.kopiruj_cisla:
    mov r10, 0
    mov sil, '0'

.back_cisla:
    cmp r10, 10
    jge .continue

    mov [rbp-128+r9], sil
    add sil,1

    inc r9
    inc r10
    jmp .back_cisla

.kopiruj_mala:
    mov r10, 0
    mov sil, 'a'
.back_mala:
    cmp r10,  26
    jge .continue

    mov [rbp-128+r9] ,sil
    add sil,1

    inc r9
    inc r10

    jmp .back_mala

.kopiruj_velka:
    mov r10,0
    mov sil, 'A'

.back_velka:
    cmp r10, 26
    jge .continue

    mov [rbp-128+r9], sil
    add sil,1

    inc r9
    inc r10

    jmp .back_velka

.continue:
    inc r8
    jmp .back

.end:
    mov r11, 0

.nakopiruj_zpatky:
    cmp r11, r9
    jge .end2

    mov dl, [rbp-128+r11]
    mov [rdi+r11], dl

    inc r11
    jmp .nakopiruj_zpatky

.end2:
    mov [rdi+r11], byte 0
    leave
    ret

;int check_bits (int *arr, int len);
;                     rdi,     rsi, rdx, rcx, r8, r9 ... rax, r10, r11
    global check_bits
check_bits:
    enter 128, 0
    movsx rsi, esi
    mov r11, 0 ; aktualni maximum
    mov r8, 0  ; citac v poli
    mov rcx, 0 ;pozice bitu

    mov rcx, 32 ;nuluju pomoci dword ->byty 128/4=32 -> cislo bude mit dle zadani max 32 pozic
.while: ; vynuluju pole na same nuly
    dec rcx ; i--
    mov [rbp-128+rcx*4], dword 0
    jnz .while ; priznakove bity nastavene na dekrementu

.for_i:
    cmp r8, rsi
    jge .end_i

    mov rdx, 1 ;maska na testovani bitu
    mov eax, [rdi+r8*4] ; cislo, jehoz bity jdu testovat
    mov r9, 0 ; citac pozice bitu
    mov r10, 32 ;pocet bitu v cisle
.for_j:
    cmp r9, r10
    jge .end_j

    test eax, edx
    jz .continue_j

    ;tento kod se vykona, pokud je c priznakovych bitech 1
    inc byte [rbp-128+r9*4]
    cmp ecx, [rbp-128+r9*4] ;hledani noveo maxima
    cmovl ecx, [rbp-128+r9*4] ;hodnota maxima
    cmovl r11, r9 ;pozice maxima


.continue_j:
    shl rdx,1
    inc r9
    jmp .for_j

.end_j:
    inc r8
    jmp .for_i

.end_i:
    mov eax, r11d
    leave
    ret


;int split(int* arr, int len)
;               rdi,     rsi, rdx, rcx, r8, r9 ... rax, r10, r11

    global split
split:
    enter 1024, 0
    ; [rbp-1024] zaporna
    ; [rbp-512] kladna
    mov r8, 0 ; i
    mov r10,0 ; pocet kladnych
    mov r11,0 ; pocet zapornych

    movsx rsi, esi

.back:
    cmp r8, rsi
    jge .end

    mov eax, [rdi+r8*4]
    cmp eax, 0
    jl .pridej_zaporne
    jg .pridej_kladne


    jmp .continue

.pridej_kladne:
    mov [rbp- 512+r10*4], eax
    inc r10
    jmp .continue


.pridej_zaporne:
    mov [rbp- 1024+r11*4], eax
    inc r11

.continue:
    inc r8
    jmp .back

.end:
    mov r8, 0
    cmp r10, r11 ; porovnam, jesti je vice kladnych nebo zapornych
    mov rax, r10
    ja .kopiruj_kladna
    mov rax, r11
    jb .kopiruj_zaporna

    mov rax, 0
    jmp .end2

.kopiruj_kladna:
    cmp r8, r10

    je .end2
    mov esi, [rbp- 512+r8*4]
    mov [rdi+r8*4], esi

    inc r8
    jmp .kopiruj_kladna

.kopiruj_zaporna:

    cmp r8, r11
    je .end2
    mov esi, [rbp- 1024+r8*4] ;vytahnu si cislo ze zasobniku
    mov [rdi+r8*4], esi ;ulozim cislo ze zasobniku do puvodniho pole

    inc r8
    jmp .kopiruj_zaporna

.end2:
    leave
    ret

;int split_str( int *t_array, int t_len );
;                        rdi,       rsi, rdx, rcx, r8, r9 ... rax, r10, r11
    global split_str
split_str:
    enter 256,0
    ; [rbp-128] velka
    ; [rbp-256] mala

    mov rdx, 0 ;pocet velkych
    mov rsi, 0 ;pocet malych
    mov r8, 0; i na prochazeni retezce

.back:
    cmp [rdi+r8], byte 0
    je .end

    cmp [rdi+r8], byte 'Z'
    jbe .checkZ ;

    cmp [rdi+r8], byte 'z'
    jbe .checkz ; vubec neni pismeno

    jmp .continue

.checkZ:
    cmp [rdi+r8], byte 'A'
    jae .zapis_velke

    jmp .continue

.zapis_velke:
    mov al, [rdi+r8]
    mov [rbp-128+rdx], al ;ulozi do pole pro velka cisla dane pismeno
    inc rdx
    jmp .continue

.checkz:
    cmp [rdi+r8], byte 'a'
    jae .zapis_male

    jmp .continue

.zapis_male:
     mov al, [rdi+r8]
     mov [rbp-256+rsi], al
     inc rsi
     jmp .continue

.continue:
    inc r8
    jmp .back

.end:
    cmp rsi, rdx
    mov r8, 0
    ja .prepis_mala

    jmp .prepis_velka

.prepis_mala:
     cmp r8, rsi
     je .end2

     mov al, [rbp-256+r8]
     mov [rdi+r8], al

     inc r8
     jmp .prepis_mala

.prepis_velka:
     cmp r8, rdx
     je .end2

     mov al, [rbp-128+r8]
     mov [rdi+r8], al

     inc r8
     jmp .prepis_velka

.end2:
    mov [rdi+r8], byte 0
    leave
    ret


;void replace(char *t_str);
;                     rdi, rsi, rdx, rcx, r8, r9 ... rax, r10, r11
    global replace
replace:
    enter 256,0 ; 256 je pro tuto ulohu stanoveno jako maximalni pocet cisel
    mov r8, 0 ;citac pro retezec
    mov r9, 0 ;citac pro ukladani nazasobnik
.back:
    cmp [rdi+r8], byte 0
    je .end

    cmp [rdi+r8], byte '.'
    je .hvezda

    mov al, [rdi+r8]
    mov [rbp-128+r9],al
    inc r9
    jmp .continue

.hvezda:
    mov [rbp-128+r9], byte '*'
    inc r9
    mov [rbp-128+r9], byte '*'
    inc r9
.continue:
    inc r8
    jmp .back
.end:
    mov [rbp-128+r9], byte 0
    mov r10, 0

.back2:
    cmp r10, r9
    je .end2

    mov al, [rbp-128+r10]
    mov [rdi+r10], al ; prepisuju hodnoty ze zasobniku zpet do puvodniho retezce

    inc r10
    jmp .back2
.end2:
    mov [rdi+r10], byte 0
    leave
    ret

;void digits( char *t_str, char t_digit);
;                     rdi,           rsi,   rdx, rcx, r8, r9 ... rax, r10, r11
    global digits
digits:
    enter 0,0

    mov r8, 0
    mov r9,0


.back:
    cmp [rdi+r8], byte 0
    je .end

    mov al, [rdi+r8]
    cmp [rdi+r8], sil
    je .prekopiruj_cislice

    inc r8
    jmp .back
.prekopiruj_cislice:
    mov r8, 0
.back2:
    cmp [rdi+r8], byte 0
    je .ukonci

    cmp [rdi+r8], byte '0'
    jb .continue

     cmp [rdi+r8], byte '9'
     ja .continue

     mov dl, [rdi+r8] ;nalezena cislice
     mov [rdi+r9], dl ;nakopirovani do puvodniho retezce
     inc r9

.continue:
    inc r8
    jmp .back2
.ukonci:
    mov [rdi+r9], byte 0 ;ukonceni retezce

.end:
    leave
    ret

;int count_modulo( int *t_array, int t_len );
;                           rdi,      rsi,   rdx, rcx, r8, r9 ... rax, r10, r11
    global count_modulo
count_modulo:
    enter 48,0 ; potrebuji pole 10 intu -> 40 bytu -> nejblizsi nasobek 16 je 48
               
    mov r8, 0 ; i
    movsx rsi,esi
    mov r9d, 10 ;desitkou potrebuju delit
    mov rax, 0
    mov r11, 0 ;aktualni maximum
    mov r10, 0 ;hodnota maxima

    mov rcx, 12 ;i=256
.while: ; vynuluju pole na same nuly
    dec rcx ; i--
    mov [rbp-48+rcx*4], dword 0
    jnz .while ; priznakove bity nastavene na dekrementu

.back:
    cmp r8, rsi
    jge .end

    mov eax, [rdi+r8*4] ;aktualni cislo, co delim
    cdq
    idiv r9d
    movsx rdx, edx

    inc dword [rbp-48+rdx*4] ; zvednu hodnotu v poli na indexu, kteremu odpovida zbytek
    cmp r11d, [rbp-48+rdx*4]
    cmovl r11d, [rbp-48+rdx*4] ; maximalni pocet, kolikrat se zbytek vyskytl
    cmovl r10d, edx ;ulozim aktualni maximlni pozici zbytku

    inc r8
    jmp .back
.end:
    mov eax, r10d
    leave
    ret

;int count (int * arr, int t_len)
;                 rdi,       rsi,   rdx, rcx, r8, r9 ... rax, r10, r11
    global count
count:
    enter 16,0 ;budu potrebovat tri lokalni promene po 4 bytech
    mov r8, 0 ;i
    mov r9, 0 ;aktualni maximalni vyskyt
    mov eax, 0 ;vysledek
    movsx rsi, esi

.back:
    cmp r8, rsi
    jge .end

    mov edx, [rdi+r8*4]
    cmp edx, 0

    je .nula
    jl .mensi
    jg .vetsi

.nula:
    inc dword [rbp-4] ; na [rbp-4] je citac pro nuly
    mov r10d, dword 0
    cmp r9d, [rbp-4]
    cmovl r9d, [rbp-4]
    cmovl eax, r10d
    jmp .continue
.mensi:
    inc dword [rbp-8] ; na [rbp -8] je citac pro zaporna cisla
    mov r10d, dword -1
    cmp r9d, [rbp-8]
    cmovl r9d, [rbp-8]
    cmovl eax, r10d
    jmp .continue

.vetsi:
    inc dword [rbp - 12] ; na [rbp-12] je citac pro kladna cisla
    mov r10d, dword 1
    cmp r9d, [rbp-12]
    cmovl r9d, [rbp-12]
    cmovl eax, r10d

.continue:
    inc r8
    jmp .back
.end:
    leave
    ret

; char num_to_str (int t_num, char * t_rest, t_len)
;                        rdi,           rsi,   rdx, rcx, r8, r9 ... rax, r10, r11
    global num_to_str
num_to_str:
    enter 128,0 ;retezec
    mov ecx, 10 ;timle budu delit
    mov eax, edi  ;cislo, co budu delit
    mov r8,0
    mov r9,1 ; pomoci r9 budu testovat, jestli je zaporne

    cmp eax, 0
    jg .back
    mov r9,-1 ; cislo je zaporne
    imul r9 ;potrebuju to pak delit jako nezaporne cislo

.back:
    cmp ax, 0
    je .end

    cdq ;rozsireni na eax-rdx
    div ecx  ;osmi_bitovy vysledek v al

    add edx, byte '0' ; ke zbytku prictu '0'
    mov [rbp-128+r8], dl ; ulozim preveden cislo do pole

    inc r8
    jmp .back
.end:
    cmp r9,1
    je .continue
    mov [rbp-128+r8], byte '-'
    inc r8
.continue:
    mov r10, 0 ;citac znaku v retezci
    dec r8 ;musim zapisovat po zpatku
.prepis:
    cmp r8, 0
    jl .end2
    mov al, [rbp-128+r8] ;vezmu posledni prvek v poli a ulozim ho jako prvni ve stringu
                         ; nejdrive delim jednotky, ktere potrebuju zapsat jako posledni
    mov [rsi+r10], al

    inc r10;
    dec r8;

    jmp .prepis

.end2:
    mov [rsi+r10], byte 0  ;ukoncim retezec
    leave
    ret

;char vyskyt( char *str);
;                   rdi, rsi, rdx, rcx, r8, r9 ... rax, r10, r11
    global vyskyt
vyskyt:
    enter 1024,0 ; int arr [256] - mam 256 znaku v ascii tabulce

    mov rcx, 256 ;i=256
.while: ; vynuluju pole na same nuly
    dec rcx ; i--
    mov [rbp-1024+rcx*4], dword 0
    jnz .while ; priznakove bity nastavene na dekrementu

    mov rax, 0 ; ret
    mov rdx, 0 ; doacasne max - mam znaky-> musi byt kladne -> muzu ulozit 0
    mov rcx, 0 ;i=0

.back:
    cmp byte [rdi+rcx], 0
    je .end

    movzx rsi, byte [rdi+rcx] ; index =str[i]
    inc dword [rbp-1024+rsi*4] ;do pole vyskytu na pozici hodnota znaku*4 zvysim hodnotu

    cmp edx, [ rbp-1024+rsi*4] ;porovnavame aktualni maximum  s nove ziskanou hodnotou
    cmovl edx, [ rbp-1024+rsi*4] ; je mensi = dosadim hodnotu maxima
    cmovl rax, rsi ; ulozim, co za znak je nejcasteji

    inc rcx
    jmp .back
.end:
    leave
    ret

;long faktorial (long n)
;                   rdi, rsi, rdx, rcx, r8, r9 ... rax, r10, r11
    global faktorial
faktorial:
    enter 16,0 ; zasobnik se ma pohybovat po nasobcich 16

    mov rax, 1
    test rdi, rdi ;testuju, jestli je n 0
    jz .nula

    mov [rbp-8], rdi  ;na lokalni zasobnik ulozim puvodni hodnotu z rdi
    dec rdi ; snizim hodnotu rdi
    call faktorial ; ret faktorial (n-1)

    imul qword [rbp-8] ; n*faktorial (n-1)


.nula:
    leave
    ret
