source activate nmtenv

# extract m2scorer and test data
~/MSc/scripts/extract_data_files original

# predict on test set
echo 'Translating test data with model' $1 '...'
python nematus/nematus/translate.py --models $1 --input MSc/data/test.fr --output MSc/data/test.pred --output_alignment MSc/data/test.align

# postprocess system output
echo 'Reinserting pipe symbols...'
sed 's/<pipe>/|/g' MSc/data/test.pred > MSc/data/test.pred.pipe
echo 'Removing BPE on system output...'
sed -r 's/(@@ )|(@@ ?$)//g' MSc/data/test.pred.pipe > MSc/data/test.pred.pipe.unbpe
echo 'Detruecasing system output...'
perl mosesdecoder/scripts/recaser/detruecase.perl < MSc/data/test.pred.pipe.unbpe > MSc/data/postprocessed-test.pred

# score system output
echo 'Evaluating system output with M2 scorer...'
python MSc/scripts/print_model_info.py $1 >> MSc/model_evaluation.txt
python MSc/data/release2.3.1/m2scorer/scripts/m2scorer.py MSc/data/postprocessed-test.pred MSc/data/conll14st-test-data/noalt/official-2014.combined.m2 >> MSc/model_evaluation.txt
echo '' >> MSc/model_evaluation.txt

echo 'Done'
