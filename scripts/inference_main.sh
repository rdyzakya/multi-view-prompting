set -ex

export CUDA_VISIBLE_DEVICES=1

declare -A TASK_DATA
# TASK_DATA[asqp]="rest15 rest16"
# TASK_DATA[acos]="laptop16 rest16"
TASK_DATA[aste]="dummy_hoasa"
# TASK_DATA[tasd]="rest15 rest16"

cd src

# for SVP_TYPE in heuristic rand rank 
for TASK in aste
do
for DATA in ${TASK_DATA[${TASK}]}
do
for DATA_RATIO in 1.0
do
for SEED in 5
do
for K in 5
# for K in 3 7 15
do
INFER_PATH=$K
CTRL_TOKEN=post
OUT_DIR="../outputs/$TASK/${DATA}/top${K}_${CTRL_TOKEN}_data${DATA_RATIO}"

mkdir -p $OUT_DIR


python main.py \
    --data_path "../data/" \
    --dataset $DATA \
    --output_dir $OUT_DIR \
    --num_train_epochs 20 \
    --save_top_k 0 \
    --task $TASK \
    --top_k $K \
    --ctrl_token $CTRL_TOKEN \
    --multi_path \
    --num_path $INFER_PATH \
    --seed $SEED \
    --train_batch_size 16 \
    --gradient_accumulation_steps 1 \
    --learning_rate 1e-4 \
    --lowercase \
    --sort_label \
    --data_ratio $DATA_RATIO \
    --check_val_every_n_epoch 10  \
    --agg_strategy vote \
    --eval_batch_size 64 \
    --model_name_or_path "/raid/m13519061/ijeei/multi-view-prompting/outputs/aste/hotelv2_and_ecommerce/top5_post_data1.0/final" \
    | tee ${OUT_DIR}/train.log \
    2> ${OUT_DIR}/train.err
    # --model_name_or_path muchad/idt5-base \
    # --constrained_decode \
    # --do_train \
    # configure the checkpoint path to eval

    # --load_path_cache \
    # --single_view_type $SVP_TYPE \
    # --load_ckpt_name "ckpt path" \
    # > $OUT_DIR/train.log 2>&1&
done
done
done
done
done
# done
