"""
plot bms results
"""
import os, sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def plot_bms_freq(input_csv):
    """
    plot bms model frequency
    """
    df = pd.read_csv(input_csv,index_col=None)
    f = df.sort_values('model_frequency', ascending=False)[['model_frequency','exceedance_prob']].plot.bar()
    f.get_figure().savefig('./figs/fmri_freq.pdf')

if __name__ == "__main__":
    plot_bms_freq('./output/fmri.csv')    
    