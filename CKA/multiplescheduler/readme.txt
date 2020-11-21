### 1. Copy file from '/etc/kubernetes/manifests/kube-scheulder.yaml'
### 2. update file accordingly
there was a taint applied on kubemaster
```
kubectl describe nodes kubemaster | grep Taint
Taints:             node-role.kubernetes.io/master:NoSchedule
```
to fix that add taint toleration in pod spec

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    component: kube-scheduler
    tier: control-plane
  name: my-custom-scheduler
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
    - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
    - --bind-address=127.0.0.1
    - --kubeconfig=/etc/kubernetes/scheduler.conf
    - --leader-elect=false
    - --scheduler-name=my-custom-scheduler
    - --port=10282
    - --secure-port=0
    image: k8s.gcr.io/kube-scheduler:v1.18.5
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10282
        scheme: HTTP
      initialDelaySeconds: 15
      timeoutSeconds: 15
    name: my-custom-scheduler
    resources:
      requests:
        cpu: 100m
    volumeMounts:
    - mountPath: /etc/kubernetes/scheduler.conf
      name: kubeconfig
      readOnly: true
  hostNetwork: true
  priorityClassName: system-cluster-critical
  nodeSelector:
    type: masternode
  tolerations:
    - key: "node-role.kubernetes.io/master"
      operator: "Exists"
      effect: "NoSchedule"
  volumes:
  - hostPath:
      path: /etc/kubernetes/scheduler.conf
      type: FileOrCreate
    name: kubeconfig
status: {}

```

### 3. create a pod to test the new schedular
```
apiVersion: v1
kind: Pod
metadata:
  name: custom-pod
  labels:
    name: myapp
spec:
  containers:
  - name: nginx-scheduler
    image: nginx
    
  schedulerName: my-custom-scheduler  
```

### 4. get events to test pod scheduled with new scheduler
```
kubectl get events -o wide
```
