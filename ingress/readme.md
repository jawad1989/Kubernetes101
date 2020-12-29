1. deploy demo services and pods
2. configure metallb
3. install ingress - kubernetes using helm
4. create ingress resources
5. update /etc/hosts

# Demo

Create three deployments and three services
```
kubectl create deployment nginx-red --image=nginx
kubectl create deployment nginx-blue --image=nginx
kubectl create deployment nginx-green --image=nginx

kubectl expose deployment/nginx-red --port=80
kubectl expose deployment/nginx-blue --port=80
kubectl expose deployment/nginx-green --port=80
```
# update pods with different colors

exec pod, goto location and update index.html
```
cd /usr/share/nginx/html
cat /etc/*release*

apt-get update
apt-get install vim

vi index.html

```
change css and html of all three
```
body {
        width: 35em;
        margin: 0 auto;
        background-color: #3278bc; # change this to different colors
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }

```
## create ingress controller

create ns
```
kubectl create ns ingress-nginx
```

## install ingress-nginx(kubernetes)
>using helm
https://kubernetes.github.io/ingress-nginx/deploy/#using-helm
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install my-release ingress-nginx/ingress-nginx

```
metallb will assign an IP to your ingress service



## create ingress 

```
apiVersion: networking.k8s.io/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls
```
