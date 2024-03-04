from ml_collections import ConfigDict
from pathlib import Path

def get_config():
    config = ConfigDict()
    config.dataA_path = str(Path(__file__).parent.parent) + "/project_code/data/dataA.csv"
    config.dataB_path = str(Path(__file__).parent.parent) + "/project_code/data/dataB.csv"
    config.dataC_path = str(Path(__file__).parent.parent) + "/project_code/data/dataC.csv"
    config.dataD_path = str(Path(__file__).parent.parent) + "/project_code/data/dataD.csv"
    config.alpha = 0.05
    config.n_trees = 200
    config.n_folds = 5
    config.n_reps = 1
    config.true_ATE = -100
    config.score_func = 'IV-type' # vs  "partialling out"
    config.image_path = str(Path(__file__).parent.parent) + "/pngs/{}Alpha_{}NTrees_{}NFolds_{}NReps_{}ScoreF.png".format(config.alpha, config.n_trees, config.n_folds, config.n_reps, config.score_func)
    return config