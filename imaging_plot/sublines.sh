# submit jobs looping through all rois

for f in rois/*;
do
    echo "$f"
    fsl_sub -T 300 python extract_roi.py $f
done