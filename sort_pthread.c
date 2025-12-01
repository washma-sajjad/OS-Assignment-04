#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

typedef struct{
    double *arr;
    int start;
    int len;
} task_t;

int cmp(const void *a,const void *b){
    double x=*(double*)a, y=*(double*)b;
    return (x<y)?-1:(x>y)?1:0;
}

void *worker(void *arg){
    task_t *t=(task_t*)arg;
    qsort(t->arr + t->start, t->len, sizeof(double), cmp);
    return NULL;
}

int main(int argc,char **argv){
    int n = (argc>1)?atoi(argv[1]):1000000;
    int T = (argc>2)?atoi(argv[2]):4;

    double *a = malloc(sizeof(double)*n);
    for(int i=0;i<n;i++) a[i]=drand48();

    pthread_t threads[T];
    task_t tasks[T];
    int chunk = n / T;

    struct timespec s,e;
    clock_gettime(CLOCK_MONOTONIC,&s);

    for(int i=0;i<T;i++){
        tasks[i].arr = a;
        tasks[i].start = i*chunk;
        tasks[i].len = (i==T-1)? (n - i*chunk) : chunk;
        pthread_create(&threads[i], NULL, worker, &tasks[i]);
    }

    for(int i=0;i<T;i++)
        pthread_join(threads[i], NULL);

    clock_gettime(CLOCK_MONOTONIC,&e);
    double secs = (e.tv_sec-s.tv_sec) + (e.tv_nsec-s.tv_nsec)/1e9;

    printf("PTHREAD SORT n=%d threads=%d time=%f\n", n, T, secs);

    free(a);
    return 0;
}
