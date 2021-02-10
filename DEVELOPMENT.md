Development Notes
===

Setting up to use Azure on local machine
---

- Create conda env with python3
- Get Kenneth's Azure scripts

```bash
git clone https://github.com/kpu/azurehacks.git
```

- Install prerequisites for Kenneth's scripts

```bash
brew install parallel
```

- Launch virtual machine scale set

```bash
az login  # with Kenneth to accept my code
az group create -l southcentralus -n ${USER}-gec-nmt
./vmss_create.sh \
    --resource-group ${USER}-gec-nmt \
    --name ${USER}-scale \
    --instance-count 1 \
    --vm-sku Standard_NC6 \
    --ssh-key-value ~/.ssh/id_rsa.pub \
    --image /subscriptions/b97717d6-1424-45c1-b6e6-316241c3cd70/resourceGroups/HEAFIELD-BASE/providers/Microsoft.Compute/images/wmtbase \
    --generate-ssh-keys
./vmss_setup.sh \
    --resource-group ${USER}-gec-nmt \
    --name ${USER}-scale
```

- Other useful Azure commands

```bash
az vmss list-instances \
    --resource-group ${USER}-gec-nmt \
    --name ${USER}-scale
az vmss deallocate \
    --resource-group ${USER}-gec-nmt \
    --name ${USER}-scale \
    --instance-ids 0  # if deallocate command doesn't work on VM
az vmss start \
    --resource-group ${USER}-gec-nmt \
    --name ${USER}-scale \
    --instance-ids 0
az vmss scale \
    --resource-group ${USER}-gec-nmt \
    --name ${USER}-scale \
    --new-capacity 2
```

Data formatting
---

- Convert NUCLE, CoNNL-2013, and CoNLL-2014 datasets into parallel corpora

- Concatenate NUCLE and Lang-8

- Split train, valid, and test parallel texts


Train truecaser
---

```bash
perl mosesdecoder/scripts/recaser/train-truecaser.perl --model MSc/data/truecaser --corpus MSc/data/train.parallel
```

Preprocessing
---

- Truecase

- Apply BPE
    - I used the original simple BPEs. This commit should work: fb526f1b007420d6b76c34417ab42d47ffd2d850 (subword-nmt)

- Replace | with <pipe>
    - because special character in Nematus


Postprocessing
---

- Replace <pipe> with |

- Remove BPE

- Detruecase


Running training
---

- Build dictionaries

```bash
python nematus/data/build_dictionary.py MSc/data/preprocessed-train.fr MSc/data/preprocessed-train.en
```

- Train
  - run with `time` and `deallocate`

```bash
python nematus/nematus/nmt.py --datasets MSc/data/preprocessed-train.fr MSc/data/preprocessed-train.en \
                              --dictionaries MSc/data/preprocessed-train.fr.json MSc/data/preprocessed-train.en.json \
                              --model MSc/baseline_0.npz \
                              [--saveFreq 10000] \
                              --layer_normalisation \
                              --use_dropout \
                              --dropout_source 0.1 \
                              --dropout_target 0.1 \
                              --batch_size 60 \
                              --valid_batch_size 60 \
                              --valid_datasets MSc/data/preprocessed-valid.fr MSc/data/preprocessed-valid.en \
                              [--reload]
```

default params:
- `--dropout_embedding 0.2`
- `--dropout_hidden 0.2`
- `--patience 10` (the number of times validation error > previous validation errors)
- `--objective CE` (cross-entropy minimization)

thesis param:
- `--edit_weight 2,3,4,5` (default 1)

MRT params:
- `--objective MRT`
- `--mrt_loss M2`


Model naming
---

