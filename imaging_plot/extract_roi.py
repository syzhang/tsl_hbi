"""
extract ROI and resample pmod
"""
import os, sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from nilearn.input_data import NiftiLabelsMasker

def resample_pmod(df, sj, sess):
    dft = df[(df['subject']==sj) & (df['session']==sess)].copy()
    dft['datetime'] = pd.to_datetime(dft['runtime'], unit='s')
    ds = pd.Series(dft['pmod_mean'].values, index=dft['datetime'])
    pmod_pl = ds.resample('2s').mean().fillna(method='ffill')
    pmod_pl = (pmod_pl - pmod_pl.mean())/pmod_pl.std()
    return pmod_pl

if __name__ == "__main__":
    df = pd.read_csv('../model_gen/local_output_mean/fmri_io_jump_freq.csv')
    func_dir = '../../../TSL_output/smooth_nomask/preproc/'

    mask_img = sys.argv[1] # roi file name
    # mask_img = os.path.join('./rois', mask)
    masker = NiftiLabelsMasker(mask_img, resampling_target='data',
                        standardize=True, detrend=True)  
    masker.fit()
    

    allsj_ls = []
    for sj in os.listdir(func_dir):
        sj_dir = os.path.join(func_dir, sj)
        sj_ls = []
        for f in sorted(os.listdir(sj_dir)):
            # read pmod
            sj_num = int(f.split('_')[0].split('-')[1])
            run_num = int(f.split('_')[2].split('-')[1])
            df_pmod = resample_pmod(df, sj_num, run_num)        
            
            # read roi
            func_file = os.path.join(sj_dir, f)
    #         print(func_file)
            mask_data = masker.transform(func_file)
            mask_mean = np.mean(mask_data, 1)
            
            # make df
            df_len = min([len(mask_mean), len(df_pmod)])
            df_tmp = pd.DataFrame({'roi_mean': mask_mean[:df_len], 'pmod_mean': df_pmod[:df_len], 'subject': [sj_num]*df_len, 'session': [run_num]*df_len})
            sj_ls.append(df_tmp)
        df_sj = pd.concat(sj_ls)
        allsj_ls.append(df_sj)
    allsj_df = pd.concat(allsj_ls)
    fname = mask_img.split('.')[0].split('/')[1]+'.csv'
    allsj_df.to_csv(os.path.join('./output/', fname))