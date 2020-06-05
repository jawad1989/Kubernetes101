# Three Big Concepts
***A Chart*** is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.

***A Repository*** is the place where charts can be collected and shared. It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.

***A Release*** is an instance of a chart running in a Kubernetes cluster. One chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If you want two databases running in your cluster, you can install that chart twice. Each one will have its own release, which will in turn have its own release name.

With these concepts in mind, we can now explain Helm like this:

> Helm installs charts into Kubernetes, creating a new release for each installation. And to find new charts, you can search Helm chart repositories.

#### Helm commands
```
helm init # This command is used to install helm and tiller in the environment that is, by default, described in the configuration used by kubectl

helm package

helm list

helm ls



helm install happy-panda stable/mariadb

helm repo add gitlab https://charts.gitlab.io/

helm install gitlab/auto-deploy-app --version 0.6.1




helm rollback happy-panda 1

helm uninstall happy-panda

helm repo list

helm repo add dev https://example.com/dev-charts

helm status, helm get, and helm repo.

helm install

helm dep update

helm dep list

helm repo update #This command is used to update the local cache with the current state of a repository.

helm inspect

helm history
```

####  Search helm hub

```
helm search hub wordpress

helm search repo brigade

helm search hub # shows you all of the available charts
```

#### Search helm repo

Using helm search repo, you can find the names of the charts in repositories you have already added:

```
$ helm repo add brigade https://brigadecore.github.io/charts
"brigade" has been added to your repositories
$ helm search repo brigade
NAME                        	CHART VERSION	APP VERSION	DESCRIPTION
brigade/brigade             	1.3.2        	v1.2.1     	Brigade provides event-driven scripting of Kube...
brigade/brigade-github-app  	0.4.1        	v0.2.1     	The Brigade GitHub App, an advanced gateway for...
brigade/brigade-github-oauth	0.2.0        	v0.20.0    	The legacy OAuth GitHub Gateway for Brigade
brigade/brigade-k8s-gateway 	0.1.0        	           	A Helm chart for Kubernetes
brigade/brigade-project     	1.0.0        	v1.0.0     	Create a Brigade project
brigade/kashti              	0.4.0        	v0.4.0     	A Helm chart for Kubernetes
```


#### Check status of chart
To keep track of a release's state, or to re-read configuration information
```
helm status happy-panda

```
#### helm get values of release

```
helm show values stable/mariadb

helm get values happy-panda
```

#### Customizing the Chart Before Installing


```
helm show values stable/mariadb
Fetched stable/mariadb-0.3.0.tgz to /Users/mattbutcher/Code/Go/src/helm.sh/helm/mariadb-0.3.0.tgz
## Bitnami MariaDB image version
## ref: https://hub.docker.com/r/bitnami/mariadb/tags/
##
## Default: none
imageTag: 10.1.14-r3

## Specify a imagePullPolicy
## Default to 'Always' if imageTag is 'latest', else set to 'IfNotPresent'
## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
##
# imagePullPolicy:

## Specify password for root user
## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#setting-the-root-password-on-first-run
##
# mariadbRootPassword:

## Create a database user
## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-user-on-first-run
##
# mariadbUser:
# mariadbPassword:

## Create a database
## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-on-first-run
##
# mariadbDatabase:
# 
```

You can then override any of these settings in a YAML formatted file, and then pass that file during installation.
```
$ echo '{mariadbUser: user0, mariadbDatabase: user0db}' > config.yaml
$ helm install -f config.yaml stable/mariadb --generate-name
```

#### unistall a helm installation
```
helm uninstall wordpress-1591377726
```

###  list all 
```
helm list --all

helm list
```

### list local repo
```
helm repo list
```

#### Upgrade a release to newer version
```
helm upgrade wordpress-1591378197 bitnami/wordpress
```

#### fetch contents of a helm package locally
```
helm fetch bitnami/wordpress
```

#### un tar a package
```
helm fetch --untar bitnami/wordpress
```
####  helm location linux

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

# installing mysql
```
$ helm repo update              # Make sure we get the latest list of charts
$ helm install stable/mysql --generate-name
Released smiling-penguin

helm show all stable/mysql
```

# status of a release
```
helm status smiling-penguin
Status: UNINSTALLED
```
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
