from doubleml import DoubleMLData, DoubleMLPLR
import pandas as pd
from xgboost import XGBRegressor
from scipy.stats import norm
from configs.double_ml_config import get_config
import numpy as np


config = get_config()
data = pd.read_csv(config.dataA_path).drop(["x_2","x_21","x_24"], axis=1)
N, p = data.shape
# Construct DoubleMLData object
dml_data = DoubleMLData(data, y_col='Y', d_cols='A',
                        x_cols=data.columns.drop(["Y", "A"]).to_list())
# For continuous treatment (E[Y|X])
ml_l_xgb = XGBRegressor(objective = "reg:squarederror", eta = 0.1,
                        n_estimators =100)

# For binary treatment (E[D|X])
ml_m_xgb = XGBRegressor(objective = "reg:squarederror", eta = 0.1,
                        n_estimators =100)

# Specify the model object with supplied data
dml_plr_tree = DoubleMLPLR(dml_data,
                            ml_l = ml_l_xgb,
                            ml_m = ml_m_xgb,
                            n_folds = 5,
                            n_rep = 1,
                            score = 'partialling out',
                            dml_procedure = 'dml2')

# Estimate parameters
dml_plr_tree.fit()
# Obtain coefficients
coef = dml_plr_tree.coef[0]
# Obtain standard error
se = dml_plr_tree.se[0]
# Construct confidence interval
alpha = 0.05
n_std = norm.ppf(1.-(alpha/2.))
print(dml_plr_tree.summary)
print("Coefficient {}% 2-sided confidence interval: [{},{}]\n".format((1-alpha)*100, coef-n_std*se, coef+n_std*se))
print(dml_plr_tree.confint())