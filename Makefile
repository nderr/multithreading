execs: mat_mul

cxx=g++

-include "Makefile.hb"
-include "Makefile.mp"

mat_mul: mat_mul.cc
	$(cxx) -fopenmp -O3 -o $@ $<
