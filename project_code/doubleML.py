from typing import Union

from doubleml import DoubleMLData, DoubleMLPLR, DoubleMLPLIV
import pandas as pd
from ml_collections import ConfigDict
from xgboost import XGBRegressor, XGBClassifier
from scipy.stats import norm
from configs.double_ml_config import get_config
import numpy as np
from sklearn.ensemble import  RandomForestRegressor, GradientBoostingRegressor
from sklearn.base import clone

from utils.plotting_functions import forest_plot


def estimate_ATE(dml_plr_tree: Union[DoubleMLPLIV,DoubleMLPLR], alpha: float) -> np.ndarray:
    """
    Estimate the ATE Confidence Interval given a model and a confidence level
    :param dml_plr_tree: Model to fit
    :param alpha: Confidence Level
    :return: Confidence Interval for ATE
    """
    # Fit and estimate parameters
    dml_plr_tree.fit()
    # Obtain coefficients
    coef = dml_plr_tree.coef[0]
    # Obtain standard error
    se = dml_plr_tree.se[0]
    # Construct confidence interval
    n_std = norm.ppf(1. - (alpha / 2.))
    print("Coefficient {}% 2-sided confidence interval: [{},{}]\n".format((1 - alpha) * 100, coef - n_std * se, coef + n_std * se))
    return np.array([coef - n_std * se, coef,  coef + n_std * se])


def double_ml(data: pd.DataFrame, config:ConfigDict) -> np.ndarray:
    """
    Double ML pipeline for ATE inference
    :param data: Pandas Dataframe
    :param config: ML Experiment Configuration File
    :return: Confidence interval for ATE
    """
    assert ("Y" in data.columns and "A" in data.columns)
    assert (0. < config.alpha < 1.)
    # Construct DoubleMLData object
    dml_data = DoubleMLData(data, y_col='Y', d_cols='A',
                            x_cols=data.columns.drop(["Y", "A"]).to_list())
    # For estimating E[Y|X]
    ml_l = XGBRegressor(objective="reg:squarederror", eta=0.1,
                            n_estimators=config.n_trees)

    # For estimating E[A|X], where A is binary.
    ml_m = XGBClassifier(use_label_encoder = False ,
                        objective = "binary:logistic",
                        eval_metric = "logloss",
                        eta = 0.1, n_estimators = config.n_trees)

    # Specify the model object with supplied data
    dml_plr_tree = DoubleMLPLR(dml_data,
                               ml_l = ml_l,
                               ml_g=clone(ml_l),
                               ml_m=ml_m,
                               n_folds=config.n_folds,
                               n_rep=config.n_reps,
                               score=config.score_func,
                               dml_procedure='dml2')

    return estimate_ATE(dml_plr_tree=dml_plr_tree, alpha=config.alpha)


def prepare_data(config: ConfigDict) -> dict:
    """
    Prepare datasets for doubleML pipeline
    :param config: Configuration File
    :return: Dictionary with datasets
    """
    dataA = pd.read_csv(config.dataA_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataA_uneven = pd.read_csv(config.dataA_uneven_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataB = pd.read_csv(config.dataB_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataB_uneven = pd.read_csv(config.dataB_uneven_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataC = pd.read_csv(config.dataC_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataC_uneven = pd.read_csv(config.dataC_uneven_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataD = pd.read_csv(config.dataC_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    dataD_uneven = pd.read_csv(config.dataD_uneven_path, index_col=[0]).drop(["x_2", "x_21", "x_24"], axis=1)
    return {"A":dataA, "A_unev":dataA_uneven,"B":dataB, "B_unev":dataB_uneven,"C":dataC, "C_unev":dataC_uneven, 'D':dataD, "D_unev":dataD_uneven}




if __name__ == "__main__":
    config = get_config()
    assert(config.alpha == 0.05)
    data_sets = prepare_data(config)
    ATEs = pd.DataFrame(None, index=np.array(data_sets.keys()), columns=["{}%".format((config.alpha/2)*100), "Mean", "{}%".format((1.-config.alpha/2)*100)])
    for key in data_sets.keys():
        k = double_ml(data_sets[key], config=config)
        ATEs.loc[key,:] = k

    forest_plot(names=ATEs.index, estimates=ATEs.iloc[:, 1], lower_limits=ATEs.iloc[:, 0], upper_limits=ATEs.iloc[:, 2],save_path=config.image_path, alpha=config.alpha, true_value=config.true_ATE, method=config.score_func)