* Install and congigure aws CLI 
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install



curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
./aws/install -i /usr/local/aws-cli -b /usr/local/bin
aws --version
```
* INSTALL EKSCTL

https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```
* Install kubectl
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
```
* create managed cluster
```
eksctl create cluster \
--name js-cluster \
--region us-east-2 \
--with-oidc \
--ssh-access \
--ssh-public-key awseks \
--node-type t2.micro \
--nodes-max 9 \
--nodes-min 3 \
--managed
```
* create self managed cluster
```
eksctl create cluster \
--name js-cluster-2 \
--region us-east-2 \
--nodegroup-name linux-nodes \
--nodes 2 \
--ssh-access \
--ssh-public-key awseks \
--node-type t2.micro
```
* add new node to self managed cluster
```
eksctl create nodegroup \
  --cluster js-cluster-2 \
  --name sm-cloudbees \
  --node-type t2.micro  \
  --nodes 1 \
  --ssh-access \
  --ssh-public-key awseks
```
