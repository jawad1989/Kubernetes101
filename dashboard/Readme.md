Logs
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
   32  ifconfig
   33  kubectl proxy
   34  kubectl version --short
   35  kubectl get pods
   36  kubectl get pods -A
   37  kubectl get svc
   38  kubectl get svc -A
   39  kubectl cluster-info
   40  kubectl proxy
   41  kubectl  edit service kubernetes-dashboard -n kubernetes-dashboard
   42  kubectl get svc -A
   43  kubectl get secrets
   44  kubectl get secrets -A
   45  kubectl get secrets
   46  kubectl get secrets -A
   47  kubectl describe secret default-token-n9fn9
   48  kubectl describe secret default-token-n9fn9 -n kubernetes-dashboard
   49  pwd
   50  ls
   51  mkdir dashboard-user
   52  cd dashboard-user/
   53  vi adminuser.yaml
   54  kubectl apply -f dashboard-adminuser.yml
   55  kubectl apply -f adminuser.yml
   56  kubectl apply -f adminuser.yaml
   57  vi admin-role-binding.yaml
   58  kubectl apply -f admin-role-binding.yml
   59  kubectl apply -f admin-role-binding.yaml
   60  kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep jawad | awk '{print $1}')

```
