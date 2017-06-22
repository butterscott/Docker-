# ADSA Workshops Machine

## Installation

These installation methods require [Vagrant](https://www.vagrantup.com/downloads.html).

Clone the repository:

    git clone git@github.com:valisj/adsa-workshops-machine.git workshops-machine

### Locally

Run the following command to set up a virtual machine locally:

    cd workshops-machine
    vagrant up --provision

This step will create a new Ubuntu VM and do necessary provisioning. This will take a while.

To SSH into the VM, run:

    vagrant ssh

### AWS

Set AWS access key ID and secret access key as environment variables:

    export AWS_ACCESS_KEY_ID="access_key_id"
    export AWS_SECRET_ACCESS_KEY="secret_access_key"

Run the following command to launch a new EC2 instance:

    cd workshops-machine
    vagrant up --provider=aws

To provision the instance, run:

    vagrant provision

To SSH into the VM, run:

    vagrant ssh

#### Troubleshooting

 The process of launching a new instance with `vagrant up --provider=aws` may freeze when using
 the default security group. To work around this: 1) log into the AWS console, 2) find the instance,
 3) in the information panel down below, find the `default` security group, 3) follow the link leading
 to security group settings, 4) select tab "inbound", 5) change the source to `0.0.0.0/0` (Anywhere)
 for the first (and probably only) row. Finally, run `vagrant provision`.

## Running JupyterHub

To start JupyterHub run, the following command in the `/home/{MAIN_USER}/jupyterhub-docker` directory:

    docker-compose up -d

If you're running a local VM, the web server will be available at https://localhost:8080.

## Additional documentation

* [JupyterHub](https://github.com/jupyterhub/jupyterhub-deploy-docker)
