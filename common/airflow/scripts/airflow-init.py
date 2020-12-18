import subprocess

if __name__ == '__main__':
    subprocess.check_call(['airflow', 'db', 'init'])