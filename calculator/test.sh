#!/usr/bin/env bash

CFLAGS="-g -fsanitize=address -fsanitize=undefined -std=c99 -Wall -Wextra -Werror"

# Compile program
if ! gcc $CFLAGS calculator.c -o calculator
then
    printf 'ERROR: Program could not be compiled.\n'
    exit 1
fi

./calculator '*' 2 3 0.5 chicken > 2_times_3_times_0.5.txt
./calculator '+' 2 3 duck 3.5 > 2_plus_3_plus_3.5.txt

if diff -yw expected_2_times_3_times_0.5.txt 2_times_3_times_0.5.txt
then
    printf 'OK: 2 * 3 * 0.5 is 3.00000.\n'
else
    printf 'ERROR: Output is incorrect.'
    exit 1
fi

if diff -yw expected_2_plus_3_plus_3.5.txt 2_plus_3_plus_3.5.txt
then
    printf 'OK: 2 + 3 + 3.50 is 8.50000.\n'
else
    printf 'ERROR: Output is incorrect.'
    exit 1
fi
