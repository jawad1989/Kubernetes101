# important

* update /etc/hosts  in all vms
* on master make sure to copy id_rsa.pub into authorized_keys
* update cluster_name in cluster.yml
* install kubectl, rke on master node


## 1. Install Docker
  * remove older version
  ```
  sudo apt-get remove docker docker-engine docker.io containerd runc
  ```
  * install
  ```
 curl https://releases.rancher.com/install-docker/19.03.sh | sh
    
  ```
  * add current user to docker group
  ```
  sudo groupadd docker
  sudo usermod -aG docker $USER
  ```
  * Check version
  ```
  docker version --format '{{.Server.Version}}'
  ```
## 2. install helm
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
## 3. Install Kubectl
```
https://kubernetes.io/docs/tasks/tools/install-kubectl/
```
## Letting iptables see bridged traffic
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
```
## 4. Create SSH keys
as a non root user

on all Vms, create ssh keys and on master copy the public key(id_rsa.pub) of other machine in authorized_keys
```
ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -N ""
```

update /etc/hosts
```
192.168.5.2 rkemaster rkemaster.local
192.168.5.4 rkenode02
192.168.5.3 rkenode01
```
test:
```
ssh vagrant@rkenode01
```

## 5. Swap Off
as root
```
sudo swapoff -a
```
## 6. Install Rke
Release Page: https://github.com/rancher/rke/releases/

Latest: https://github.com/rancher/rke/releases/tag/v1.2.8

AS ROOT
```
curl -fsSL https://github.com/rancher/rke/releases/download/v1.2.8/rke_linux-amd64 -o rke
mv rke-amd64 rke

cp rke /usr/local/bin

chmod 777 rke

mkdir /opt/rke
chmod 777 -fR /opt/rke

```

* As Non Root
```
rke -version

kubectl version

chmod 777 /usr/local/bin/kubectl
```

## 7. install cluster
in /opt/rke
```
rke config
```

* in cluster.yml give clustername
```
rke up
```

set kubeconfig
```
export KUBECONFIG=./kube_config_cluster.yml
```

test
```
kubectl get nodes
```
## 8. install rancher

## adding/removing nodes
```
rke up --update-only
```
## upgrade
```
rke up --config cluster.yml
```
