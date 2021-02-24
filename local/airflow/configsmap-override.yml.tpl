---
apiVersion: v1
kind: ConfigMap
metadata:
  name: airflow-config-webserver
data:
  AIRFLOW__WEBSERVER__BASE_URL: http://localhost:30880
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: airflow-config-kubernetes
data:
  AIRFLOW__KUBERNETES__DELETE_WORKER_PODS: "False"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: airflow-config-kubernetes-template
data:
  airflow_template.yml: |
    ---
    #Note: This file was generated with "airflow generate_pod_template" and then edited
    apiVersion: v1
    kind: Pod
    metadata:
      name: airflow-worker
      namespace: airflow
      labels:
        app: airflow-worker
    spec:
      serviceAccountName: airflow
      volumes:
        - emptyDir: {}
          name: airflow-logs
        - name: pod-template-file
          configMap:
            name: airflow-config-kubernetes-template
            defaultMode: 0444
        - name: secrets
          secret:
            secretName: airflow-secrets
        - name: dags
          hostPath:
            path: $CURRENT_DIR/dags
      containers:
        - args: []
          command: []
          env:
            - name: AIRFLOW__CORE__EXECUTOR
              value: LocalExecutor
            - name: AIRFLOW__KUBERNETES__POD_TEMPLATE_FILE
              value: /opt/airflow/k8/airflow_template.yaml
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
            - secretRef:
                name: airflow-smtp
            - secretRef:
                name: airflow-fernet-key
            - secretRef:
                name: airflow-webserver-flask-key
            - secretRef:
                name: airflow-db-connection
          image: apache/airflow:1.10.14-python3.7
          imagePullPolicy: IfNotPresent
          name: base
          ports: []
          volumeMounts:
            - name: airflow-logs
              mountPath: /home/airflow/airflow/logs
            - name: pod-template-file
              mountPath: /opt/airflow/k8
              readOnly: true
            - name: dags
              mountPath: /opt/airflow/dags
              readOnly: true
            - name: secrets
              mountPath: /opt/airflow/secrets
              readOnly: true
      hostNetwork: false
      imagePullSecrets: []
      initContainers: []
      nodeSelector: {}
      restartPolicy: Never
      securityContext:
        runAsUser: 50000