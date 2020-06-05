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

unistall a helm installation
```
helm uninstall wordpress-1591377726
```

Upgrade a release to newer version
```
helm upgrade wordpress-1591378197 bitnami/wordpress
```

fetch contents of a helm package locally
```
helm fetch bitnami/wordpress
```

un tar a package
```
helm fetch --untar bitnami/wordpress
```
# helm location linux

```
Operating System	  Cache Path	         Configuration Path	    Data Path
Linux	              $HOME/.cache/helm	   $HOME/.config/helm	    $HOME/.local/share/helm
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


# helm install wordpress

1. serach hum repo for wordpress
```
helm search hub wordpress
```

2. you will get a list of results, select the latest from list and install it
```
helm install bitnami/wordpress --generate-name
```
below will be the output
```
NAME: wordpress-1591377726
LAST DEPLOYED: Fri Jun  5 17:22:09 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the chart is being deployed **

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w wordpress-1591377726'

   export SERVICE_IP=$(kubectl get svc --namespace default wordpress-1591377726 --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
   echo "WordPress URL: http://$SERVICE_IP/"
   echo "WordPress Admin URL: http://$SERVICE_IP/admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace default wordpress-1591377726 -o jsonpath="{.data.wordpress-password}" | base64 --decode)

```

# play with helm dependcies
in this lesson we will fetch wordpres lcoally, remove the dependencies and check what happens

1. fetch contents of a helm package locally
```
helm fetch bitnami/wordpress
```

2. untar the package
```
helm fetch --untar bitnami/wordpress
```

3. check the depnedicies
```
cat requirements.yaml

ubuntu@ip-172-31-55-254:~/wordpress$ cat requirements.yaml
dependencies:
  - name: mariadb
    version: 7.x.x
    repository: https://charts.bitnami.com/bitnami
    condition: mariadb.enabled
    tags:
      - wordpress-database

```

4. delete the dependency
```
rm -fr ./charts/mariadb/

```

5. Check with dependency is required
```
ubuntu@ip-172-31-55-254:~/wordpress$ helm dep list

NAME    VERSION REPOSITORY                              STATUS
mariadb 7.x.x   https://charts.bitnami.com/bitnami      missing

```

6. install the dependency
```
helm dep update
```

7. install from untar directory
```
helm install . --generate-name
```
