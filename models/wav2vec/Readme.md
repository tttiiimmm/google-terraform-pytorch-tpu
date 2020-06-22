# Training on Wav2Vec


Upon the deployment of the Cloud TPU enviroment using the Cloudbuild/Terraform automation tools, the enviroment comes preloaded with scripts to quickly enable you to start training a wav2vec model

There are three steps that need to be completed to start training. 

## 1. Prepare your data

Use the `wav2vec_setup` to prepare the enviroment for training 

```
source /tmp/values.env
bash -xe $MOUNT_POINT/nfs_share/models/wav2vec/env_setup/wav2vec_setup.sh
```

#### 2a. This script will do the following
- From the Managed Instance Group machine you are currently logged in, create a path `$MOUNT_POINT/nfs_share/code` if it does not exist 
- Download the wav2vec data into local host(s) 
- Remote SSH into every instance in the Managed Instance Group and install libraries required for RoBERTa to run  

## 3. Training  RoBERTa 
---

Start the training by running this command 

```
nohup bash -xe $MOUNT_POINT/nfs_share/models/wav2vec/training/runme.sh &
```

#### 3b. This script will do the following
- Set the conda enviroment to *`torch-xla-nightly`*
- Using *`torch_xla.distributed.xla_dis`* launch a distributed training job connecting to all the instances in the managed instance group with the following options
    - Use training data stored under the shared pd *`/home/wav2vec/`*
    - Save the training log file under path /tmp/ of each managed group instance 


## 4. Monitoring Training Progress 
---

You can monitor training progress by reviweing the training log file under the *`/tmp/`* directory 

```
tail -f /tmp/*wav2vec-podrun*
````

