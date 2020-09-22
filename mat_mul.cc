#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <random>
#include <omp.h>

/**
 * Performs a matrix multiplication of a random matrix times
 * a random vector of length 2^N, using t threads
 *
 * @param[in] N log_2(system size)
 * @param[in] t number of OMP threads
 */
int main(int argc,char** argv) {

	// check user input
	if (argc < 2 || argc > 3) {
		puts("Usage: ./dot_product N [t]\n");
		puts("  N: vector system is size 2^N (accept int,float)");
		puts("  t: number of OMP threads (optional, accept int)");
		exit(0);
	}

	// set OMP thread num
	int nt=1;

	// only do this part if we've compiled with OpenMP
#if _OPENMP

	if (argc==3) {

		// if we have three args, user has specified nt
		nt = atoi(argv[2]);
	} else {

		// otherwise, use default from OMP_NUM_THREADS
		nt = omp_get_max_threads();
	}
#endif

	// normal distribution mean and standard dev
	static const double mu=0;
	static const double sigma=1;

	// min T for timing purposes
	static const double Tmin=0.5; // half second

	// set up rng and normal distribution
	static const int seed=0; // for reproducibility
	std::default_random_engine rng(seed);
	std::normal_distribution<double> dist(mu,sigma);

	// pull in vector size, allocate two vectors and a matrix
	int N = pow(2,atof(argv[1]));
	double *v = new double[N];
	double *w = new double[N];
	double *M = new double[N*N];

	// fill vectors/matrix with random values
#pragma omp parallel for num_threads(nt)
	for(int i=0;i<N;i++) {
		w[i] = 0;
		v[i] = dist(rng);
		for(int j=0;j<N;j++) M[i+j*N]=dist(rng);
	}

	// perform matrix multiplication
	double t0 = omp_get_wtime(),T=0;
	int iters=0;

	// do matrix multiplies for a speficied time
	while (T<Tmin) {

		// loop over rows of out vector
#pragma omp parallel for num_threads(nt)
		for(int r=0;r<N;r++) {
			for (int c=0;c<N;c++) {
				w[r] += M[c+r*N] * v[c];
			}
		}

		T = omp_get_wtime()-t0; //update time
		iters++;                // count iterations
	}

	// print time per mat mult
	printf("%g\n",T/iters);

	// cleanup vectors, matrix
	delete[] v;
	delete[] w;
	delete[] M;
}
