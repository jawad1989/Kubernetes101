
# Imperative Commands
 
 imperative commands can help in getting one time tasks done quickly, as well as generate a definition template easily.
 
 1. --dry-run: By default as soon as the command is run, the resource will be created. If you simply want to test your command, use the --dry-run=client option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.
 2. -o yaml: This will output the resource definition in YAML format on the screen.
 
 
 ### Create POD
 ```
 kubectl run nginx --image=nginx
 
 kubectl run nginx --image=nginx  --dry-run=client -o yaml
 ```
 
 ### Create Deployemnt
 ```
 kubectyl create deployment --image=nginx nginx
 
 kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
 
 kubectl create deployment webapp --image=kodekloud/webapp-color.
  ```
 
 To scale
 ```
 kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml
 ```
 
 ### Service
 
 Cluster IP
 ```
 kubectl expose pod nginx --port=6379 --name redis-service --dry-run=client -o yaml
 kubectl expose pod httpd --port=80 --name=httpd --dry-run=client -o yaml
 
 or 
 
 kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml
 
 ```
 
 
 
 Node Port
 
 ```
 kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml
 
 (This will automatically use the pod's labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.)
 
 or
 
 kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml
 kubectl create service nodeport myservice --node-port=31000 --tcp=3050:80
 (This will not use the pods labels as selectors)
 ```
 
 # Scale 

```
kubectl create deployment webapp --image=kodekloud/webapp-color.

kubectl scale deployment/webapp --replicas=3
```

# Expose Pod on container Port

```
kubectl run custom-nginx --image=nginx --port=8080 --dry-run=client -o yaml
```

# Expose Service and create POD one command

```
kubectl run httpd --image=httpd:alpine --port=80 --expose
```


# commands and Arguments

Command overwrites ENTRYPOINT of dockerfile, where as args overwrite CMD
```
Dockerfile

FROM Ubuntu
ENTRYPOINT ["sleep"]
CMD ["5"]


pod-defination.yml
---
apiVersion: v1
kind: Pod
metadata: 
  name: ubuntu-js
spec:
  containers:
    - name: ubuntu-js
      image: ubuntu-js
      command: ["sleep2.0"]
      args: ["10"]
```


```
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-3
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command:
      - "sleep"
      - "1200"
```

update default cmd of blue to green
```
apiVersion: v1
kind: Pod
metadata:
  name: webapp-green
  labels:
      name: webapp-green
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    args: ["--color", "green"]
```

# ENV Variables 
docker run -e APP_COLOR=pink myapp
```
spec:
  containers:
    - name: myapp
      image: nginx
      env:
        - name: APP_COLOR
          value: pink

```

ENV Vs Config Map vs Secrets
```
env:
  - name: APP_COLOR
    value: pink
```

 ConfigMap
 ```
 env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: APP_COLOR
 ```
 
 Secrets
 ```
 env:
  - name: APP_COLOR
    valueFrom:
      secretKeyRef:
```

# ConfigMap

two steps:
1) Create ConfigMap
2) Inject ConfigMap into Pod 
```
kubectl create configmap my-app-config --from-literal=APP_COLOR=blue

kubectl create configmap my-app-config --from-literal=APP_COLOR=blue \ 
--from-literal=APP_MOD=prod

```

from file
```
kubectl create configmap my-app-config --from-file=<path-to-file>
kubectl create configmap my-app-config --from-file=app_config.properties

```


declarative

Configmap.yaml
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
```
Pod Definition
```
apiVersion: v1
kind: Pod
metadata:
  name: my-app
  labels:
    name: my-app
spect:
  containers:
    - name: my-app
      image: nginx
      ports:
        - containerPort: 8080
      envFrom:
        - configMapRef:
            name: app-config
```

### Single value vs Multiple vs Volumes

Single Env use: 
```
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
       name: app-config
       key: APP_COLOR
```

MultipleEnv: 
```
envFrom:
  - configMapRef:
      name: app-config
```               
             

Volumes:
```
volumes:
- name: app-config-vol
  configMap:
    name: app-config
```
### config Map and Kubernetes
https://agenda.fest.ansible.com/sessions

https://www.youtube.com/watch?v=Jk0N-drqXvY


https://cloud.spring.io/spring-cloud-kubernetes/reference/html/#why-do-you-need-spring-cloud-kubernetes
https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-files

dependency:
https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-kubernetes-config

https://start.spring.io/#!type=maven-project&language=java&platformVersion=2.3.4.RELEASE&packaging=jar&jvmVersion=11&groupId=com.example&artifactId=demo-lab-kubernetes-config-spring&name=demo-lab-kubernetes-config-spring&description=Demo%20project%20for%20Spring%20Boot&packageName=com.example.demo-lab-kubernetes-config-spring&dependencies=web,actuator

https://www.youtube.com/watch?v=jR35JKq5rmc

https://spring.io/blog/2020/04/23/spring-tips-configuration

https://medium.com/@ard333/centralized-configuration-spring-application-on-kubernetes-4fd9e1a31f35

https://www.youtube.com/watch?v=gb1i4WyWNK4

https://cloud.spring.io/spring-cloud-config/reference/html/


# Source
 https://kubernetes.io/docs/reference/kubectl/conventions/
 https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create
 

# Notes

to access service from other namespsace use below DNS name 
```
db-service.dev.svc.cluster.local
```
