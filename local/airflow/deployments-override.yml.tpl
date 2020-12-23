---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: airflow-scheduler
  namespace: airflow
spec:
  template:
    spec:
      volumes:
        - name: dags
          hostPath:
            path: $CURRENT_DIR/dags
      containers:
        - name: airflow-scheduler
          volumeMounts:
            - name: dags
              mountPath: /opt/airflow/dags
              readOnly: true
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: airflow-webserver
  namespace: airflow
spec:
  template:
    spec:
      volumes:
        - name: dags
          hostPath:
            path: $CURRENT_DIR/dags
      containers:
        - name: airflow-webserver
          volumeMounts:
            - name: dags
              mountPath: /opt/airflow/dags
              readOnly: true