#include "containers.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <getopt.h>


int main(int argc, char *argv[])
{
    //fgets(word, sizeof(word), stdin);
    FILE *file1 = NULL;
    FILE *file2 = NULL;
    Container *containers = malloc(sizeof(Container));
    Warehouse *warehouses = malloc(sizeof(Warehouse));
    Container  container;

    //container
    if (strcmp("--", argv[1]) != 0){
        // printf("%s\n", argv[1]);
        char *fileName1 = argv[1];
        file1 = fopen(fileName1, "r");
        char *str;
        char c;
        size_t indicator = 1;
        size_t counter = 0;
        while (scanf("%s", str) != EOF) {
            containers = realloc(containers, sizeof(Container) * (counter + 1));
            if(indicator == 1){
                containers[counter].warehouseNumber = str;

                indicator = 2;
            }
            if(indicator == 2){
                containers[counter].warehouseNumber = str;

                indicator = 1
            }
        }

    //warehouse
    if (strcmp("--", argv[2]) != 0){
        char *fileName2 = argv[2];
        file1 = fopen(fileName2, "r");
    }


    //container
    if(strcmp("--", argv[1]) == 0){
        //printf("yes1\n");
        //fgets();
    } 

    //warehouse
    if (strcmp("--", argv[2]) == 0){
        //printf("yes2\n");
        //fgets
    }
    





    if(file1 != NULL){
        fclose(file1);
    }
    if (file2 != NULL){
        fclose(file2);
    }

    return 0;
}
