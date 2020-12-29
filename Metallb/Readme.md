in baremetal kubernetes installation there are three ways to expose service outisde a VM/cluster.
1. Node Port
2. Ingress Controller (DNS host mapping)
3. Metallb 

# Why do we need it?

MetalLB hooks into your Kubernetes cluster, and provides a network load-balancer implementation. In short, it allows you to create Kubernetes services of type “LoadBalancer” in clusters that don’t run on a cloud provider, and thus cannot simply hook into paid products to provide load-balancers.

It has two features that work together to provide this service: address allocation, and external announcement.

### Address allocation
In a cloud-enabled Kubernetes cluster, you request a load-balancer, and your cloud platform assigns an IP address to you. In a bare metal cluster, MetalLB is responsible for that allocation.

### External Announcement
Once MetalLB has assigned an external IP address to a service, it needs to make the network beyond the cluster aware that the IP “lives” in the cluster. MetalLB uses standard routing protocols to achieve this: ARP, NDP, or BGP.

# Install

```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```
 
# get your ip range

type `ip a` and look for inet, this will show you your allocated IP range in NAT:

```
 eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:37:66:3c brd ff:ff:ff:ff:ff:ff
    inet 172.16.16.100/24 brd 172.16.16.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe37:663c/64 scope link 
```
# create configMap

```
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.1.240-192.168.1.250
```

# Demo
```
kind: Deployment
metadata:
  name: nginx
spec:
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
        image: nginx:1
        ports:
        - name: http
          containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalance
```

you can see the service will be assigned an external IP address:

```
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
service/nginx   LoadBalancer   10.107.20.16   172.16.16.110   80:30775/TCP   17m
```

