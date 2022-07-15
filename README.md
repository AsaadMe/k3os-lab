# K3OS Cluster Lab
Create K3OS cluster in virtualbox using packer and vagrant.

## Usage
* packer build *template.pkr.hcl -> create .box files with respect to *config.yml
* vagrant box remove ./agent_k3os...box and also master.
* vagrant up -> use .box files with pre-configured settings
* vagrant ssh
* vagrant halt or vagrant destroy

## Notes
### General Notes:
- one server node and multi agents.
- server node has `layer=fog` label inside kubernetes. agents will have `layer=edge` label.
- using v0.21.5-k3s2r1 version of k3os.
- all needed images for k3s exported to `master-images.tar` and will be imported in post-process phase of packer build but is not present in this git.
- `rtc_time_base = UTC` setting in packer config solved kubernetes certificate problem after booted with vagrant.
- server has static ip = 192.168.1.200 (set in master-config.yml).
- make sure use `https://<server-ip>:6443` in agent-config.yml for agents.
- using 1024MB memory for server node in VBox in vagrantfile.
- using Bridge network for nodes in vagrantfile but also using NAT as eth0 for agents so vagrant could ssh into.
- changed grub timeout to 0 (in *config.yml) for faster vagrant bootup.
- k3s services logs: /var/log/k3s.log

### Access k8s API Inside cluster for test:
1. apply RBAC file to have permissions.
2. > kubectl run -it --rm debug --image=ranhema/newscheduler:v1 -n kube-system --overrides='{ "spec": { "serviceAccount": "newscheduler-account" }  }' -- bash
3. in python:
    > from kubernetes import client, config; config.load_incluster_config(); v1 = client.CoreV1Api()
 
## TODO
- [x] add custom scheduler to `master-images.tar`.