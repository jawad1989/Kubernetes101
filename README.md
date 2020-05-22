
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
     
    ## Service
      A Kubernetes Service is an abstraction which defines a logical set of Pods and a policy by which to access them - sometimes called a micro-service. If you create a pod, you don’t know where it is. Also, a pod might be killed by someone or some shortage of a node. Service provide an endpoint of the pods for you. If you specify “type=LoadBalancer” it actually create an Azure Load Balancer to expose pod with Public IP address.
      
    ## Storage Class
      A StorageClass provides a way for administrators to describe the “classes” of storage they offer. It represent a Persistent Volume like Azure Disk or Azure File or some other storage.

    ## Persistent Volume Claim
     Presistent Volume Claim is the abstruction of the Persistent Volume. Persistent Volume is physical resources of inflastructure. Kubernetes want to hide the detail from developers. Using Persistent Volume Claim, you can hide the physical declaration defined by Persistent Volume or Storage Class. Pod can mount the Volume using Persistent Volume Claim object.


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
sudo kubeadm init --pod-network-cidr=10.244.0.0/1
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
