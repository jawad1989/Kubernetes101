#!/bin/bash

echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.56.2 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# echo "[TASK 2] kubectl env variable"
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[TASK 2] Deploy Calico network"
kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 3] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

kubeadm join 192.168.56.2:6443 --token 5ept0w.osbmcznlxwvmrrub --discovery-token-ca-cert-hash sha256:c3621395ce954e5d338400193b48b2bdb7bfb7ecec1c0cb8662b0dc2c2a2c7db