#Adapted from: https://airflow.apache.org/docs/apache-airflow/stable/howto/operator/python.html
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

import time
from datetime import datetime

default_args = {
    'start_date': datetime(2019, 1, 1)
}

def my_sleeping_function(random_base):
    """This is a function that will run within the DAG execution"""
    time.sleep(random_base)

with DAG(dag_id='dagme', schedule_interval='* * * * *', default_args=default_args, catchup=False) as dag:
    
    run_this = PythonOperator(
        task_id='sleep_parent',
        python_callable=my_sleeping_function,
        op_kwargs={'random_base': float(1) / 10},
        dag=dag,
    )