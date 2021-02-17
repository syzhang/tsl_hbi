#!/bin/bash
# job submission loop for 1st level
OUTDIR=/home/fs0/syzhang/scratch/TSL_output/
CODEDIR=/home/fs0/syzhang/scratch/tsl/tsl_hbi/
CFDIR=/home/fs0/syzhang/scratch/TSL_fmriprep/

# 1st level
for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (surprise)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_surp.py $sj rw
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (prob)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_prob.py $sj rw
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (prob)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_iorw_prob.py $sj iorw_prob
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (surp)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_iorw_surp.py $sj iorw_surp
done

# 2nd level
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py rw

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py rw

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py iorw_prob

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py iorw_surp

##############
# debug notebook
NBDIR=/home/fs0/syzhang/scratch/tsl/tsl_data/
#debug
singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds,$NBDIR:/notebook nipype.simg 

# matlab
fsl_sub -q short.q matlab -singleCompThread -nodisplay -nosplash \< mytask.m