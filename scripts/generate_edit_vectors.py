import sys
from levenshtein import *


fr_filename, en_filename = sys.argv[1:3]
edits_filename = fr_filename[:fr_filename.rfind('.')] + '.edits'
max_unchanged_words = 2
very_verbose = False

with open(fr_filename, 'r') as source_file,\
        open(en_filename, 'r') as candidate_file,\
        open(edits_filename, 'w') as edits_file:
    for source, candidate in zip(source_file, candidate_file):
        candidate_tok = candidate.split()
        source_tok = source.split()
        lmatrix, backpointers = levenshtein_matrix(source_tok, candidate_tok)
        V, E, dist, edits = edit_graph(lmatrix, backpointers)
        if very_verbose:
            print "edit matrix:", lmatrix
            print "backpointers:", backpointers
            print "edits (w/o transitive arcs):", edits
        V, E, dist, edits = transitive_arcs(V, E, dist, edits, max_unchanged_words, very_verbose)

        edit_vector = ['0'] * len(candidate_tok)
        for key, edit in edits.iteritems():
            edit_type, start_idx, end_idx, before, after, num = edit
            if edit_type == 'noop' or num != 0 or len(before.split()) >= 2 or len(after.split()) >= 2:
                continue
            (src_start, cand_start), (src_end, cand_end) = key
            if cand_start + 1 == cand_end:
                edit_vector[cand_start] = '1'
        print >> edits_file, ' '.join(edit_vector)