<table>
    <tbody>
        <tr>
            <th>Name</th>
            <th>Description</th>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_ce_0</td>
            <td>NUCLE only, without tokenization or BPE, default Nematus parameters, cross-entropy minimization</td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_mrt_0</td>
            <td>+ MRT objective</td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_1</td>
            <td>+ Lang-8, + tokenization and BPE, default cross-entropy objective</td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_2</td>
            <td>+ layer normalisation, default 0.2 embedding and hidden dropout, 0.1 src and trgt dropout</td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_3</td>
            <td>batch size 60, trained on M60 machine</td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_4</td>
            <td>batch size 40, trained on M60 machine</td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_5</td>
            <td>
                baseline_3 + replace | with &lt;pipe&gt;
                <ul>
                    <li>started training around 9:45pm Wed June 28</li>
                    <li>338k minibatches by 12pm noon Sun July 2</li>
                    <li>early stop after 530k minibatches (by 1pm Tue July 4, 8056m46.192s real time)</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_6</td>
            <td>
                K80 machine, default batch size 80
                <ul>
                    <li>started training around 10:45pm Wed June 28</li>
                    <li>210k minibatches by 12pm noon Sun July 2</li>
                    <li>early stop after 370k minibatches (by 12pm Wed July 5, 8986m43.145s real time)</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_7</td>
            <td>
                M60, batch size 60: - tokenization + truecaser, replace pipes last
                <ul>
                    <li>started training around 2:30pm Sun July 2</li>
                    <li>early stop after 590k minibatches (before 9pm Sat July 8, 8289m6.922s real time)</li>
                    <li>P 0.3319, R 0.1413</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_8</td>
            <td>
                same as baseline_7
                <ul>
                    <li>started training around 6pm Wed Aug 9</li>
                    <li>patience 5: early stop after 410k minibatches (by 5:30pm Sun Aug 13)</li>
                    <li>restarted training around 6:30pm Sun Aug 13</li>
                    <li>patience 10: early stop after 460k minibatches (by 9:45am Mon Aug 14)</li>
                    <li>P 0.3376, R 0.1362</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">baseline_9 *</td>
            <td>
                same as baseline_7 and baseline_8
                <ul>
                    <li>started training around 10:30pm Thu Aug 10</li>
                    <li>patience 5: early stop after 370k minibatches (by 2pm Mon Aug 14)</li>
                    <li>restarted training around 8pm Mon Aug 14</li>
                    <li>patience 10: early stop after ...</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_weight_2</td>
            <td>
                M60, batch size 60, edit weight 2 (commit 48fb87c)
                <ul>
                    <li>started training around 2pm Wed July 19</li>
                    <li>early stop after 400k minibatches (before 9pm Sun July 23, 3847m50.989s real time)</li>
                    <li>P 0.1546, R 0.2630</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_weight_3</td>
            <td>
                edit weight 3 (commit 48fb87c)
                <ul>
                    <li>started training around 2pm Wed July 19</li>
                    <li>early stop after 600k minibatches (before 5pm Tue July 25, 6668m41.838s real time)</li>
                    <li>P 0.1591, R 0.2520</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_weight_3_x2</td>
            <td>
                same as edit_weight_3
                <ul>
                    <li>started training around 3:30pm Sat July 29</li>
                    <li>early stop after 510 minibatches (by 9pm Thu Aug 3, 5649m17.291s real time)</li>
                    <li>P 0.1556, R 0.2576</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_weight_4</td>
            <td>
                edit weight 4 (commit 48fb87c)
                <ul>
                    <li>started training around 2pm Wed July 19</li>
                    <li>early stop after 420k minibatches (before 9pm Sun July 23, 3897m54.745s real time)</li>
                    <li>P 0.1566, R 0.2665</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_weight_5</td>
            <td>
                edit weight 5 (commit 48fb87c)
                <ul>
                    <li>started training around 2pm Wed July 19</li>
                    <li>early stop after 380k minibatches (before 2pm Sun July 23, 5316m30.417s real time)</li>
                    <li>P 0.1582, R 0.2704</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_2</td>
            <td>
                edit vectors and edit weight 2 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 340k minibatches (by 11:30am Sun Aug 13)</li>
                    <li>restarted training around 12:30pm Sun Aug 13</li>
                    <li>patience 10: early stop after 710 minibatches (by 6:15pm Thu Aug 17)</li>
                    <li>P 0.3791, R 0.1869</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_3</td>
            <td>
                edit vectors and edit weight 3 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 420k minibatches (by 9:45am Mon Aug 14)</li>
                    <li>restarted training around 10:15am Mon Aug 14</li>
                    <li>patience 10: early stop after 480k minibatches (by 11am Thu Aug 17)</li>
                    <li>P 0.3970, R 0.2117</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_4</td>
            <td>
                edit vectors and edit weight 4 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 300k minibatches (by 1:45am Sun Aug 13)</li>
                    <li>restarted training around 2:15am Sun Aug 13</li>
                    <li>patience 10: early stop after 350k minibatches (at 1:50pm exactly Sun Aug 13)</li>
                    <li>P 0.3984, R 0.2294</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_5</td>
            <td>
                edit vectors and edit weight 5 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 350k minibatches (by 1:30pm Sun Aug 13)</li>
                    <li>restarted training around 1:45pm Sun Aug 13</li>
                    <li>patience 10: early stop after 400k minibatches (by 9:45am Mon Aug 14)</li>
                    <li>P 0.3980, R 0.2624</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_6</td>
            <td>
                edit vectors and edit weight 6 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 570k minibatches (by 10:30pm Tue Aug 15)</li>
                    <li>restarted training before 11pm Tue Aug 15</li>
                    <li>patience 10: early stop after 620k minibatches (by 10:45am Wed Aug 16)</li>
                    <li>P 0.4044, R 0.2857</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_1</td>
            <td>
                edit vectors and edit weight 1 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 320k minibatches (by 11:30am Sun Aug 13)</li>
                    <li>restarted training around 11:30am Sun Aug 13</li>
                    <li>patience 10: early stop after 590k minibatches (by 9:45am Wed Aug 16)</li>
                    <li>P 0.3448, R 0.1437</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_0</td>
            <td>
                edit vectors and edit weight 0 (commit 842c2a5)
                <ul>
                    <li>started training around 12:45am Thu Aug 10</li>
                    <li>patience 5: early stop after 160k minibatches (by 4:30pm Fri Aug 11)</li>
                    <li>restarted training around 6:15pm Fri Aug 11</li>
                    <li>patience 10: early stop after 210k minibatches (by 11am Sat Aug 12)</li>
                    <li>P 0.0805, R 0.0248</li>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top">edit_vectors_-1</td>
            <td>edit vectors and edit weight -1 (commit 842c2a5), lrate 0.00001</td>
        </tr>
        <tr>
            <td style="vertical-align:top">pretrained_7</td>
            <td>final baseline_7 + MRT on M2</td>
        </tr>
    </tbody>
</table>
