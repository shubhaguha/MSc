from __future__ import print_function
import sys
from nltk_tok import nltk_tokenize


filename = sys.argv[1]
tok_filename = filename + '.tok'

with open(filename, 'r') as pre_f,\
        open(tok_filename, 'w') as tok_f:
    for row in pre_f:
        tok_row = nltk_tokenize(row.decode('utf-8')).encode('utf-8')
        print(tok_row, file=tok_f)
