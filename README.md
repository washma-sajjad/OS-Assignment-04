OS-Assignment-04

This repository contains implementations of sequential and parallel versions of Matrix Multiplication and Sorting Algorithms using Pthreads, OpenMP, and MPI. A Makefile and benchmarking scripts are included to automate compilation and performance testing.

Description

This assignment focuses on comparing different execution models by implementing:

Sequential Matrix Multiplication

Parallel Matrix Multiplication using Pthreads, OpenMP, and MPI

Sequential and Parallel Sorting Algorithms

Automated benchmarking for different input sizes

The project demonstrates concurrency concepts, build automation, and performance evaluation under multiple parallel programming frameworks.

Repository Structure

Makefile

Sequential matrix multiplication implementation

Pthreads matrix multiplication

OpenMP matrix multiplication

MPI matrix multiplication

Sequential sort

Pthreads sort

OpenMP sort

MPI sort

Benchmarking script

Matrix/data generation scripts

Results files (CSV)

How to Build and Run

Clone the repository:
git clone https://github.com/washma-sajjad/OS-Assignment-04.git

cd OS-Assignment-04

Compile all programs using:
make

Generate test input (matrices or arrays) if required.

Run benchmarks using the provided script:
./run_benchmarks.sh
or manually execute individual binaries.

View the results in the output CSV files or terminal output.

Learning Outcomes

Understanding thread-level and process-level parallelism

Using Pthreads, OpenMP, and MPI for parallel programming

Automating builds using Makefiles

Running and analyzing performance benchmarks

Comparing sequential vs parallel execution

Notes

Input sizes can be modified inside scripts/programs.

Additional matrix sizes or sorting inputs can be added easily.

Results may vary depending on CPU cores and MPI configuration.

Author

Repository created by Washma Sajjad for OS Assignment-04.
