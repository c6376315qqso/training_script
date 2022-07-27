#!/bin/bash

#block(name=occuseg_training_0, threads=10, memory=100000, subtasks=1, gpu=true, hours=200)
   source activate p1
   MODEL=s3dis_220413_07
   EPOCH=320
   hdfs dfs -get $HDFS_HOME/model/s3dis/${MODEL: 0-9}/* ckpts/

   TASK_NAME=s3dis_220417_01
   python -u train_instance.py  \
   --taskname $TASK_NAME \
   --dataset stanford3d\
   --batch_size 4\
   --loss weighted_cross_entropy \
   --optim Adam \
   --lr 1e-3 \
   --regress_sigma 0.2 \
   --regress_weight 10 \
   --displacement_weight 1 \
   --gamma 1e-2 \
   --step_size 200 \
   --checkpoints_dir ./ckpts/$TASK_NAME/ \
   --checkpoint 0 \
   --snapshot 10 \
   --m 32 \
   --block_reps 1 \
   --scale 50 \
   --residual_blocks \
   --kernel_size 3 \
   --use_rotation_noise \
   --val_reps 1 \
   --use_feature c \
   --use_dense_model \
   --use_elastic \
   --model_type weak_ins \
   --gpu 0 \
   --limit_point_type limited_osoc_rand_handcraft_2 \
   --global_loss_weight 0.5 \
   --global_st_epoch 20 \
   --displace_st_epoch 30 \
   --similar_thresh 0 \
   --adapt_st_thresh 1 \
   --adapt_end_epoch 100 \
   --kmeans_similar_thresh 0.3 \
   --pretrain ckpts/$MODEL/Epoch${EPOCH}.pth
#    --simple_train
#   --checkpoint_file ckpts/lhanaf_instance_s50_val_rep1_withElastic/Epoch250.pth
#    --all_to_train
#   --checkpoint_file ckpts/lhanaf_dense_m32r1b4_instance_validation_l2/Epoch400.pth
#   --all_to_train \
#   --simple_train \

    echo "Done"

# if you want to schedule multiple gpu jobs on a server, better to use this tool.
# run: `bash ./qsub-SurfaceNet_inference.sh`
# for installation & usage, please refer to the author's github: https://github.com/alexanderrichard/queueing-tool
