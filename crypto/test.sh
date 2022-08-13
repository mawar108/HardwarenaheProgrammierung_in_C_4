#!/usr/bin/env bash

CFLAGS="-g -fsanitize=address -fsanitize=undefined -std=c99 -Wall -Wextra -Werror"
name="crypto"

# check codestyle
if ! ./codestyle.py
then
    printf "ERROR: Code style violation."
    exit 1
fi

printf '\n'

# Compile program
if ! gcc $CFLAGS "$name.c" -o "$name"
then
    printf 'ERROR: Program could not be compiled.\n'
    exit 1
fi

function test_program() {
    output="$1"
    expected="$2"

    printf '\n'
    echo "./$name" "${@:3}"

    if ! "./$name" ${@:3} > "$output"
    then
        printf 'ERROR: The program failed.\n'
        exit 1
    fi

    cat "$output"
    printf '\n'

    if diff -yq "$output" "$expected"
    then
        printf 'OK: Output %s matches expected output %s.\n' "$output" "$expected"
    else
        printf 'ERROR:\nExpected output:\n\n'
        cat "$expected"
        printf '\nActual output:\n\n'
        cat "$output"
        exit 1
    fi
}

test_program "files/output_1_bitcoin.txt"            "files/expected_output_one_bitcoin.txt" "--bitcoin" 1
test_program "files/output_1.0_bitcoin.txt"          "files/expected_output_one_bitcoin.txt" "-b" 1.0
test_program "files/output_1.00_bitcoin.txt"         "files/expected_output_one_bitcoin.txt" "--bitcoin" 1.00
test_program "files/output_1.000000000_bitcoin.txt"  "files/expected_output_one_bitcoin.txt" "--bitcoin" 1.000000000
test_program "files/output_0.5_plus_0.5_bitcoin.txt" "files/expected_output_one_bitcoin.txt" "--bitcoin" 0.5 "--bitcoin" 0.5
test_program "files/output_100_doge.txt"             "files/expected_output_100_doge.txt"    "--doge" 100
test_program "files/output_0.01_xmr.txt"             "files/expected_output_0.01_xmr.txt"    "--xmr" 0.01
test_program "files/output_1_filecoin.txt"           "files/expected_output_1_filecoin.txt"  "--filecoin" 1.0
test_program "files/output_1_ethereum.txt"           "files/expected_output_1_ethereum.txt"  "--ethereum" 1.0
test_program "files/output_zero.txt"                 "files/expected_output_zero.txt"
test_program "files/output_0_btc.txt"                "files/expected_output_zero.txt"        "--btc" 0.0
test_program "files/output_all.txt"                  "files/expected_output_all.txt" "--bitcoin" 1 "--btc" 1 "-b" 1 "--dogecoin" 1 "--doge" 1 "-d" 1 "--ethereum" 1 "--eth" 1 "-e" 1 "--filecoin" 1 "--fil" 1 "-f" 1 "--monero" 1 "--xmr" 1 "-x" 1 "-m" 1
test_program "files/output_random.txt"                "files/expected_output_random.txt" --monero 7.57954 --btc 258.91675 -m 0.04049 -m 0.00358 --doge 0.00003 -e 987.25920 --doge 0.00003 --fil 0.00005 -f 4341.71835 --ethereum 96.66064 -x 0.08653 --btc 805.02783 --bitcoin 0.93272 --bitcoin 0.61190 --eth 0.00007 --ethereum 0.00917 --eth 0.00080 -x 0.09122 -m 109.05785 --filecoin 706.56141


function test_program_error() {
    expected_error_code="$1"

    stderrfile="files/stderr.txt"

    printf '\n'
    echo "./$name" "${@:2}"

    "./$name" "${@:2}" 2> "$stderrfile"
    return_value=$?

    if [ $return_value -eq "$expected_error_code" ]
    then
        printf '\tOK: Return value is %s as expected.\n' "$expected_error_code"
    else
        printf '\tERROR: Return value should be %s, but is %s instead.\n\n' "$expected_error_code" "$return_value"
        exit 1
    fi

    if [ -s "$stderrfile" ]
    then
        printf '\tOK: Something has been written to stderr.\n'
    else
        printf '\tERROR: No error message has been written to stderr.\n'
        exit 1
    fi
}

test_program_error 1 --btc
test_program_error 1 --ethereum 1 --doge
test_program_error 1 --btc
test_program_error 1 --btc
test_program_error 2 --potato 1
test_program_error 2 --bitcoin 1 --seashells 5
test_program_error 3 --bitcoin seven
test_program_error 3 --bitcoin --bitcoin

