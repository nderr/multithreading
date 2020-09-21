# Intro to Multithreading
## AM205 Fall 2020 group activity

In this repository, you'll find sample scripts illustrating concepts from the Intro to Multithreading group activity.

### Core usage visualization
- I highly recommend installing the utility [__htop__](https://htop.dev/). It graphically shows real-time usage of each core on your system.

### Matrix multiplication example
- __mat_mul.cc__ and __mat_mul.py__ are C++ and Python implementations of matrix multiplication using shared memory parallelization. Each takes two arguments:
    - N, such that the system size of the multiplication is 2^N
    - t, the number of threads to parallelize over
- C++
    - running "make" will generate the executable __./mat_mul__ representing the C++ implementation.
    - if you are running on a Mac, you will need to install a C++ compiler (preferably gcc10) with OpenMP support from [https://macports.org](MacPorts) or [https://brew.sh](Homebrew). There is a tutorial [here](http://www.mathcancer.org/blog/setting-up-gcc-openmp-on-osx-homebrew-edition/).
        - After install, run __cp ./.Makefile.hb Makefile.hb__ or __cp ./.Makefile.mp Makefile.mp__ depending on which one you installed. I should have the Makefile set up to work after that; if it's still not compiling, let me know.
    - If you are running on Linux, the default Gnu compiler will work out of the box.
    - to run the C++ implementation, call __./mat_mul N t__.
- Python
    - running the python script __./mat_mul.py__ requires the numpy and joblib libraries to be installed. Both can be installed using your preferred package manager (pip, conda, system package managers e.g. pacman, apt, etc.)
    - to run the python script, call __./mat_mul.py [-v] N t__. The optional argument "-v" switches from for-looping code parallelized with joblib to a vectorized implementation using numpy and OpenMP.
- Data output and plotting
    - __mat_mul.sh__ is a bash script which loops over several values of N and t while calling __./mat_mul__, __./mat_mul.py__, or __./mat_mul.py -v__. It writes output to a series of output files in the form of four columns (N t time efficiency). Each group of N is separated by two newlines and labeled so that they can be plotted using gnuplot's index keywork
    - __plot.gp__ is a gnuplot script reading in the out files produced by __./mat_mul.sh__ and producing a png __threading.png__ as shown in the slides.
    - You don't need to run these if you don't want; I'm just including them for you to play around with if you'd like.
