export NUCLE=nucle-3.0.tar.gz
export LANG8=lang8.tar.gz
export CONLL13=release2.3.1.tar.gz
export CONLL14=conll14st-test-data.tar.gz

export TRAIN=preprocessed-train.tar.gz
export VALID=preprocessed-valid.tar.gz
export TEST=preprocessed-test.tar.gz


original() {
    echo 'Extracting NUCLE...'
    tar -xzvf $NUCLE
    echo 'Extracting Lang-8...'
    tar -xzvf $LANG8
    echo 'Extracting CoNLL-2013 test set...'
    tar -xzvf $CONLL13
    echo 'Extracting CoNLL-2014 test set...'
    tar -xzvf $CONLL14
}

preprocessed() {
    echo 'Extracting preprocessed training data...'
    tar -xzvf $TRAIN
    echo 'Extracting preprocessed validation data...'
    tar -xzvf $VALID
    echo 'Extracting preprocessed test data...'
    tar -xzvf $TEST
}

cd ~/MSc/data
$1
cd ~
