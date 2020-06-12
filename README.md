
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

# Kubernetes Architecture

![Kube-Docker](https://github.com/jawad1989/Kubernetes101/blob/master/images/1_rYlLHqzV3LgEo19J0M904A.jpeg)


Kubernetes enable you to use the cluster as if it is signle PC. You don’t need to care the detail of the infrastructure. Just declare the what you want in yaml file, you will get what you want.
When you use Kubernetes, you can use kubectl command to control the kubernetes cluster. It works with config file. If it is Azure, you can get it by az aks get-credentials command. Once you execute the command, it send request to the kubernetes cluster via Rest API, it create a Pod. A pod can include one or several containers inside it. Kubernetes download the image from DockerHub or Azure Container Registry. The kubernetes cluster has several nodes. However, Kubernetes allocate the pod in some node. Then you need to know which pod is on which node. Kubernetes looks after it for you.


![kubernetes-architecture](https://github.com/jawad1989/Kubernetes101/blob/master/images/architecture-kuber.jpeg)

Kubernetes has several Master nodes and Worker nodes. Your containers work on Worker nodes. Worker nodes scales.
Once you deploy kubernetes resources using Yaml file with kubectl command, it send Post request to the API server. The API server store the data into ectd, which is the distributed key value store. Other resources like Controller Manager, Scheduler, observe the change state of the API server. When you create a some.yaml file with a deployment then kubectl create -f some.yaml It send the yaml data to the API Server. It create a Deployment object on the API Server. Deployment controller detect the change of the deployment, it create ReplicaSet object on the API Server. The Replica Set Controller detect the change then according to the number of replica, create Pod objects. The Scheduler, that is in charge of the pod resource allocation, commnd the kubelet, which reside on every worker nodes, execute docker command and create containers. Every worker nodes have a kube proxy to control the routing. For example, If you create a service object on the API Server, Endpoint Controller create an Endpoint object on the API Server. Kube Proxy watch the API server Endpoint state, then configure iptable to route the endpoint to the container.


**************

# Building a Kubernetes Cluster with Kubeadm

* Install Docker on all three nodes.
* Install Kubeadm, Kubelet, and Kubectl on all three nodes.
* Bootstrap the cluster on the Kube master node.
* Join the two Kube worker nodes to the cluster.
* Set up cluster networking with flannel.


## Install Docker on all three nodes.

1. Do the following on all three nodes:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

sudo apt-get update

sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu

sudo apt-mark hold docker-ce
```

2. Verify that Docker is up and running with:

```
sudo systemctl status docker

```
Make sure the Docker service status is active (running)!

## Install Kubeadm, Kubelet, and Kubectl on all three nodes.

Install the Kubernetes components by running this on all three nodes:

```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet=1.12.7-00 kubeadm=1.12.7-00 kubectl=1.12.7-00
sudo apt-mark hold kubelet kubeadm kubectl
```

##  Bootstrap the cluster on the Kube master node. 
1. On the Kube master node, do this:

output
```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 172.31.55.93:6443 --token ri8d76.83ou0n14i3krqo8r --discovery-token-ca-cert-hash sha256:c74358c9d7e16f714a257a92a1594d119482604c0900c78f707952fbabbedc4f
```

Take note that the `kubeadm ini` command printed a long `kubeadm join` command to the screen. You will need that `kubeadm join` command in the next step!

2. Run the following on master
```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

3. Run the following commmand on the Kube master node to verify it is up and running:

```
kubectl version
```
This command should return both a `Client Version` and a `Server Version`.

##  Join the two Kube worker nodes to the cluster.


Copy the kubeadm join command that was printed by the kubeadm init command earlier, with the token and hash. Run this command on both worker nodes, but make sure you add sudo in front of it:
```
sudo kubeadm join $some_ip:6443 --token $some_token --discovery-token-ca-cert-hash $some_hash
```

Now, on the Kube master node, make sure your nodes joined the cluster successfully:
```
kubectl get nodes
```

Verify that all three of your nodes are listed. It will look something like this:
```
NAME            STATUS     ROLES    AGE   VERSION
ip-10-0-1-101   NotReady   master   30s   v1.12.2
ip-10-0-1-102   NotReady   <none>   8s    v1.12.2
ip-10-0-1-103   NotReady   <none>   5s    v1.12.2
```

Note that the nodes are expected to be in the NotReady state for now.

## Set up cluster networking with flannel.

Turn on iptables bridge calls on all three nodes:
```
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Next, run this only on the Kube master node:

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

Now flannel is installed! Make sure it is working by checking the node status again:

```
kubectl get nodes
```

After a short time, all three nodes should be in the Ready state. If they are not all Ready the first time you run kubectl get nodes, wait a few moments and try again. It should look something like this:

```
NAME            STATUS   ROLES    AGE   VERSION
ip-10-0-1-101   Ready    master   85s   v1.12.2
ip-10-0-1-102   Ready    <none>   63s   v1.12.2
ip-10-0-1-103   Ready    <none>   60s   v1.12.2
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
