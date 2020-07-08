# seetup vagrant

# change dashboard to node port to access from outside
Yes it is possible by using NodePort instead of ClusterIP

[root@test ~]#   kubectl  edit service kubernetes-dashboard -n kubernetes-dashboard

[root@test ~]# kubectl get services -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.108.130.235   <none>        8000/TCP        18h
kubernetes-dashboard        NodePort    10.110.166.162   <none>        443:31824/TCP   18h


# Create a dashboard
https://medium.com/@kanrangsan/creating-admin-user-to-access-kubernetes-dashboard-723d6c9764e4
