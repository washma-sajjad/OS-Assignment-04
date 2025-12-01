#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int cmp(const void *a,const void *b){
    double x=*(double*)a, y=*(double*)b;
    return (x<y)?-1:(x>y)?1:0;
}

int main(int argc,char **argv){
    int n = (argc>1)?atoi(argv[1]):1000000;
    double *a = malloc(sizeof(double)*n);

    for(int i=0;i<n;i++) a[i]=drand48();

    struct timespec s,e; 
    clock_gettime(CLOCK_MONOTONIC,&s);
    qsort(a,n,sizeof(double),cmp);
    clock_gettime(CLOCK_MONOTONIC,&e);

    double secs = (e.tv_sec-s.tv_sec) + (e.tv_nsec-s.tv_nsec)/1e9;
    printf("SEQ SORT n=%d time=%f\n", n, secs);

    free(a);
    return 0;
}
