# Kubernetes Dynamic Volume
https://www.devopsschool.com/blog/kubernetes-volume-dynamic-provisioning-example-1/

# Kubernets PVC Error:
unexpected error getting claim reference: selfLink was empty, can't make reference
https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/issues/25#issuecomment-742616668

# connection refused
vagrant@kmaster:~$ kubectl cluster-info

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
The connection to the server localhost:8080 was refused - did you specify the right host or port?
vagrant@kmaster:~$ sudo cp /etc/kubernetes/admin.conf $HOME/
vagrant@kmaster:~$ sudo chown $(id -u):$(id -g) $HOME/admin.conf
vagrant@kmaster:~$ export KUBECONFIG=$HOME/admin.conf
