#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <getopt.h>

// Prices:
// - Bitcoin: 52586.02
// - Dogecoin: 0.27
// - Ethereum: 3590.12
// - Filecoin: 49.74
// - Monero: 227.73

double check_value(char *argument){
    char *endptr = NULL;
    double value = strtod(argument, &endptr);
    if (endptr == argument || value < 0 || endptr[0] != '\0')
    {
        fprintf(stderr, "Ungültiger Zahlenwert:%s !", argument);
        exit(3);
    }
    // printf("%c\n", endptr[0]);
    return value;
}



int main(int argc, char **argv){
    double total = 0.0;

    double Bitcoin= 52586.02;
    double Dogecoin= 0.27;
    double Ethereum= 3590.12;
    double Filecoin= 49.74;
    double Monero= 227.73;

    if ((argc - 1) % 2 != 0) {
        fprintf(stderr, "Zu wenige Parameter!");
        exit(1);
    }

    int c;

    while (1){
        struct option long_options[] =
            {
                {"bitcoin", required_argument, 0, 'b'},
                {"btc", required_argument, 0, 'b'},
                {"dogecoin", required_argument, 0, 'd'},
                {"doge", required_argument, 0, 'd'},
                {"ethereum", required_argument, 0, 'e'},
                {"eth", required_argument, 0, 'e'},
                {"filecoin", required_argument, 0, 'f'},
                {"fil", required_argument, 0, 'f'},
                {"monero", required_argument, 0, 'x'},
                {"xmr", required_argument, 0, 'x'},
                {"monero", required_argument, 0, 'm'},
                {0, 0, 0, 0}};

        int option_index = 0;

        c = getopt_long(argc, argv, "b:d:e:f:x:m:",
                        long_options, &option_index);

        /* Detect the end of the options. */
        if (c == -1)
            break;

        switch (c){
            case 'b':
                total += check_value(optarg) * Bitcoin;
                //total += check_value(optarg);
                break;

            case 'd':
                total += check_value(optarg) * Dogecoin;
                break;

            case 'e':
                total += check_value(optarg) * Ethereum;
                break;

            case 'f':
                total += check_value(optarg) * Filecoin;
                break;

            case 'x': case 'm':
                total += check_value(optarg) * Monero;
                break;

            case '?':
                fprintf(stderr, "Unbekannter Befehl!");
                exit(2);
                break;

            default:
                fprintf(stderr, "Irgendwas ist falsch :(");
                exit(2);
                break;
        }
    }

    printf("%.2f\n", total);
    return 0;
}
