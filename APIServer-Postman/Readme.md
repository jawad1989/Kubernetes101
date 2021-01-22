1. Create SA
```
kubectl create serviceaccount postman
```

2. Create ClusterRole
```
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
name: postman-role
rules:
- apiGroups: ["apps", ""] # "" indicates the core API group
  resources: ["pods", "services", "deployments"]
  verbs: ["get", "watch", "list", "create", "update", "delete"]
```

## 3. Crete RoleBinding
```
kubectl create rolebinding postman:postman-role --clusterrole postman-role --serviceaccount default:postman
```
For every service account created, there is a secret token. Finally, we must extract the following from the token created for the service account:

API server URL
Bearer Token
CA Certificate

## 4. Get Secret Name
```
kubectl describe serviceaccount postman
```

## 5. Describe the secret

```
kubectl get secret <secret-token> -o json
```

## 6. Get Ca.crt and token
Execute the command below to reveal the ca.crt certificate and the token, that is inside a data object. We need to decode these to base64 and use them. This can be simplified using jq command-line utility

```
TOKEN=$(kubectl get secret <secret-token> -o json | jq -Mr '.data.token' | base64 -d)

kubectl get secret <secret-token> -o json | jq -Mr '.data["ca.crt"]' | base64 -d > ca.crt
```

## 7. Add Cert in Postman
file->seettings->Certificates
![alt text](http://url/to/img.png)
![alt text](http://url/to/img.png)
