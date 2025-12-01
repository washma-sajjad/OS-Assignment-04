#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int cmp(const void *a,const void *b){
    double x=*(double*)a, y=*(double*)b;
    return (x<y)?-1:(x>y)?1:0;
}

int main(int argc,char **argv){
    int n = (argc>1)?atoi(argv[1]):1000000;
    double *a = malloc(sizeof(double)*n);

    #pragma omp parallel
    {
        unsigned int seed = omp_get_thread_num();
        #pragma omp for
        for(int i=0;i<n;i++)
            a[i] = rand_r(&seed)/(double)RAND_MAX;
    }

    double t0 = omp_get_wtime();
    qsort(a,n,sizeof(double),cmp);
    double t1 = omp_get_wtime();

    printf("OMP SORT n=%d threads=%d time=%f\n",
           n, omp_get_max_threads(), t1-t0);

    free(a);
    return 0;
}
