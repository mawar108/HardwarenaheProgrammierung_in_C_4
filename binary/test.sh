#!/usr/bin/env bash

CFLAGS="-g -fsanitize=address -fsanitize=undefined -std=c99 -Wall -Wextra -Werror"
name="image"

# check codestyle
if ! ./codestyle.py
then
    printf "ERROR: Code style violation."
    exit 1
fi

# Compile program
if ! gcc $CFLAGS "$name.c" -o "$name"
then
    printf 'ERROR: Program could not be compiled.\n'
    exit 1
fi

function test_program() {
    input="$1"
    output="$2"

    # Limit stack size
    if ! ulimit -Ss 32
    then
        printf 'ERROR: The program "ulimit" does not appear to work on your computer..\n'
        exit 1
    fi

    "./$name" "$input" "$output"

    return_value="$?"

    # Reset stack size limit to default (probably 8192k)
    ulimit -Ss unlimited

    if [ $return_value -ne 0 ]
    then
        printf 'ERROR: The program failed (the return value was %s instead of 0).\n' "$return_value"
        exit 1
    fi
}

for i in 2 3 4
do
    test_program "input$i" "output$i.bmp"
done

if sha256sum -c checksums.txt
then
    printf 'OK: All checksums match.\n'
else
    printf 'ERROR: A file is different.\n'
    exit 1
fi

function test_program_args() {
    rm -f 'error.txt'
    
    echo "INFO: Running ./$name $@"
    
    if "./$name" "$@" 2> 'error.txt'
    then
        printf 'ERROR: Program should return a non-zero exit code if not passed exactly 2 files.\n'
        exit 1
    else
        printf 'OK: Program returned non-zero exit code when passed incorrect number of files.\n'
    fi
    
    if [ -s "error.txt" ]
    then
        printf 'OK: Program printed an error message for incorrect number of arguments.\n'
    else
        printf 'ERROR: Program should print an error message to stderr for incorrect number of arguments.\n'
        exit 1
    fi
}

test_program_args
test_program_args "input2"
test_program_args "input2" "output2.bmp" "output3.bmp"

mkdir -p input9
touch input10
printf 'INFO: Setting file input10 to non-readable. Make sure that your operating system does not ignore file permissions. You can use the command "ls -la" to check file permissions.\n'
chmod a-r input10

for i in 1 5 6 7 8 9 10 11
do
    if "./$name" "input$i" "output$i.bmp" 2> "error$i.txt"
    then
        printf 'ERROR: Program should print an error message to stderr for file %s.\n' "input$i"
        exit 1
    fi

    if [ -s "error$i.txt" ]
    then
        printf 'OK: Program printed an error message for file %s.\n' "input$i"
    else
        printf 'ERROR: Program should print an error message to stderr for file %s.\n' "input$i"
        exit 1
    fi
done

rm -f input10
