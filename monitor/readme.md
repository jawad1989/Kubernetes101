# Prometheus
* Prometheus is free and  open-source event monitoring tool for containers or microservices. Prometheus collects numerical data based on time series
* The Prometheus server works on the principle of scraping.
* Prometheus data retention time is 15 days by default.

### List of metrics
prometheus-operator
prometheus
alertmanager
node-exporter
kube-state-metrics
grafana
service monitors to scrape internal kubernetes components
kube-apiserver
kube-scheduler
kube-controller-manager
etcd
kube-dns/coredns
Kube-proxy
Tools included like Kube-state-metrics scrape internal system metrics and we can get a list of that by port forwarding the Kube state metrics pod.
```
kubectl port-forward -n prometheus prometheus-kube-state-metrics-6967c9fd67-zsw6c 8080
```

* Now visit localhost:8080/metrics
### Metrics To Watch
* Watch for nodes


# Grafana:
* Grafana is a multi-platform visualization software that provides us a graph, the chart for a web connected to the data source.
* Visulize
* Explore Logs
* Explore Metrics
* kubectl port-forward --namespace ${NAMESPACE} ${APP_INSTANCE_NAME}-grafana-0 3000
