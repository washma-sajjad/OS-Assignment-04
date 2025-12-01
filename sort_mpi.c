#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int cmpfunc(const void *a, const void *b) {
    double x = *(double*)a;
    double y = *(double*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(argc < 2) {
        if(rank==0) printf("Usage: %s <num_elements>\n", argv[0]);
        MPI_Finalize();
        return 1;
    }

    long n = atol(argv[1]);
    long local_n = n / size + (rank < n % size ? 1 : 0);
    double *local_data = malloc(sizeof(double) * local_n);

    // Seed random differently per process
    srand(rank + 1);
    for(long i=0;i<local_n;i++) local_data[i] = ((double)rand())/RAND_MAX;

    // Local sort
    qsort(local_data, local_n, sizeof(double), cmpfunc);

    // Gather sizes
    int *recvcounts = NULL;
    int *displs = NULL;
    double *sorted = NULL;

    if(rank==0){
        recvcounts = malloc(sizeof(int)*size);
        displs = malloc(sizeof(int)*size);
    }

    int local_count = local_n;
    MPI_Gather(&local_count,1,MPI_INT,recvcounts,1,MPI_INT,0,MPI_COMM_WORLD);

    if(rank==0){
        long total = 0;
        for(int i=0;i<size;i++) total += recvcounts[i];
        sorted = malloc(sizeof(double)*total);
        displs[0] = 0;
        for(int i=1;i<size;i++) displs[i] = displs[i-1] + recvcounts[i-1];
    }

    // Gather all sorted chunks to rank 0
    MPI_Gatherv(local_data, local_n, MPI_DOUBLE,
                sorted, recvcounts, displs, MPI_DOUBLE,
                0, MPI_COMM_WORLD);

    // Merge all chunks on rank 0
    if(rank==0){
        // Simple final sort (can be optimized)
        qsort(sorted, n, sizeof(double), cmpfunc);
        // Optional: print first 10 elements
        for(int i=0;i<10 && i<n;i++) printf("%f ", sorted[i]);
        printf("\n");
        free(sorted);
        free(recvcounts);
        free(displs);
    }

    free(local_data);
    MPI_Finalize();
    return 0;
}
