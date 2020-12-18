from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator

from datetime import datetime

default_args = {
    'start_date': datetime(2019, 1, 1)
}

def something():
    return 'something'

with DAG(dag_id='dag_me_too', schedule_interval='* * * * *', default_args=default_args, catchup=False) as dag:
    
    task_1 = DummyOperator(task_id='task_1')

    task_2 = PythonOperator(task_id='task_2', python_callable=something)

    task_1 >> task_2
        