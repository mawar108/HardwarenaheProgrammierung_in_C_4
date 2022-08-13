#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Extend this program to sum numbers with '+'

double compute_product(int argc, const char *argv[]){
    double product = 1.0;

    for (int i = 0; i < argc; i++){
        char *endptr = NULL;

        // Convert string to double
        double value = strtod(argv[i], &endptr);

        // Skip value if conversion failed
        if (endptr == argv[i]){
            fprintf(stderr, "Skipping %s (not a number).\n", argv[i]);
            continue;
        }

        product *= value;
    }

    return product;
}

int main(int argc, const char *argv[]){
    // Print command line arguments.
    // The first argument is the program name.
    // The other arguments are the passed parameters.
    for (int i = 0; i < argc; i++){
        fprintf(stderr, "Command line argument %i is: %s\n", i, argv[i]);
    }
    fprintf(stderr, "\n");

    if (argc < 2){
        fprintf(stderr, "ERROR:\n"
            "\tToo few parameters passed to program.\n"
            "\tTry this instead:\n"
            "\t\t./calculator + 1 2 3\n\n");
        return EXIT_FAILURE;
    }

    const char *operator = argv[1];

    // Skip program name and operator by moving pointer forward by two
    argv += 2;
    argc -= 2;

    // Check which operator we are dealing with here.
    if (0 == strcmp(operator, "*")){
        double product = compute_product(argc, argv);

        printf("%.5f\n", product);
    }else{
        fprintf(stderr, "ERROR: Invalid operator: %s\n", operator);
        return EXIT_FAILURE;
    }

    return 0;
}
