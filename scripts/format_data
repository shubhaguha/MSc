train() {
    echo 'Generating parallel texts from NUCLE...'
    perl ~/MSc/scripts/make_parallel.perl < ~/MSc/data/conll14st-preprocessed.m2 > ~/MSc/data/nucle.parallel

    echo 'Concatenating NUCLE and Lang-8 parallel texts...'
    cat ~/MSc/data/nucle.parallel ~/MSc/data/lang8-naist.tok.uniq.txt > ~/MSc/data/train.parallel

    echo 'Splitting parallel texts into two files...'
    python ~/MSc/scripts/split_parallel.py ~/MSc/data/train.parallel
}

valid() {
    echo 'Generating parallel texts from CoNLL-2013...'
    perl ~/MSc/scripts/make_parallel.perl < ~/MSc/data/release2.3.1/original/data/official-preprocessed.m2 > ~/MSc/data/valid.parallel

    echo 'Splitting parallel texts into two files...'
    python ~/MSc/scripts/split_parallel.py ~/MSc/data/valid.parallel
}

test() {
     echo 'Generating parallel texts from CoNLL-2014...'
     perl ~/MSc/scripts/make_parallel.perl < ~/MSc/data/conll14st-test-data/noalt/official-2014.combined.m2 > ~/MSc/data/test.parallel

    echo 'Splitting parallel texts into two files...'
    python ~/MSc/scripts/split_parallel.py ~/MSc/data/test.parallel
}


for arg in $@
do
    $arg
done
echo 'Done'
