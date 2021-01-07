# Installtion

* update /etc/hosts  in all vms

## 1. Install Docker
  * remove older version
  ```
  sudo apt-get remove docker docker-engine docker.io containerd runc
  ```
  * install
  ```
 curl https://releases.rancher.com/install-docker/19.03.sh | sh
    
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
## 4. Create SSH keys
as a non root user

on all Vms, create ssh keys and on master copy the public key(id_rsa.pub) of other machine in authorized_keys
```
ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -N ""
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
https://github.com/rancher/rke/releases/tag/v1.2.1

AS ROOT
```
curl -fsSL https://github.com/rancher/rke/releases/download/v1.0.14/rke_linux-amd64 -o rke-amd64
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
