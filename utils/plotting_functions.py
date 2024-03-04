from typing import Union

import matplotlib as matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

plt.style.use('ggplot')
matplotlib.rcParams.update({
    'font.family': 'serif',
    'text.usetex': True,
    'pgf.rcfonts': False,
    'text.latex.preamble': r"\usepackage{amsmath}"
})


def forest_plot(names:Union[list,np.ndarray, pd.Series], estimates:Union[list,np.ndarray, pd.Series], lower_limits:Union[list,np.ndarray, pd.Series], upper_limits:Union[list,np.ndarray, pd.Series], save_path:str,alpha:float, true_value: float, method:str)->None:
    """
    Plot a point-plot of parameter estimate along with alpha-quantile confidence intervals
        :param names: Names of each dataset used
        :param estimates: Point parameter estimate
        :param lower_limits: Lower quantile value
        :param upper_limits: Upper quantile value
        :param alpha: Quantile PPF
        :param save_path: Path to save image
        :param true_value: True parameter value
        :param method: Indicator for score function used in Double ML.
        :return: None
    """
    plt.scatter(names, estimates, color='blue')
    plt.errorbar(names, estimates, yerr=[estimates - lower_limits, upper_limits - estimates],
                 fmt='none', color='blue', capsize=5, capthick=2, label="{}\% 2-sided CI".format((1. - alpha)*100))
    plt.hlines(true_value, xmin=names[0], xmax=names[-1], label="True ATE", linestyles="dashed")
    # Customize the plot
    score_f = "$\psi_{2}$" if method=="IV-type" else "$\psi_{1}$"
    plt.title('ATE Estimates using {}'.format(score_f))
    plt.xlabel('Dataset Names')
    plt.ylabel('ATE Estimate')
    plt.legend()
    plt.savefig(save_path)
    plt.show()
