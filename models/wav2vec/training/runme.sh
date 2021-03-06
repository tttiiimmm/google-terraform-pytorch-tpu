#!/bin/bash
#  Copyright 2018 Google LLC
#
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *      http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#* See the License for the specific language governing permissions and
# * limitations under the License.
# 

source /tmp/values.env

TPU_POD_NAME=${ENV_BUILD_NAME}-tpu

source /anaconda3/etc/profile.d/conda.sh

conda activate torch-xla-nightly

logfile=/tmp/"$(date +%Y%m%d)-wav2vec-podrun-8.txt"


python -m torch_xla.distributed.xla_dist \
--tpu=$TPU_POD_NAME \
--conda-env=torch-xla-nightly\
--env XLA_USE_BF16=1 \
-- python /home/fairseq/fairseq_cli/train.py \
/home/LibriSpeech/ \
--tpu \
--bf16 \
--save-dir /home \
--max-sentences 16 \
--num-workers 6 \
--max-update 400000 \
--save-interval 1 \
--no-epoch-checkpoints \
--arch wav2vec \
--task audio_pretraining \
--lr 1e-06 \
--min-lr 1e-09 \
--optimizer adam \
--max-lr 0.005 \
--lr-scheduler cosine \
--conv-feature-layers '[(512, 10, 5), (512, 8, 4), (512, 4, 2), (512, 4, 2), (512, 4, 2), (512, 1, 1), (512, 1, 1)]' \
--conv-aggregator-layers '[(512, 2, 1), (512, 3, 1), (512, 4, 1), (512, 5, 1), (512, 6, 1), (512, 7, 1), (512, 8, 1), (512, 9, 1), (512, 10, 1), (512, 11, 1), (512, 12, 1), (512, 13, 1)]' \
--skip-connections-agg \
--residual-scale 0.5 \
--log-compression \
--warmup-updates 500 \
--warmup-init-lr 1e-07 \
--criterion binary_cross_entropy \
--num-negatives 10 \
--max-sample-size 150000 \
--max-tokens 1500000 \
--skip-invalid-size-inputs-valid-test \
--log-interval 20 \
--log-format simple \ 
--clip-norm 0 \
--disable-validation \> $logfile #logstep=1 