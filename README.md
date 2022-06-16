# K3OS Cluster Lab
Create K3OS cluster in virtualbox using packer and vagrant.

## Usage
* packer build *template.pkr.hcl -> create .box files with respect to *config.yml
* vagrant up -> use .box files with pre-configured settings
* vagrant ssh <master-name>
* vagrant halt or vagrant destroy

## Notes
1. one server node and zero agent for now.
2. server node has `layer=fog` label inside kubernetes. agents will have `layer=edge` label.
3. using v0.21.5-k3s2r1 version of k3os.
4. all needed images for k3s exported to `master-images.tar` and will be imported in post-process phase of packer build but is not present in this git.
5. `rtc_time_base = UTC` setting in packer config solved kubernetes certificate problem after booted with vagrant.
6. make sure use `https://<server-ip>:6443` in agent-config.yml for agents.
7. using 1024MB memory for server node in VBox in vagrantfile.
8. using Bridge network for nodes in vagrantfile.

### TODO:
* add custom scheduler to `master-images.tar`.