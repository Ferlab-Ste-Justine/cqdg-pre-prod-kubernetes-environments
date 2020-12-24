import subprocess
import os
import json

from sqlalchemy import create_engine

CREATE_COMMAND = 'airflow users create -u {username} -f {firstname} -l {lastname} -r {role} -e {email} -p {password}'
DELETE_COMMAND = 'airflow users delete -u {username}'

def list_users():
    db = create_engine(os.environ.get('AIRFLOW__CORE__SQL_ALCHEMY_CONN'))
    users = db.execute("SELECT username FROM ab_user")
    return [user[0] for user in users]

def get_declared_users():
    with open('/opt/airflow/secrets/users.json') as f:
        return json.load(f)

if __name__ == '__main__':
    existing_usernames = list_users()
    declared_users = get_declared_users()
    declared_usernames = [declared_user['username'] for declared_user in declared_users]
    for declared_user in declared_users:
        if not declared_user['username'] in existing_usernames:
            subprocess.check_call(CREATE_COMMAND.format(**declared_user).split(" "))
    for existing_username in existing_usernames:
        if not existing_username in declared_usernames:
            subprocess.check_call(DELETE_COMMAND.format(username=existing_username).split(" "))