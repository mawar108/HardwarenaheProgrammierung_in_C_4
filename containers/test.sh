#!/usr/bin/env bash

CFLAGS="-g -fsanitize=address -fsanitize=undefined -std=c99 -Wall -Werror -Wextra"
name="containers"

# check sums
if ! sha1sum --quiet -c checksums.txt
then
    printf "FEHLER: Die Testdateien wurden veraendert!\n."
    exit 1
fi
printf "OK: Pruefsummen sind korrekt.\n"


# check codestyle
if ! ./codestyle.py
then
    printf "FEHLER: Der Codestyle entspricht nicht den Vorgaben."
    exit 1
fi
printf "OK: Codestyle Ueberpruefung bestanden.\n"

# Compile program
if ! gcc $CFLAGS "$name.c" -o "$name"
then
    printf 'FEHLER: Programm konnte nicht kompiliert werden.\n'
    exit 1
fi
printf "OK: Programm erfolgreich kompiliert.\n"

function test_program() {
    testname="$1"
    stdin_parameter="$2"
    cmd="./$name "
    if [ "$stdin_parameter" = "1" ]
    then
        cmd+="-- warehouse/$testname < container/$testname"
    elif [ "$stdin_parameter" = "2" ]
    then
        cmd+="container/$testname -- < warehouse/$testname"
    else
        cmd+="container/$testname warehouse/$testname"
    fi
    cmd+=" 2> output/stderr"
    rm -f output/*
    eval $cmd
    ret=$?
    if [ $ret -ne 0 ] && [ $ret -ne 42 ]
    then
        printf "FEHLER: Programm ist nicht erfolgreich durchgelaufen (der Rückgabewert ist nicht 0 oder 42 sondern $ret).\n"
        printf "        $cmd\n"
        printf "        Siehe 'output/stderr'\n"
        exit 1
    fi
    if ! diff -yZ output expected/$testname --exclude ".gitignore" > diffs
    then
        printf "FEHLER: Test $testname fehlgeschlagen mit dem Befehl\n"
        printf "        $cmd\n"
        printf "        Fuer Details siehe Datei 'diffs'\n"
        exit 1
    fi

}

for test in example test1 test2 test3 empty_containers empty_warehouses empty_both long_containers long_warehouses long_both
do
    for stdin_parameter in 0 1 2
    do
        test_program $test $stdin_parameter
    done
done
printf "OK: Alle statischen Tests bestanden\n"

for test in many_containers many_warehouses many_both
do
    expected="expected/$test"
    rm -rf "$expected"
    mkdir "$expected"
    touch "$expected/stderr"
    ./generate_expected.py $test
    for stdin_parameter in 0 1 2
    do
        test_program $test $stdin_parameter
    done
    rm -rf "$expected"
done
printf "OK: Alle dynamischen Tests bestanden\n"
rm -f output/*
