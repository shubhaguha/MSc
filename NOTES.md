Meeting Notes
===

Meeting notes 12 June 2017
---

- back translation / data augmentation using smt
- LM for reranking NMT outputs (or mixing models) doesn't seem to work

- what to use LM for?
  - measure fluency
  - Xie et al: linear combination

Meeting summary 23 June 2017
---

1. (re)do preprocessing: tokenization, BPE (ask Roman)
1. preprocess and use validation dataset in tracking training progress
1. use dropout (~0.1)
1. implement script for M2 (ask Roman)
1. modify Nematus code to use word-level weighted loss function

Questions for Kenneth 27 June 2017
---

PREPROCESSING:

- two different tokenizer results (Roman's NLTK tokenizer vs. Moses tokenizer included in Nematus)
  - main difference seems to be escaping symbols like `&`
- how to apply BPE?
  - subword-nmt/learn_bpe.py learns different bpe than gec.bpe from Roman
  - subword-nmt/apply_bpe.py produces new training file with few but strange differences
  - is it only meant for test time?
- increase number of subword units to capture morphology? could help learn to correct e.g. misspellings like `reliabiliyt` instead of `reliability`
- when is detokenizer necessary?

DROPOUT:

- 5 dropout parameters in Nematus:
  - `--use_dropout  use dropout layer (default: False)`
  - `--dropout_embedding FLOAT   dropout for input embeddings (0: no dropout) (default: 0.2)`
  - `--dropout_hidden FLOAT  dropout for hidden layer (0: no dropout) (default: 0.2)`
  - `--dropout_source FLOAT  dropout source words (0: no dropout) (default: 0)`
  - `--dropout_target FLOAT  dropout target words (0: no dropout) (default: 0)`

Meeting notes 27 June 2017
---

- doesn't matter what tokenizer; just be consistent and report which one

- check with Roman which git version of subword-nmt he used to create gec.bpe

- talk to Maxi about trying to learn morphology with more BPE (didn't work)

- `--layer_normalisation --use_dropout --dropout_source 0.1 --dropout_target 0.1`

- try smaller batch size on m60 (converge faster)

- replace pipe symbols with something unique like <pipe> or &#124
  - do after tokenization
  - undo before detokenization

- detokenize before evaluation on M2

Meeting notes 5 July 2017
---

- CE with editted words weighted extra

- M2 scorer for MRT in Nematus --> need aligner for hypothesis vs reference sentences

Meeting notes 28 July 2017
---

- had in mind separate aligner (M2), naive
  - pass in 3rd file?
  - munge

- run with this but provide evidence that dec_alphas aligns to the right token (generally in MT, looks back one token from the one expected)

- stacked graphs (precision and recall on y axis, edit weight on x axis)

- argue that converges faster?

Meeting notes 9 August 2017
---

- try edit weights 1, 0, -1

- calculate training loss for one sentence as sanity check
