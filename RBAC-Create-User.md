
## Create user CSR
you'll need to create a Key and a signing request:

```
openssl genrsa -out user1.key 2048
openssl req -new -key user1.key -out user1.csr
```

## Approve CSR
sign the certificate request

```
openssl x509 -req -in user1.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out user1.crt -days 500
```
## Create Role or ClusterRole
```
cat role.yml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
namespace: test-namespace
name: user1-role
rules:
- apiGroups: ["", “extensions”, “apps”]
resources: [“deployments”, “pods”, “services”]
verbs: [“get”, “list”, “watch”, “create”, “update”, “patch”, “delete”]
```

## Create RoleBindings
```
cat binding.yml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
name: user1-rolebinding
namespace: test-namespace
subjects:

kind: User
name: user1
apiGroup: “”
roleRef:
kind: Role
name: user1-role
apiGroup: “”
```
## Use it
```
kubectl config set-credentials user1 --client-certificate=/root/user1.crt --client-key=user1.key

kubectl config set-context user1-context --cluster=kubernetes --namespace=test-namespace --user=user1
```


# Demo 2: Create user John
Source: https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#create-certificate-request-kubernetes-object
1) Create Private Key
2) Creat CSR
3) Approve CSR
4) Create Role
5) Create Role Binding
6) verify if new user has rights
   ```
   kubectl auth can-i update pods
	 kubectl auth can-i update pods --as=john -n development
   ```
