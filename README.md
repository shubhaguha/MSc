# MSc


All original code can be found under scripts/. Most important to note:
    - scripts/modified_nmt.py
      This is my implementation of training for my advanced modesls and should be compared to
      nematus/nmt.py under the Nematus project (https://github.com/EdinburghNLP/nematus/) at commit
      73037e94884fd2d1c1d18d81686cd1f6ea32d073.
    - scripts/generate_edit_vectors.py
      This is my implmentation  of using the MaxMatch aligner to extract edit vectors. The file
      created by this script is passed in as the value of command line argument --edit_vectors in
      modified_nmt.py.

Also relevant:
    - scripts/preprocess_data
      This is how I preprocess training, validation, and test data.
    - scripts/evaluate_model
      This is how I evaluate a trained model.
    - scripts/modified_data_iterator.py
      This is a modification of nematus/data_iterator.py to handle the additional input of edit
      vectors.

Not original code:
    - levenshtein.py
      This is directly from the CoNLL 2013 shared task scripts for the M2 scorer. It is necessary
      to run generate_edit_vectors.py.

All other code files are to set up the environment for training remotely and for convenience during
development and testing.
