#include <stdio.h>
#include <stdint.h>

// secti dva inty
long sum_2int (int a, int b);
// over, jestli je dany zapis cislice
int is_digit(char c, char hex);
// secti int, long a char
long sum_lic(long a, int b, char c);
// secti prvky v poli
int suma_int_arr(int* arr, int d);
// spocti delku retezce
long str_len(char *s);
// najdi minimum a maximum v poli -> Vysledek vrat jako pole
void minmax_arr(int *arr, int n, int *minmax);
//bubble sort
void bubble (int *arr, int n);
// nastav bity na pozadovanych pozicich na 1
long set_bits(char *cisla_bitu, int len);
// prekopiruj retezec podle danych podminek
int copy_char(char *t_vysledek, char *t_predloha, char nahrada );
// over, ze retezec obsahuje cislp
int over_cislo(char* retezec);
// prepocti rousky
int rousky_prepocet(int pocet_rousek, int* vysledek);
// over, zda je dane cislo palindromem
int palindrom(char *string, int delka);
// posun naboje v zasobniku
int revolver (uint8_t naboje);
// prepocti cislo na osmickove
int chmod (int cislo);
int main() {

    printf("naboju je %d\n", revolver(20));
    printf("je palindrom %d\n", palindrom("ala", 3));
    int vysledek[2];
    rousky_prepocet(4, vysledek);
    printf("na 4 respiratory potrebujeme %d rousek a %d obleku\n", vysledek[0], vysledek[1]);
    char bity[]={1,2,3,54};
    printf("cislo je %lx\n",set_bits(bity,4));

    printf("cislo je %d\n", over_cislo("2_3"));

    char retezec[]="Toto Je RetezeC";
    char l_vysledek[1024];

    copy_char(l_vysledek,retezec,'_');
    printf("retezec: %s\n", l_vysledek);

    int arr[]={ 10,2,30,4,5,6};
    bubble(arr, 6);
    for (int i = 0; i < 6 ; ++i) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    char str[]="ahoj";
    int minmax[2];
    minmax_arr(arr,6, minmax);
    printf("max je %d a min %d\n",minmax[1], minmax[0] );
    printf("delka je %ld\n", str_len(str));
    printf("suma pole je %d\n", suma_int_arr(arr,6));
    printf("suma %ld\n", sum_lic(-100,2,3));
    printf("je znak %d\n", is_digit('5', 0));
    printf("je znak %d\n", is_digit('d', 1));
    printf("suma %ld\n", sum_2int(44, 222));
    printf("suma %ld\n", sum_2int(2000000000, 2000000000));
    return 0;
}
