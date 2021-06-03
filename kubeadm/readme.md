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

To create the docker group and add your user:

Create the docker group.

```
sudo groupadd docker
```

Add your user to the docker group.

```
sudo usermod -aG docker $USER
```

# Install cgroup
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
```
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Log out and log back in so that your group membership is re-evaluated.

If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

On a desktop Linux environment such as X Windows, log out of your session completely and then log back in.

On Linux, you can also run the following command to activate the changes to groups:

 ```
 newgrp docker 
 ```
Verify that you can run docker commands without sudo.

```
docker run hello-world
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
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.56.2

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

# install rancher local storage - Dynamic
https://github.com/rancher/local-path-provisioner
```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pvc/pvc.yaml
kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pod/pod.yaml

```

# untaint master if you want
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

# install helm
```
wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz
tar -zxvf helm-v3.6.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

helm --version
```


# install promethrous

### install helm chart:

```

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 16.1.2 --namespace=prometheus

helm search prometheus
helm search grafana
helm inspect values stable/prometheus > /tmp/prometheus.values
helm inspect values prometheus-community/kube-prometheus-stack --version 16.1.2 > /tmp/prometheus.values
```

### update svc(s) from clusterip to nodePort to svc:

```

kubectl edit svc --namespace prometheus prometheus-kube-prometheus-prometheus
 ports:
    nodePort: 32322
type: NodePort

kubectl edit svc --namespace prometheus prometheus-grafana
 - name: service
    nodePort: 32323
    port: 80
    protocol: TCP
    targetPort: 3000
```

Note: When installing via the Prometheus Helm chart, the default Grafana admin password is actually prom-operator


# setup grafana dashboard

1. sign in grafana <http://192.168.56.2:32323/>
2. create data source. 
3. In http: set url: <prometheus url:http://192.168.56.2:32322/> set access:<browser>
4. save and test
5. get dahsboards from grafana:https://grafana.com/grafana/dashboards?dataSource=prometheus
6. copy dashboard id: 11074
7. in grafana select import dashbaord, give data source<prometheus>