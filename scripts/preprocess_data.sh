for dataset in $@
do
    echo 'Truecasing...'
    perl ~/mosesdecoder/scripts/recaser/truecase.perl --model ~/MSc/data/truecaser < ~/MSc/data/${dataset}.fr > ~/MSc/data/${dataset}.fr.tc
    perl ~/mosesdecoder/scripts/recaser/truecase.perl --model ~/MSc/data/truecaser < ~/MSc/data/${dataset}.en > ~/MSc/data/${dataset}.en.tc

    echo 'Applying BPE...'
    python ~/subword-nmt/apply_bpe.py -c ~/MSc/data/gec.bpe < ~/MSc/data/${dataset}.fr.tc > ~/MSc/data/${dataset}.fr.tc.bpe
    python ~/subword-nmt/apply_bpe.py -c ~/MSc/data/gec.bpe < ~/MSc/data/${dataset}.en.tc > ~/MSc/data/${dataset}.en.tc.bpe
    
    echo 'Replacing pipe symbols...'
    sed 's/|/<pipe>/g' ~/MSc/data/${dataset}.fr.tc.bpe > ~/MSc/data/preprocessed-${dataset}.fr
    sed 's/|/<pipe>/g' ~/MSc/data/${dataset}.en.tc.bpe > ~/MSc/data/preprocessed-${dataset}.en

    echo 'Compressing preprocessed files...'
    cd ~/MSc/data
    tar -czvf preprocessed-${dataset}.tar.gz preprocessed-${dataset}.fr preprocessed-${dataset}.en
    cd ~
done

echo 'Done'
