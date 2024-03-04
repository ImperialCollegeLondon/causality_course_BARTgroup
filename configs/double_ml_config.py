from ml_collections import ConfigDict
from pathlib import Path

def get_config():
    config = ConfigDict()
    config.dataA_path = str(Path(__file__).parent.parent) + "/project_code/data/dataA.csv"
    config.dataB_path = str(Path(__file__).parent.parent) + "/project_code/data/dataB.csv"
    config.dataC_path = str(Path(__file__).parent.parent) + "/project_code/data/dataC.csv"
    config.dataD_path = str(Path(__file__).parent.parent) + "/project_code/data/dataD.csv"
    return config