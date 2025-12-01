# **OS-Assignment-04**

This repository contains implementations of **Sequential** and **Parallel** versions of **Matrix Multiplication** and **Sorting Algorithms** using **Pthreads**, **OpenMP**, and **MPI**. It also includes a **Makefile** and **benchmarking scripts** to automate compilation and performance testing.

---

## **📘 Description**

This assignment explores multiple execution models by implementing:

- **Sequential Matrix Multiplication**
- **Pthreads Matrix Multiplication**
- **OpenMP Matrix Multiplication**
- **MPI Matrix Multiplication**
- **Sequential Sorting Algorithm**
- **Parallel Sorting Algorithms** (Pthreads, OpenMP, MPI)
- **Automated Benchmarking Scripts**

The goal is to compare **performance**, **speedup**, and **scalability** across all implementations.

---

## **📂 Repository Structure**

- **Makefile**  
- **sequential.c** – Sequential matrix multiplication  
- **pthread.c** – Pthreads-based matrix multiplication  
- **omp.c** – OpenMP-based matrix multiplication  
- **mpi.c** – MPI-based matrix multiplication  
- **sort_seq.c** – Sequential sorting  
- **sort_pthread.c** – Pthreads sorting  
- **sort_omp.c** – OpenMP sorting  
- **sort_mpi.c** – MPI sorting  
- **run_benchmarks.sh** – Benchmark automation  
- **Matrix/data generation scripts**  
- **Results CSV files**

---

## **🚀 How to Build & Run**

### **1. Clone the repository**
```bash
git clone https://github.com/washma-sajjad/OS-Assignment-04.git
cd OS-Assi
