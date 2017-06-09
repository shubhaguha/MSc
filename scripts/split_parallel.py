from __future__ import print_function
import sys


parallel_filename = sys.argv[1]
fr_filename = parallel_filename.replace('parallel', 'fr')
en_filename = parallel_filename.replace('parallel', 'en')

with open(parallel_filename, 'r') as par_f,\
	open(fr_filename, 'w') as fr_f,\
	open(en_filename, 'w') as en_f:
    for row in par_f:
        fr_row, en_row = row.strip().split('\t')
        print(fr_row, file=fr_f)
        print(en_row, file=en_f)
