
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
