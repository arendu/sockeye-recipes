#!/bin/bash


if [ $# -ne 4 ]; then
    echo "Usage: translate.sh hyperparams.txt input output device(cpu/gpu)"
    exit
fi


source $1
input=$2
output=$3

if [ $4 == "cpu" ]; then
    source activate sockeye_cpu
    device="--use-cpu"
else
    source activate sockeye_gpu
    module load cuda80/toolkit
    gpu_id=`$rootdir/scripts/get-gpu.sh`
    device="--device-id $gpu_id"
fi

subword=$rootdir/tools/subword-nmt/

### Apply BPE to input, run Sockeye.translate, then de-BPE ###
cat $input | \
    python -m sockeye.translate --models $modeldir $device \
    --max-input-len 100  \
    --disable-device-locking \
    | sed -r 's/@@( |$)//g' > $output