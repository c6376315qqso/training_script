#!/bin/bash

#block(name=occuseg_training_0, threads=10, memory=100000, subtasks=1, gpu=true, hours=200)
   TASK_NAME=train_220308_01
   MODEL=leyao_220302_03
   EPOCH=210
   hdfs dfs -get $HDFS_HOME/model/ScanNet/${MODEL: 0-9}/* ckpts/
   
   source activate p1
   python -u train_instance.py  \
   --taskname $TASK_NAME \
   --dataset scannet\
   --batch_size 8\
   --loss cross_entropy \
   --optim Adam \
   --lr 5e-3 \
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
   --limit_point_type limited_osoc_max \
   --save_pred_train \
   --checkpoint_file ckpts/$MODEL/Epoch${EPOCH}.pth

   python -u train_instance.py  \
   --taskname $TASK_NAME \
   --dataset scannet\
   --batch_size 5\
   --loss cross_entropy \
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
   --model_type occuseg \
   --train_path pred_train/\*.pth


    echo "Done"
