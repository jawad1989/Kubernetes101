
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
 # Source
 https://kubernetes.io/docs/reference/kubectl/conventions/
 

# Notes

to access service from other namespsace use below DNS name 
```
db-service.dev.svc.cluster.local
```
