#!/usr/bin/env bash

# grab user input
if [ $# -lt 1 -o $# -gt 2 ]; then
	echo "Usage: ./mat_mul.sh sys [num_threads]"
	echo ""
	echo "  sys=0: C++"
	echo "  sys=1: python (for loops)"
	echo "  sys=2: python (vectorized)"
	echo "  sys=3: python (vectorized,OMP)"
	exit 0
fi

# get sim type
sim=$1

# set sim-specific parameter
case $sim in
0)	OUT=out_mat_mul_cc
	EXEC=./mat_mul
	N0=6
	NF=10
	NS=2
	;;
1)	OUT=out_mat_mul_py
	EXEC=./mat_mul.py
	N0=6
	NF=10
	NS=2
	;;
2)	OUT=out_mat_mul_py_v
	EXEC="./mat_mul.py -v"
	N0=6
	NF=10
	NS=2
	;;
esac

# number of threads
if [ $# -eq 2 ]; then NTHR=$2; else NTHR=12; fi

# remove outfile
rm -f $OUT

# loop over vector lengths
for N in `seq $N0 $NS $NF`; do

	# record vector length
	echo "\"N = $((2**$N))\"" >> $OUT

	# loop over thread counts
	for thr in `seq 1 $NTHR`; do

		# record time for mat multiply
		time=$($EXEC $N $thr)

		# replace scientific notation with
		# decimal form for passing to bc
		timeD="(${time/e/*10^})"


		# store t0 (i.e. time with one thread)
		if [ $thr -eq 1 ]; then t0=$timeD; fi

		# calculate effective time (i.e. time * threads)
		timeE=$(echo "scale=8; $timeD * $thr" | bc -l)

		# calculate efficiency (t0 / (time * threads))
		eff=$(echo "scale=8; $t0 / $timeE" | bc -l)

		# print to file and to output
		echo "$N $thr $time $eff" >> $OUT
		echo "$N $thr $time $eff"
	done

	# drop newlines in file for gp indices
	echo "" >> $OUT
	echo "" >> $OUT
done
