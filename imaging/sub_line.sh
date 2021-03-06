#!/bin/bash
# job submission loop for 1st level
OUTDIR=/home/fs0/syzhang/scratch/TSL_output/
CODEDIR=/home/fs0/syzhang/scratch/tsl/tsl_hbi/
CFDIR=/home/fs0/syzhang/scratch/TSL_fmriprep/

# 1st level
# for sj in {{6..11},{13..33},{36..39},{41..44}}
for sj in {6..7}
do
echo "submitted job subject $sj (one model pp and pe and hl ones)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_onemodel_hlones.py $sj io_jf_hlones_pp_pe
done

# for sj in {{6..11},{13..33},{36..39},{41..44}}
for sj in {{8..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (one model pp and pe and hl)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_onemodel_hl.py $sj io_jf_pp_pe_hl
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (one model pp and pe)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_onemodel.py $sj io_jf_pp_pe
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (pain compare)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/hl_compare.py $sj pain_compare
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (surprise)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_surp.py $sj io_jf_surprise_mean
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (prob)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_prob.py $sj rw
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (prob mean)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_prob_mean.py $sj io_jf_prob_mean
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

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (pe)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_pe.py $sj io_jump_freq_pe
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (pe)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_pe.py $sj rw_pe
done

for sj in {{6..11},{13..33},{36..39},{41..44}}
do
echo "submitted job subject $sj (sd)"
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/pmod_sd.py $sj io_jump_freq_sd
done

# 2nd level
fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jf_pp_pe_hl

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jf_hl_pp_pe

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jf_pp_pe

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py pain_compare

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jf_surprise_mean_surp

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py rw

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py iorw_prob

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py iorw_surp

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jump_freq_pe

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jump_freq_sd

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py rw_pe

fsl_sub -T 10 -R 80 singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds nipype.simg python /code/imaging/run_2nd_level.py io_jf_prob_mean


##############
# debug notebook
OUTDIR=/home/fs0/syzhang/scratch/TSL_output/
CODEDIR=/home/fs0/syzhang/scratch/tsl/tsl_hbi/
CFDIR=/home/fs0/syzhang/scratch/TSL_fmriprep/
NBDIR=/home/fs0/syzhang/scratch/tsl/tsl_data/
#debug
singularity run --cleanenv -B $OUTDIR:/output,$CODEDIR:/code,$CFDIR:/confounds,$NBDIR:/notebook nipype.simg
cd /notebook # go to notebook dir
~/.local/bin/jupyter-lab # run notebook

# matlab
fsl_sub -q short.q matlab -singleCompThread -nodisplay -nosplash \< mytask.m


# download from sftp
for sj in {6..9}
for sj in {{10..11},{13..33},{36..39},{41..44}}
do
# fsl_sub -T 5 bet sub-0$sj\_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz sub-0$sj\_bet.nii.gz
fsl_sub -T 5 bet sub-$sj\_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz sub-$sj\_bet.nii.gz
done