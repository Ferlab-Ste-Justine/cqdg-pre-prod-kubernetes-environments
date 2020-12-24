#Pod to troubleshoot random stuff with scripts and the airflow client
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: airflow-playground
  namespace: airflow
  labels:
    app: airflow-playground
spec:
  replicas: 1
  selector:
    matchLabels:
      app: airflow-playground
  template:
    metadata:
      labels:
        app: airflow-playground
    spec:
      serviceAccountName: airflow
      volumes:
        - name: pod-template-file
          configMap:
            name: airflow-config-kubernetes-template
            defaultMode: 0444
        - name: scripts
          configMap:
            name: airflow-scripts
            defaultMode: 0555
        - name: secrets
          secret:
            secretName: airflow-secrets
        - name: troubleshoot
          hostPath:
            path: $CURRENT_DIR/troubleshoot
      containers:
        - name: airflow-scheduler
          image: apache/airflow:1.10.14-python3.7
          volumeMounts:
            - name: pod-template-file
              mountPath: /opt/airflow/k8
              readOnly: true
            - name: secrets
              mountPath: /opt/airflow/secrets
              readOnly: true
            - name: troubleshoot
              mountPath: /opt/airflow/troubleshoot
              readOnly: true
          env:
            - name: AIRFLOW__CORE__EXECUTOR
              value: KubernetesExecutor
            - name: AIRFLOW__KUBERNETES__POD_TEMPLATE_FILE
              value: /opt/airflow/k8/airflow_template.yml
          envFrom:
            - configMapRef:
                name: airflow-config-core
            - configMapRef:
                name: airflow-config-secrets
            - configMapRef:
                name: airflow-config-cli
            - configMapRef:
                name: airflow-config-api
            - configMapRef:
                name: airflow-config-operators
            - configMapRef:
                name: airflow-config-webserver
            - configMapRef:
                name: airflow-config-email
            - configMapRef:
                name: airflow-config-scheduler
            - configMapRef:
                name: airflow-config-kubernetes
            - secretRef:
                name: airflow-smtp
            - secretRef:
                name: airflow-fernet-key
            - secretRef:
                name: airflow-webserver-flask-key
            - secretRef:
                name: airflow-db-connection
          command:
            - sleep
          args:
            - infinity