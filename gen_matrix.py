#!/usr/bin/env python3
# gen_matrix.py - generate an n x m matrix with tab-separated floats to stdout
import sys, random

if len(sys.argv) < 3:
    print("usage: gen_matrix.py rows cols", file=sys.stderr)
    sys.exit(1)

r = int(sys.argv[1]); c = int(sys.argv[2])
for i in range(r):
    row = "\t".join(str(random.uniform(0, 9999)) for _ in range(c))
    print(row)
