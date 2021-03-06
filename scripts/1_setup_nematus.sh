echo 'Creating env `nmtenv`...'
conda create --name nmtenv python=2.7

echo 'Installing numpy, numexpr, cython, tables, theano, pygpu, and mkl...'
source activate nmtenv
conda install theano pygpu mkl-service
pip install numpy numexpr cython tables
conda clean -t

echo 'Installing nematus...'
cd ~
git clone https://github.com/moses-smt/mosesdecoder
git clone https://github.com/rsennrich/subword-nmt
git clone https://github.com/rsennrich/nematus
cd nematus
python setup.py install
git reset --hard 73037e94884fd2d1c1d18d81686cd1f6ea32d073
cd ..

echo 'Copying modified nematus code...'
cp ~/MSc/scripts/modified_nmt.py ~/nematus/nematus/
cp ~/MSc/scripts/modified_data_iterator.py ~/nematus/nematus/

echo 'Installing g++ c compiler for theano optimization...'
sudo apt-get install g++

echo 'Copying rc files...'
cp ~/MSc/rc_files/theanorc ~/.theanorc
cp ~/MSc/rc_files/vimrc ~/.vimrc

echo 'Done'
