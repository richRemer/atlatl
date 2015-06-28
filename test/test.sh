#!/bin/bash -e

TEST_DIR=`dirname $0`

for TEST in *.test; do
    echo Begin test: $TEST
    while read STATUS CASE OUT
    do
        WORKING_DIR=`mktemp -d`

        cp $TEST_DIR/$CASE $WORKING_DIR/test_case.asm
        cp $TEST_DIR/test.asm $WORKING_DIR
        cp <(cat $TEST_DIR/../atlatl/Makefile | sed -e s/atlatl/test_case/) \
            $WORKING_DIR/Makefile
        cp $TEST_DIR/../atlatl/*.asm $WORKING_DIR
        cp $TEST_DIR/../atlatl/*.inc $WORKING_DIR
        rm $WORKING_DIR/atlatl.asm

        pushd $WORKING_DIR >/dev/null
        make -s
        ERR=0
        OUT_ERR=
        ./test_case >/dev/null || ERR=$?
        [ -n "$OUT" ] && ./test_case | grep "$OUT" >/dev/null || OUT_ERR=$OUT
        popd >/dev/null

        [ $ERR -ne $STATUS ] \
            && echo "$CASE - expected $STATUS; got $ERR" >&2 && exit 1

        [ -n "$OUT_ERR" ] \
            && echo "$CASE - expected output $OUT" >&2 && exit 1

        echo $CASE - ok

        rm -rf $WORKING_DIR
    done < $TEST
done
