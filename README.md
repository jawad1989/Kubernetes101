
## Table Of Contents: 
  - [Kubernetes Objects](#kubernetes-objects)
  - [Kubernetes Architecture](#kubernetes-architecture)
  - [Tutorial: Building Kubernets Cluster with KUBEADM](#building-a-kubernetes-cluster-with-kubeadm)
*****************

## Kubernetes Objects

![Kube-Docker](https://github.com/jawad1989/Kubernetes101/blob/master/images/kuber-objects.jpeg)

* Kubernetes (K8s) is an open-source system for automating deployment, scaling, and management of containerized applications
 It groups containers that make up an application into logical units for easy management and discovery

* Kubernetes contains a number of abstractions that represent the state of your system: deployed containerized applications and workloads, their associated network and disk resources, and other information about what your cluster is doing. These abstractions are represented by objects in the Kubernetes API. See Understanding Kubernetes Objects for more details.

  * The basic Kubernetes objects include:

     *  Pod
     *  Service
     *  Volume
     *  Namespace
     
     ## Pod
      A pod (as in a pod of whales or pea pod) is a group of one or more containers (such as Docker containers), with shared storage/network, and a specification for how to run the containers.
      
    ## Replica Set
      A Replica Set ensures that a specified number of pod replicas are running at any one time. In other words, a Replica Set makes sure that a pod or a homogeneous set of pods is always up and available. A Replica set help you to define how many pods are available. If you define replica as three, then one pod die, the Replica Set create a pod to make it three.
      
      ### commands:
      ```
      kubectl create -f replicaset-definition.yml
      
      kubectl get replicaset
      
      kubectl delete replicaset myapp-replicaset
      
      kubectl replace -f replicaset-definition.yml
      
      kubectl scale --replicas=6 replicaset-definition.yml
      
      kubectl scale --replicas=2 replicaset myapp-replicaset
      ```
      
      replicaset-definition.yml
      ```
      apiVersion: apps/v1
      kind: ReplicaSet
      metadata:
        name: myapp-replicaset
        labels:
          app: myapp
          type: front-end

      spec:
        template:
          metadata:
            name: myapp-pod
            labels:
              app: myapp
              type: front-end
          spec:
            containers:
              - name: nginx-container
                image: nginx

        replicas: 3
        selector:
          matchLabels:
            type: front-end

      ```
      
    ## Deployment
      A Deployment controller provides declarative updates for Pods and ReplicaSets.You describe a desired state in a Deployment object, and the Deployment controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments. A Deployment include Pod(s) and Replica Set. It also help to update the resources when you deploy new version.
      
      Deployments allows you to specify a ***desired state*** for a set of pods. Cluster will constantly work to maintain that desired state.
      Examples:
      1. Scaling: you can specify # of replicas you want and it will create/remove pods to meet that #
      2. Rolling Updates: you can update your container image, it will gradually replace existing containers with new version
      3. Self Healing: if one of the pods accidently destroys, deployment will imeediately spin up a new one to replace it
  
      Create a deployment:
      ```
      cat <<EOF | kubectl create -f -
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx-deployment
        labels:
          app: nginx
      spec:
        replicas: 2
        selector:
          matchLabels:
            app: nginx
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.15.4
              ports:
              - containerPort: 80
      EOF
      ```
      Get a list of deployments:
      ```
      kubectl get deployments
      ```
      Get more information about a deployment:
      ```
      kubectl describe deployment nginx-deployment
      ```
      Get a list of pods:
      ```
      kubectl get pods
      ```
      You should see two pods created by the deployment.
     
     Some more exmplaes
     ```
     ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: httpd-frontend
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: myapp
      template:
        metadata:
          labels:
            app: myapp
        spec:
          containers:
            - name: myapp
              image: httpd:2.4-alpine

     ```

    ```
      ---
      apiVersion: apps/v1
      kind: deployment
      metadata:
        name: deployment-1
      spec:
        replicas: 2
        selector:
          matchLabels:
            name: busybox-pod
        template:
          metadata:
            labels:
              name: busybox-pod
          spec:
            containers:
              - name: busybox-container
                image: busybox888
                command:
                  - sh
                  - "-c"

      ```
    ## Service
      A Kubernetes Service is an abstraction which defines a logical set of Pods and a policy by which to access them - sometimes called a micro-service. If you create a pod, you don’t know where it is. Also, a pod might be killed by someone or some shortage of a node. Service provide an endpoint of the pods for you.
      Service creates a abstraction layer on top of set of replica pods. You can access the service rater than accessing pods directly, so pods come and go, you get un interrupted, dynamic accessto whatever replicas are up at the time.
      
      Create a NodePort service on top of your nginx pods:
      ```
      cat << EOF | kubectl create -f -
      kind: Service
      apiVersion: v1
      metadata:
        name: nginx-service
      spec:
        selector:
          app: nginx
        ports:
        - protocol: TCP
          port: 80
          targetPort: 80
          nodePort: 30080
        type: NodePort
      EOF

      ```
      Get a list of services in the cluster.

      ```
      kubectl get svc
      
      or 
      
      kubectl get service
      ```
      You should see your service called nginx-service.
      Since this is a NodePort service, you should be able to access it using port 30080 on any of your cluster's servers. You can test this with the command:

      ```
      curl localhost:30080

      ```
      You should get an HTML response from nginx, you can also access this service from browser using public ip or domain.
      ![k8s service](https://github.com/jawad1989/Jenkins101/blob/master/images/k8s-service.PNG)
      
    ## Storage Class
      A StorageClass provides a way for administrators to describe the “classes” of storage they offer. It represent a Persistent Volume like Azure Disk or Azure File or some other storage.

    ## Persistent Volume Claim
     Presistent Volume Claim is the abstruction of the Persistent Volume. Persistent Volume is physical resources of inflastructure. Kubernetes want to hide the detail from developers. Using Persistent Volume Claim, you can hide the physical declaration defined by Persistent Volume or Storage Class. Pod can mount the Volume using Persistent Volume Claim object.

## kubeadm: 
the command to bootstrap the cluster.

## kubelet: 
the component that runs on all of the machines in your cluster and does things like starting pods and containers.

## kubectl:
the command line util to talk to your cluster.

## basic commands
Get a list of system pods running in the cluster:
```
kubectl get pods -n kube-system
```

Check the status of the kubelet service:
```
sudo systemctl status kubelet
```

![arch](https://github.com/jawad1989/Kubernetes101/blob/master/images/kubectl%20-architecture.PNG)
# YAML in k8s

inputs for creation of objects such as deployments, services etc

* required fields

* Kind = apiVersion:
  ```
  POD = V1
  Service = V1
  ReplicaSet = apps/v1
  Deployment = apps/v1
  ```
  * Meta Data
  Form of dictionary
  
  * Spec
  Additional information, containers acts as an array, can give multiple containers here
  ```
  spec:
    containers:
      - name: nginx-controller
        image: nginx
  ```
  
sample.yaml
```
apiVersion:
kind:
metadata:

spec:
```

* To Run 
```
kubectl create -f pod-definition.yaml
```

# Kubernetes Architecture

* Api Server: front end for kubernetes 
* Etcd: distriubuted key value store for data used to manage k8s cluster, logs .
* Scheduler: distributing work across nodes. 
* Controller: brain behind nodes, containers and end points. Decision maker
* Container Run time: underline software to run container e.g. docker
* kubelet: agent to run on each node

![Kube-Docker](https://github.com/jawad1989/Kubernetes101/blob/master/images/1_rYlLHqzV3LgEo19J0M904A.jpeg)


Kubernetes enable you to use the cluster as if it is signle PC. You don’t need to care the detail of the infrastructure. Just declare the what you want in yaml file, you will get what you want.
When you use Kubernetes, you can use kubectl command to control the kubernetes cluster. It works with config file. If it is Azure, you can get it by az aks get-credentials command. Once you execute the command, it send request to the kubernetes cluster via Rest API, it create a Pod. A pod can include one or several containers inside it. Kubernetes download the image from DockerHub or Azure Container Registry. The kubernetes cluster has several nodes. However, Kubernetes allocate the pod in some node. Then you need to know which pod is on which node. Kubernetes looks after it for you.


![kubernetes-architecture](https://github.com/jawad1989/Kubernetes101/blob/master/images/architecture-kuber.jpeg)

Kubernetes has several Master nodes and Worker nodes. Your containers work on Worker nodes. Worker nodes scales.
Once you deploy kubernetes resources using Yaml file with kubectl command, it send Post request to the API server. The API server store the data into ectd, which is the distributed key value store. Other resources like Controller Manager, Scheduler, observe the change state of the API server. When you create a some.yaml file with a deployment then kubectl create -f some.yaml It send the yaml data to the API Server. It create a Deployment object on the API Server. Deployment controller detect the change of the deployment, it create ReplicaSet object on the API Server. The Replica Set Controller detect the change then according to the number of replica, create Pod objects. The Scheduler, that is in charge of the pod resource allocation, commnd the kubelet, which reside on every worker nodes, execute docker command and create containers. Every worker nodes have a kube proxy to control the routing. For example, If you create a service object on the API Server, Endpoint Controller create an Endpoint object on the API Server. Kube Proxy watch the API server Endpoint state, then configure iptable to route the endpoint to the container.


**************
# Commands

```
```
Get cluster Info
```
kubectl cluster-info
```

## Create a pod 
pods have unique ips and they run on a node, a node can have more then one pod

Create a simple pod running an nginx container:
```
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
EOF
```
Get a list of pods and verify that your new nginx pod is in the Running state:
```
kubectl get pods
```
Get more information about your nginx pod:
```
kubectl describe pod nginx
```
Delete the pod:
```
kubectl delete pod nginx
```


# view nodes
Get a list of nodes:
```
kubectl get nodes
```
Get more information about a specific node:
```
kubectl describe node $node_name
```

# Kubernetes Network Example 
create a deployment with two pods then one more busy box to test network

Create a deployment with two nginx pods:
```
cat << EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.4
        ports:
        - containerPort: 80
EOF
```
Create a busybox pod to use for testing:

```
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    args:
    - sleep
    - "1000"
EOF
```

Get the IP addresses of your pods:

```
kubectl get pods -o wide
```

Get the IP address of one of the nginx pods, then contact that nginx pod from the busybox pod using the nginx pod's IP address:
```
kubectl exec busybox -- curl $nginx_pod_ip
in our case: exec busybox -- curl 10.244.1.10
```

# Kubernetes Service Example

1. Log in to the Kube master node.
2. Create the deployment with four replicas:
```
cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: store-products
  labels:
    app: store-products
spec:
  replicas: 4
  selector:
    matchLabels:
      app: store-products
  template:
    metadata:
      labels:
        app: store-products
    spec:
      containers:
      - name: store-products
        image: linuxacademycontent/store-products:1.0.0
        ports:
        - containerPort: 80
EOF
```
3. Create a service for the store-products pods:
```
cat << EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: store-products
spec:
  selector:
    app: store-products
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
EOF
```

4. Make sure the service is up in the cluster:
```
kubectl get svc store-products
```

5. The output will look something like this:
```
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
store-products   ClusterIP   10.104.11.230   <none>        80/TCP    59s
```

6. Use kubectl exec to query the store-products service from the busybox testing pod.
```
kubectl exec busybox -- curl -s store-products
```

output
```
 kubectl exec busybox -- curl -s store-products
{
        "Products":[
                {
                        "Name":"Apple",
                        "Price":1000.00,
                },
                {
                        "Name":"Banana",
                        "Price":5.00,
                },
                {
                        "Name":"Orange",
                        "Price":1.00,
                },
                {
                        "Name":"Pear",
                        "Price":0.50,
                }
        ]

```

# Stans Robot Shop Microservice Example

this example takes use of many microservices deployed in different technologies like mongo,rabbiqmq, mysql etc and deploys them using simple K8s commads

![K8s](https://github.com/jawad1989/Kubernetes101/blob/master/images/k8s-microservices.PNG)

to delete the previous service as this also uses port `30080`
```
kubectl delete svc nginx-service
```
Here are the commands used in the demonstration to deploy the Stan's Robot Shop application:

Clone the Git repository:
```
cd ~/
git clone https://github.com/linuxacademy/robot-shop.git
```

Create a namespace and deploy the application objects to the namespace using the deployment descriptors from the Git repository:

```
kubectl create namespace robot-shop
kubectl -n robot-shop create -f ~/robot-shop/K8s/descriptors/
```
Get a list of the application's pods and wait for all of them to finish starting up:
```
kubectl get pods -n robot-shop -w
```
Once all the pods are up, you can access the application in a browser using the public IP of one of your Kubernetes servers and port 30080:
```
http://$kube_server_public_ip:30080
```
![deployed](https://github.com/jawad1989/Kubernetes101/blob/master/images/k8s%20-%20deployed.PNG)


# Monitoring the Cluster Components

We are able to monitor the CPU and memory utilization of our pods and nodes by using the metrics server. In this lesson, we’ll install the metrics server and see how the kubectl top command works.

Clone the metrics server repository:

```
git clone https://github.com/linuxacademy/metrics-server
```

Install the metrics server in your cluster:
```
kubectl apply -f ~/metrics-server/deploy/1.8+/
```

Get a response from the metrics server API:
```
kubectl get --raw /apis/metrics.k8s.io/
```

Get the CPU and memory utilization of the nodes in your cluster:

```
kubectl top node
```

Get the CPU and memory utilization of the pods in your cluster:

```
kubectl top pods
```

Get the CPU and memory of pods in all namespaces:

```
kubectl top pods --all-namespaces
```

Get the CPU and memory of pods in only one namespace:

```
kubectl top pods -n kube-system
```

Get the CPU and memory of pods with a label selector:

```
kubectl top pod -l run=pod-with-defaults
```

Get the CPU and memory of a specific pod:

```
kubectl top pod pod-with-defaults
```

Get the CPU and memory of the containers inside the pod:

```
kubectl top pods group-context --containers
```


# use ful commands

```
kubectl get pods
kubectl get pods -o wide
```


You can delete all the pods in a single namespace with this command:
```
kubectl delete --all pods --namespace=foo
```

You can also delete all deployments in namespace which will delete all pods attached with the deployments corresponding to the namespace
```
kubectl delete --all deployments --namespace=foo
```

You can delete all namespaces and every object in every namespace (but not un-namespaced objects, like nodes and some events) with this command:
```
kubectl delete --all namespaces
```

Create name space
```
kubectl create namespace robot-shop
```

create pods in namespace using yml files
```
kubectl -n robot-shop create -f ~/robot-shop/K8s/descriptors/
```

get live status of pods 
```
kubectl get pods -n robot-shop -w
```

delete service
```
kubectl delete svc nginx-service
```


```
kubectl get cs
```

```
kubectl get ep
```


```
sudo kubectl get all --namespace=kube-system
```



# Trouble Shoot:

if for some reason the nodes are "NOT READY" apply below steps


```
ubuntu@ip-172-31-59-196:~/.kube/metrics$ kubectl get nodes
NAME               STATUS     ROLES    AGE   VERSION
ip-172-31-49-109   NotReady   <none>   31m   v1.12.7
ip-172-31-55-228   NotReady   <none>   38m   v1.12.7
ip-172-31-59-196   NotReady   master   39m   v1.12.7
ip-172-31-62-130   NotReady   <none>   38m   v1.12.7

```
also check `kubectl describe nodes
```
runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized
```

apply below steps
```
1) Weave

$ export kubever=$(kubectl version | base64 | tr -d '\n')
$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
After executing those two commands you should see node in status "Ready"

$ kubectl get nodes
You could also check status

$ kubectl get cs
```
