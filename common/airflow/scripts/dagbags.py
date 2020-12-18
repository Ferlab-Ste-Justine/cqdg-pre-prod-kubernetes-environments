import os
from airflow.models import DagBag

def load_dags(directory):
    for elem in os.listdir(directory):
        path = os.path.join(directory, elem)
        if os.path.isdir(path):
            dag_bag = DagBag(path)
            if dag_bag:
                for dag_id, dag in dag_bag.dags.items():
                    globals()[dag_id] = dag

load_dags(os.environ.get('DAGS_DIR'))
