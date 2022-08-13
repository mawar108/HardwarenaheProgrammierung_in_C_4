#include <stdio.h>
#include <stdlib.h>

#define UNKNOWN_ID_STRING "ERROR: Harbour ID %d unknown. Container %s could not be assigned!\n"
#define EXIT_MISSING_WAREHOUSE 42

typedef struct Warehouse{
    size_t number;
    char name [101];
}Warehouse;

typedef struct Container{
    char name[101];
    size_t warehouseNumber;
}Container;