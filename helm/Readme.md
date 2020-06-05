Helm commands
```
helm init # This command is used to install helm and tiller in the environment that is, by default, described in the configuration used by kubectl

helm package

helm list

helm ls

helm search hub wordpress

helm search repo brigade

helm install happy-panda stable/mariadb

helm repo add gitlab https://charts.gitlab.io/

helm install gitlab/auto-deploy-app --version 0.6.1

helm status happy-panda

helm show values stable/mariadb

helm get values happy-panda

helm rollback happy-panda 1

helm uninstall happy-panda

helm repo list

helm list --all

helm list

helm repo add dev https://example.com/dev-charts

helm status, helm get, and helm repo.

helm install

helm dep update

helm dep list

helm repo update #This command is used to update the local cache with the current state of a repository.

helm inspect

helm history
```

## templates
This folder inside of the chart contains the manifest templates that, when combined with the contents of values.yaml and Chart.yaml, create Kuberenetes Manifests that are used to deploy resources.

## helm client
This is the user interface to helm. It is installed in the management environment and is used to execute commands prefixed by the word helm.

## Tiller Server
This is a pod that exsts in the Kubernetes cluster where Helm is installed. This server manages Helm releases and interfaces with the Kuberenetes API to get resources created.

## helm fetch 
This command downloads a helm chart archive to your local environment. Using --untar will create the local copy as an unpacked directory.

# chart repository
This is a server capable of serving yaml files over htttp that contains an index.yaml. The index.yaml provides the information about where to download charts.

# Helm Chart
This is either a packaged archive or a directory that contains all of the data required, in a specific format, for the tiller server to use the Kubernetes API to create the resources described in the chart.
