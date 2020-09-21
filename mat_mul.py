#!/usr/bin/env python

############################
# imports and arg processing
############################

# grab sys and timing modules
import sys
from time import time

# pull user input
if len(sys.argv) < 2 or len(sys.argv) > 4:
    print("Usage: ./mat_mul.py [-v] N [t]")
    print("")
    print("  N: vector system is size 2^N (accept int,float)")
    print("  t: number of threads (optional, accept int)")
    print(" -v: use vectorized matrix multiply (optional)")
    sys.exit(0)

# check if to use vectorized mat mul
vec = sys.argv[1] == '-v'

# arg number for system size and threads
nArg = 2 if vec else 1
tArg = 3 if vec else 2

# set number of threads if provided
userThreads = len(sys.argv) > tArg
if userThreads:
    nt = int(sys.argv[tArg])
else:
    nt = -1

# if vectorized, pass thread number through
# OMP environment variable
if nt > 0 and vec:
    from os import environ
    environ['OMP_NUM_THREADS']=str(nt)

# ^ that has to happen before imports
import joblib as jl
import numpy as np

###################
# system allocation
###################

# set system size
N = int(2.**float(sys.argv[nArg]))

# create random vector and matrix
v = np.random.randn(N,1)
M = np.random.randn(N,N)

#############################
# helper function definitions
#############################

# function for dotting a matrix row and the in-vector
def dot(r):

    # grab reference to matrix and vector
    global M
    global v

    # loop over matrix columns
    total = 0.
    for i in range(N):
        total = total + M[r,i]*v[i]

    # return dot product
    return total

# function for parallel matrix multiplication
def mat_mul(nt):

    # generator for components of dot product
    #
    # each iterate of comps holds a pointer to the
    # dot function and the argument to pass (row index)
    comps = (jl.delayed(dot)(r) for r in range(N))

    # calculate components by forking rows
    out = jl.Parallel(n_jobs=nt)(comps)

    # wrap in numpy object
    return np.array(out)

###############
# actual timing
###############

# min time for testing
Tmin = 1
T = 0

# do mat muls until minimum time is reached
iters = 0
t0 = time()
while T < Tmin:

    # use vectorized or parallelized
    # function as specified
    if not vec:
        w = mat_mul(nt)
    else:
        w = M.dot(v)

    # record time and count iterate
    T = time()-t0
    iters = iters+1

# print output
print("{:g}".format(T/iters))
