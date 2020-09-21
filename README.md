# Intro to Multithreading
## AM205 Fall 2020 group activity

In this repository, you'll find sample scripts illustrating concepts from the Intro to Multithreading group activity.

### Matrix multiplication
- mat_mul.cc and mat_mul.py are C++ and Python implementations of matrix multiplication using shared memory parallelization. Each takes two arguments: N, such that the system size of the multiplication is 2^N, and t, the number of threads to parallelize over.
- running "make" will generate the executable "./mat_mul" representing the C++ implementation. If you are running on a Mac, you will need to install a C++ compiler with OpenMP support from Homebrew or MacPorts. If you are running on Linux, the default Gnu compiler should work out of the box. To run the C++ implementation, run "./mat_mul N t"
- running the python script ./mat_mul.py requires the numpy and joblib libraries to be installed. Both can be installed using your preferred package manager (pip, conda, system package managers e.g. pacman, apt, etc.). To run the script, call "./mat_mul.py [-v] N t". The optional argument "-v" switches from for-looping code parallelized with joblib to a vectorized implementation using numpy and OpenMP.
