# Kubernetes Concepts

***************************
## Table Of Contents: 
  - [Introduction](#introdution)
  - [Kubernetes Objects](#kubernetes-objects)
  - [Kubernetes Architecture](#kubernetes-architecture)
  - [Tutorial Resources](#tutorial-resources)
  - [References](#reference)


*****************

## Introdution
 - What is Kubernetes?
 
 Kubernetes (K8s) is an open-source system for automating deployment, scaling, and management of containerized applications
 It groups containers that make up an application into logical units for easy management and discovery


# Building a Kubernetes Cluster with Kubeadm

Install Docker on all three nodes.
Install Kubeadm, Kubelet, and Kubectl on all three nodes.
Bootstrap the cluster on the Kube master node.
Join the two Kube worker nodes to the cluster.
Set up cluster networking with flannel.

**************
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
