# matlab jobs
for sj in {1..35}
do
    for mod in   "io_fixed_freq" "io_fixed_trans" #"rw" "random" "io_jump_freq" "io_jump_trans"
    do
    echo "submitted job subject $sj ($mod for fmri)"
    fsl_sub -T 20 matlab -singleCompThread -nodisplay -nosplash -r "run_fmincon_fit($sj, '$mod', 'fmri')"
    done
done

for sj in {1..33}
do
    for mod in  "io_fixed_freq" "io_fixed_trans" #"rw" "random" "io_jump_freq" "io_jump_trans" 
    do
    echo "submitted job subject $sj ($mod for practice)"
    fsl_sub -T 20 matlab -singleCompThread -nodisplay -nosplash -r "run_fmincon_fit($sj, '$mod', 'practice')"
    done
done

# summarise results
fsl_sub -T 5 matlab -singleCompThread -nodisplay -nosplash -r "summarise_fit('fmri')"
