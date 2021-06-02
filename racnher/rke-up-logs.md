[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]:
[+] Number of Hosts [1]: 3
[+] SSH Address of host (1) [none]: 192.168.5.2
[+] SSH Port of host (1) [22]:
[+] SSH Private Key Path of host (192.168.5.2) [none]:
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host (192.168.5.2) [none]:
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
[+] SSH User of host (192.168.5.2) [ubuntu]: vagrant
[+] Is host (192.168.5.2) a Control Plane host (y/n)? [y]: y
[+] Is host (192.168.5.2) a Worker host (y/n)? [n]: y
[+] Is host (192.168.5.2) an etcd host (y/n)? [n]: y
[+] Override Hostname of host (192.168.5.2) [none]: rkemaster
[+] Internal IP of host (192.168.5.2) [none]: 192.168.5.2
[+] Docker socket path on host (192.168.5.2) [/var/run/docker.sock]:

[+] SSH Address of host (2) [none]: 192.168.5.3
[+] SSH Port of host (2) [22]:
[+] SSH Private Key Path of host (192.168.5.3) [none]:
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host (192.168.5.3) [none]:
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
[+] SSH User of host (192.168.5.3) [ubuntu]: vagrant
[+] Is host (192.168.5.3) a Control Plane host (y/n)? [y]: y
[+] Is host (192.168.5.3) a Worker host (y/n)? [n]: y
[+] Is host (192.168.5.3) an etcd host (y/n)? [n]: y
[+] Override Hostname of host (192.168.5.3) [none]: rkenode01
[+] Internal IP of host (192.168.5.3) [none]: 192.168.5.3
[+] Docker socket path on host (192.168.5.3) [/var/run/docker.sock]: 

[+] SSH Address of host (3) [none]: 192.168.5.4
[+] SSH Port of host (3) [22]: 
[+] SSH Private Key Path of host (192.168.5.4) [none]: 
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host (192.168.5.4) [none]: 
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
[+] SSH User of host (192.168.5.4) [ubuntu]: vagrant
[+] Is host (192.168.5.4) a Control Plane host (y/n)? [y]: y
[+] Is host (192.168.5.4) a Worker host (y/n)? [n]: y
[+] Is host (192.168.5.4) an etcd host (y/n)? [n]: y
[+] Override Hostname of host (192.168.5.4) [none]: rkenode02
[+] Internal IP of host (192.168.5.4) [none]: 192.168.5.4
[+] Docker socket path on host (192.168.5.4) [/var/run/docker.sock]: 

[+] Network Plugin Type (flannel, calico, weave, canal, aci) [canal]: calico
[+] Authentication Strategy [x509]: 
[+] Authorization Mode (rbac, none) [rbac]: 
[+] Kubernetes Docker image [rancher/hyperkube:v1.20.6-rancher1]: 
[+] Cluster domain [cluster.local]: 
[+] Service Cluster IP Range [10.43.0.0/16]:
[+] Enable PodSecurityPolicy [n]: 
[+] Cluster Network CIDR [10.42.0.0/16]: 
[+] Cluster DNS Service IP [10.43.0.10]:
[+] Add addon manifest URLs or YAML files [no]:
