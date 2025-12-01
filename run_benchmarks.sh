#!/usr/bin/env bash
set -euo pipefail

OUT=results.csv
mkdir -p data bin

echo "impl,rowsA,colsA,rowsB,colsB,run,real_s,user_s,sys_s,maxrss_kb" > $OUT

SMALL_SIZES=("5x4" "10x10" "500x500")
LARGE_SIZES=("1000x1000" "2000x2000")  # adjust for your RAM

gen_matrix(){
    local rows=$1
    local cols=$2
    local file=$3
    echo "Generating matrix $rows x $cols -> $file"
    ./gen_matrix.py $rows $cols > $file
}

# Separate run functions for clarity
run_matrix_binary(){
    local impl=$1
    local A=$2
    local B=$3
    local rowsA=$4
    local colsA=$5
    local rowsB=$6
    local colsB=$7
    local run=${8:-1}

    if [ ! -x "$impl" ]; then
        echo "Missing $impl"
        return
    fi

    out=$( { /usr/bin/time -v "$impl" "$A" "$B" 2>&1 1>/dev/null; } )
    real=$(echo "$out" | awk -F': ' '/Elapsed \(wall clock\) time|real/ {print $NF}' | head -n1)
    user=$(echo "$out" | awk -F': ' '/User time/ {print $2}' | head -n1)
    sys=$(echo "$out" | awk -F': ' '/System time/ {print $2}' | head -n1)
    maxrss=$(echo "$out" | awk -F': ' '/Maximum resident set size/ {print $2}' | head -n1)
    real=${real:-NA}; user=${user:-NA}; sys=${sys:-NA}; maxrss=${maxrss:-NA}

    echo "$(basename $impl),$rowsA,$colsA,$rowsB,$colsB,$run,$real,$user,$sys,$maxrss" >> $OUT
}

run_sort_binary(){
    local impl=$1
    local n=$2
    local run=${3:-1}

    if [ ! -x "$impl" ]; then
        echo "Missing $impl"
        return
    fi

    out=$( { /usr/bin/time -v "$impl" "$n" 2>&1 1>/dev/null; } )
    real=$(echo "$out" | awk -F': ' '/Elapsed \(wall clock\) time|real/ {print $NF}' | head -n1)
    user=$(echo "$out" | awk -F': ' '/User time/ {print $2}' | head -n1)
    sys=$(echo "$out" | awk -F': ' '/System time/ {print $2}' | head -n1)
    maxrss=$(echo "$out" | awk -F': ' '/Maximum resident set size/ {print $2}' | head -n1)
    real=${real:-NA}; user=${user:-NA}; sys=${sys:-NA}; maxrss=${maxrss:-NA}

    echo "$(basename $impl),NA,NA,NA,NA,$run,$real,$user,$sys,$maxrss" >> $OUT
}

# --- Small sizes ---
for size in "${SMALL_SIZES[@]}"; do
    IFS='x' read -r R C <<< "$size"
    rowsA=$R; colsA=$C; rowsB=$C; colsB=$R
    A=data/mat_${rowsA}_${colsA}_A.txt
    B=data/mat_${rowsB}_${colsB}_B.txt

    gen_matrix $rowsA $colsA $A
    gen_matrix $rowsB $colsB $B

    for impl in bin/seq bin/omp bin/thread2; do
        for run in 1 2 3; do
            run_matrix_binary $impl $A $B $rowsA $colsA $rowsB $colsB $run
        done
    done

    n=$((rowsA*colsA))
    for sbin in bin/sort_seq bin/sort_pthread bin/sort_omp; do
        for run in 1 2 3; do
            run_sort_binary $sbin $n $run
        done
    done
done

# --- Large sizes ---
for size in "${LARGE_SIZES[@]}"; do
    IFS='x' read -r R C <<< "$size"
    rowsA=$R; colsA=$C; rowsB=$C; colsB=$R
    A=data/mat_${rowsA}_${colsA}_A.txt
    B=data/mat_${rowsB}_${colsB}_B.txt

    gen_matrix $rowsA $colsA $A
    gen_matrix $rowsB $colsB $B

    for impl in bin/seq bin/omp bin/thread2; do
        run_matrix_binary $impl $A $B $rowsA $colsA $rowsB $colsB 1
    done

    n=$((rowsA*colsA))
    for sbin in bin/sort_seq bin/sort_pthread bin/sort_omp; do
        run_sort_binary $sbin $n 1
    done
done

echo "Benchmark complete. Results saved to $OUT"
