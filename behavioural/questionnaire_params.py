"""
check questionnaire and model fitted params
"""
import os
import numpy as np
import pandas as pd
from scipy.stats import pearsonr, spearmanr
import matplotlib.pyplot as plt
import seaborn as sns

# load questionnaire data
dfq = pd.read_csv('./allquestionnaires_TSLfmri3t.csv')
print(dfq.shape)

# load fitted parameters
dfp = pd.read_csv('../model_comparison/params/fmri.csv')
dfp_iojf = dfp[dfp['model']=='io_jump_freq']
# dfp_iojf = dfp[dfp['model']=='io_jump_trans']
# dfp_iojf = dfp[dfp['model']=='rw']
print(dfp_iojf.shape)

# merge
df = dfq.merge(dfp_iojf, left_on='recoded id', right_on='subject')
# print(df)
print(dfq.columns)

# calculate correlation
n = len(np.unique(df['recoded id']))
qs = ['STAI', 'PCS rumination', 'PCS magnification',
       'PCS helplessness', 'HAI', 'AMI', 'PHQ9']
pcol = 'transformed_parameters'
# pcol = 'parameters'

for q in qs:
    print(q)
    # trans_q = (df[q])/df[q].max()
    # trans_p = df[pcol]/df[pcol].max()
    trans_q = (df[q]-df[q].mean())/df[q].std()
    trans_p = (df[pcol]-df[pcol].mean())/df[pcol].std()
    print(pearsonr(trans_p, trans_q))
    # print(spearmanr(trans_p, trans_q))

# # plot
# # q = 'AMI'
# q = 'STAI'
# trans_q = (df[q]-df[q].mean())/df[q].std()
# trans_p = (df[pcol]-df[pcol].mean())/df[pcol].std()
# sns.regplot(trans_p, trans_q)
# plt.show()

