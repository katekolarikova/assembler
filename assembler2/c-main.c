#include <stdio.h>


long faktorial (long n);
char vyskyt( char *str);

//prevde retezec na string
void num_to_str(int t_num, char *t_res); //funguje X ne pro 0
//spocita, kolik je vpoli kladnych, zapornych a nul
int count (int * arr, int t_len); //funguje
//rozdeli retezec na velka a mala pismena a nakopiruja ta, kterych je vice
int split_str(  char *t_str ); // funguje
//spocita, jaky nejcastejsi zbytek po deleni vznikl
int count_modulo( int *t_array, int t_len ); //funguje
//vzberu jen cislice a pokud bude mezi nimi jedna konkretni, nakopiruju je zpatky
void digits( char *t_str, char t_digit); //funguje
//nharadi tecku v retezci dvema hvezdickama
void replace(char *t_str); //funguje
//rozdelim kladna a zaporna cisla zpatky nakopiruju ta, kterych bude vice
int split( int *t_array, int t_len ); //funguje
//zkontroluju, kterych bitu je v retezci nejvice
int check_bits (int *arr, int len); //funguje
//nahhradi znak v retezci vybranou posloupnosti
void posloupnosti(char *str); //funguje
//spocita, slovo jake delky se v retzci vyskytuje nejcasteji
int slova (char * slova); //funguje

int main() {
    char delka_slova[]={"toto je test ale tr ed."};
    printf("nejcastejsi se zde vyskytuje slovo delky %d\n", slova(delka_slova));

    char posloupnost[128]={"vmd"};
    posloupnosti(posloupnost);
    printf("retezec s posloupnosti je %s\n", posloupnost);

    int pole_k_testovani[]={9,13,2};
    printf("nejcastejsi vyskyt je na pozici %d\n",check_bits(pole_k_testovani,3));

    int pole_cisel []={0,1,0,0, 0,-6};
    int nova_delka=split(pole_cisel, 6);
    printf("nove pole je : ");
    if (nova_delka==0)
    {
        nova_delka=6;
    }
    for (int i = 0; i < nova_delka; ++i) {
        printf("%d ", pole_cisel[i] );
    }
    printf("\n");
    char velka_mala[]={"aScDFvv"};
    split_str(velka_mala);
    printf("prepsany retezec je '%s'\n",velka_mala);
    char to_replace[256]={"as.cs."};
    replace(to_replace);
    printf("nahrazeny retezec je %s\n", to_replace);

    char str_digits[]={"12ed24ds?"};
    digits(str_digits,'4');
    printf("reteyec je %s\n",str_digits);

    int arr_modulo[]= {10, 21,31,44,65, 55, 45};
    printf("nejcastejsi zbytek je %d\n", count_modulo(arr_modulo,7));

    int arr_klzapnul[]={-3,0,2,2,1};
    // totalne wtf chovani
    printf("v retezci je nejvice %d\n", count(arr_klzapnul,5));

    char t_ret[128];
    num_to_str(160, t_ret);
    printf("prevedene '%s'\n",t_ret );

    char ret[]="jduunauseveruuuyujdu na jih, jdu na sever a uy jdu na jih";
    printf("vyskyt '%c'\n", vyskyt(ret));

    printf("faktorial %ld\n", faktorial(10));

    return 0;
}
