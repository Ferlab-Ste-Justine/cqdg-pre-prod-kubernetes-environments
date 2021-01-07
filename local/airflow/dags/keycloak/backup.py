"""
Placeholder DAG to validate jobs are running properly
"""
from datetime import timedelta
import time
from airflow import DAG
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.kubernetes.secret import Secret
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(2),
    'email': ['noop@ferlab.bio'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(hours=1)
}

POSTGRES_SECRETS = [
    Secret('env', 'DB_USER', 'keycloak-db-credentials', 'username'),
    Secret('env', 'DB_PASSWORD', 'keycloak-db-credentials', 'password')
]

S3_SECRETS = [
    Secret('env', 'S3_ACCESS_KEY', 's3-credentials', 'S3_ACCESS_KEY'),
    Secret('env', 'S3_SECRET_KEY', 's3-credentials', 'S3_SECRET_KEY')
]

with DAG(
    'keycloak-backups',
    default_args=default_args,
    description='DAG to manage keycloak database backups',
    schedule_interval=timedelta(hours=4)) as dag:

    backup = KubernetesPodOperator(
        name="keycloak-backup",
        task_id="keycloak-backup",
        namespace="airflow",
        labels={
            "app": "keycloak-backup"
        },
        image="chusj/postgres-backup:8c9df434bedb30a5d77e2419a00b0c9c8ece40b3",
        image_pull_policy="Always",
        cmds=["python3"],
        arguments=["/opt/backup.py"],
        get_logs=True,
        hostnetwork=False,
        in_cluster=True,
        configmaps = ['keycloak-backup'],
        secrets=(POSTGRES_SECRETS + S3_SECRETS)
    )

    prune_backups = KubernetesPodOperator(
        name="keycloak-backups-prune",
        task_id="keycloak-backups-prune",
        namespace="airflow",
        labels={
            "app": "keycloak-backups-prune"
        },
        image="chusj/postgres-backup:8c9df434bedb30a5d77e2419a00b0c9c8ece40b3",
        image_pull_policy="Always",
        cmds=["python3"],
        arguments=["/opt/prune-backups.py"],
        get_logs=True,
        hostnetwork=False,
        in_cluster=True,
        configmaps = ['keycloak-backup'],
        secrets=(POSTGRES_SECRETS + S3_SECRETS)
    )