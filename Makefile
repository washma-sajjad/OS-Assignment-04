# --- Compiler settings ---
CC = gcc
MPICC = mpicc
CFLAGS = -Wall -O2 -g
OMPFLAGS = -fopenmp
PTHREADFLAGS = -pthread

# --- Directories ---
SRC_DIR = src
BIN_DIR = bin

# --- Matrix multiplication sources ---
MATRIX_SRC = $(SRC_DIR)/matrix.c
SEQ_SRC = $(SRC_DIR)/sequential.c
OMP_SRC = $(SRC_DIR)/omp.c
THREAD_SRC = $(SRC_DIR)/thread2.c
MPI_SRC = $(SRC_DIR)/mpi.c

# --- Sorting sources ---
SORT_SEQ_SRC = $(SRC_DIR)/sort_seq.c
SORT_PTHREAD_SRC = $(SRC_DIR)/sort_pthread.c
SORT_OMP_SRC = $(SRC_DIR)/sort_omp.c

# --- All target ---
all: dirs matrix sort

# --- Create bin directory ---
dirs:
	mkdir -p $(BIN_DIR)

# --- Matrix multiplication binaries ---
matrix: $(BIN_DIR)/seq $(BIN_DIR)/omp $(BIN_DIR)/thread2 $(BIN_DIR)/mpi

$(BIN_DIR)/seq: $(MATRIX_SRC) $(SEQ_SRC)
	$(CC) $(CFLAGS) -o $@ $(MATRIX_SRC) $(SEQ_SRC)

$(BIN_DIR)/omp: $(MATRIX_SRC) $(OMP_SRC)
	$(CC) $(CFLAGS) $(OMPFLAGS) -o $@ $(MATRIX_SRC) $(OMP_SRC)

$(BIN_DIR)/thread2: $(MATRIX_SRC) $(THREAD_SRC)
	$(CC) $(CFLAGS) $(PTHREADFLAGS) -o $@ $(MATRIX_SRC) $(THREAD_SRC)

$(BIN_DIR)/mpi: $(MATRIX_SRC) $(MPI_SRC)
	$(MPICC) $(CFLAGS) -o $@ $(MATRIX_SRC) $(MPI_SRC)

# --- Sorting binaries ---
sort: $(BIN_DIR)/sort_seq $(BIN_DIR)/sort_pthread $(BIN_DIR)/sort_omp

$(BIN_DIR)/sort_seq: $(SORT_SEQ_SRC)
	$(CC) $(CFLAGS) -o $@ $(SORT_SEQ_SRC)

$(BIN_DIR)/sort_pthread: $(SORT_PTHREAD_SRC)
	$(CC) $(CFLAGS) $(PTHREADFLAGS) -o $@ $(SORT_PTHREAD_SRC)

$(BIN_DIR)/sort_omp: $(SORT_OMP_SRC)
	$(CC) $(CFLAGS) $(OMPFLAGS) -o $@ $(SORT_OMP_SRC)

# --- Clean ---
clean:
	rm -rf $(BIN_DIR) data/*.txt

.PHONY: all dirs matrix sort clean

BIN_DIR = bin
SRC_DIR = src

# --- MPI sorting binary ---
$(BIN_DIR)/sort_mpi: $(SRC_DIR)/sort_mpi.c
	@mkdir -p $(BIN_DIR)
	$(MPICC) $(CFLAGS) -o $@ $(SRC_DIR)/sort_mpi.c

