# Adding eks to local kubectl/lens 

* Confirm that you are using the correct role or user:
```
aws sts get-caller-identity
```

* Generate the kubeconfig file automatically
```
aws eks --region region-code update-kubeconfig --name cluster_name

aws eks --region us-east-2 update-kubeconfig --name js-cluster-2

```

# Reference:
https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html#create-kubeconfig-automatically
