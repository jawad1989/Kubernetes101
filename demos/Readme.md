1) Create docker image

we will create a static website and create a docker image using Dockerfile

Dockerfile
```
FROM nginx:alpine
COPY . /usr/share/nginx/html
```
index.html
```
this is jawad saleem
```

build Dockerfile
```
docker build -t htmlnginx .
```

2) push docker image

connect your docker hub account
```
docker login
docker tag <image_id> jawadxiv/htmlnginx:v1
docker push jawadxiv/htmlnginx:v1
````

3) create deployment and svc

we will create a nodePort service and deployment using our image from dockerhub
deployment-defi.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: config-example
spec:
  selector:
    app: config-example
  ports:
    - protocol: TCP
      port: 80
      nodePort: 30083
  type: NodePort
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: config-example
spec:
  replicas: 1
  selector:
    matchLabels:
      app: config-example
  template:
    metadata:
      labels:
        app: config-example
    spec:
      containers:
        - name: config-example
          image: jawadxiv15/htmlnginx:v1
          ports:
            - containerPort: 80
```

goto browser http://<master-ip>:30083
