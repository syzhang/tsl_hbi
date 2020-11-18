"""IO jump freq model pmod"""

import os,json,glob,sys
from os.path import join as opj
from nipype.interfaces.spm import Level1Design, EstimateModel, EstimateContrast, OneSampleTTestDesign, Threshold
from nipype.algorithms.modelgen import SpecifySPMModel
from nipype.interfaces.utility import Function, IdentityInterface
from nipype.interfaces.io import SelectFiles, DataSink
from nipype.interfaces.fsl import Info
from nipype.algorithms.misc import Gunzip
from nipype import Workflow, Node
import nilearn.plotting
import numpy
import pandas as pd
import nibabel
import matplotlib.pyplot as plt

from pain_compare import first_level, second_level, list_subject

def subjectinfo(subject_id):
    """define individual subject info"""
    import pandas as pd
    from nipype.interfaces.base import Bunch
    
    def construct_sj(trialinfo, subject_id, run_num, cond_name):
        """construct df"""
        df_sj = trialinfo[(trialinfo['subject']==int(subject_id)) & (trialinfo['session']==int(run_num))]
        sj_info = pd.DataFrame()
        sj_info['onset'] = df_sj['runtime']
        sj_info['duration'] = 0.
        sj_info['weight'] = 1.
        return sj_info

    def select_confounds(subject_id, run_num):
        """import confounds tsv files"""
        confounds_dir = f'/data/sub-%02d/func/' % int(subject_id)
        confounds_file = confounds_dir+f'sub-%02d_task-tsl_run-%d_desc-confounds_timeseries.tsv' % (int(subject_id), int(run_num))
        conf_df = pd.read_csv(confounds_file, sep='\t')
        return conf_df

    def confounds_regressor(conf_df, conf_names):
        """select confounds for regressors"""
        conf_select = conf_df[conf_names].loc[4:].fillna(0) # ignore first 4 dummy scans
        conf_select_list = [conf_select[col].values.tolist() for col in conf_select] 
        return conf_select_list

    def find_runs(subject_id):
        """find available runs from func"""
        from glob import glob
        func_dir = f'/output/smooth_nomask/preproc/sub-%02d/' % int(subject_id)    
        func_files = glob(func_dir+'*bold.nii')
        runs = []
        for f in func_files:
            tmp = f.split('/')
            run = tmp[5].split('_')[2].split('-')[1]
            runs.append(int(run))
        return sorted(runs)
    
    conf_names = ['csf','white_matter','global_signal',
    'dvars','std_dvars','framewise_displacement', 'rmsd',
    'a_comp_cor_00', 'a_comp_cor_01', 'a_comp_cor_02', 'a_comp_cor_03', 'a_comp_cor_04', 'a_comp_cor_05', 'cosine00', 'cosine01', 'cosine02', 'cosine03', 'cosine04', 'cosine05',
    'trans_x', 'trans_y', 'trans_z', 'rot_x','rot_y','rot_z']

    alltrialinfo = pd.read_csv('/code/model_gen/output/fmri_io_jump_freq.csv')
    alltrialinfo.head()
    
    subject_info = []
    onset_list = []
    condition_names = ['Stim']
    runs = find_runs(subject_id)
    print(runs)
    for run in runs:
        for cond in condition_names:
            run_cond = construct_sj(alltrialinfo, subject_id, run, cond)
            onset_run_cond = run_cond['onset'].values
            onset_list.append(sorted(onset_run_cond))

    subject_info = []
    for r in range(len(runs)):
        onsets = [onset_list[r]]
        regressors_all = select_confounds(subject_id, runs[r])
        regressors = confounds_regressor(regressors_all, conf_names)

        df_sj = alltrialinfo[(alltrialinfo['subject']==int(subject_id)) & (alltrialinfo['session']==int(runs[r]))]
        # demean pmod
        param_list = list(df_sj['pmod'].values - np.mean(df_sj['pmod'].values)) 
        pmod_bunch = [Bunch(name=['p1'], poly=[1], param=[param_list]),None]
#         pmod_bunch = None
        subject_info.insert(r,
                           Bunch(conditions=condition_names,
                                 onsets=onsets,
                                 durations=[[0]],
                                 regressors=regressors,
                                 regressor_names=conf_names,
                                 pmod=pmod_bunch,
                                 amplitudes=None,
                                 tmod=None
                                 ))

    return subject_info  # this output will later be returned to infosource


if __name__ == "__main__":
    data_dir = '/data'
    code_dir = '/code'
    experiment_dir = '/output'
    output_1st_dir = '1stLevel_io_jump_freq'
    output_2nd_dir = '2ndLevel_io_jump_freq_FDR0001'
    working_dir = 'workingdir'
    
    # define experiment info
    TR = 2.
    subject_list = list_subject(data_dir=data_dir)

    # define contrasts
    # pmod contrasts
    cont01 = ['pprob_p1', 'T', ['Stimxp1^1'], [1]]
    cont02 = ['pprob_np1', 'T', ['Stimxp1^1'], [-1]]
    contrast_list = [cont01, cont02]

    # run first level
    l1analysis = first_level(TR, contrast_list, subject_list, 
                experiment_dir, output_1st_dir)
    l1analysis.run('MultiProc')

    # run second level
    conname_list = ['con_0001', 'con_0002']
    l2analysis = second_level(conname_list, experiment_dir, output_2nd_dir, mask_path='/data/group_mask.nii.gz')
    l2analysis.run('MultiProc')