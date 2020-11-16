# The Challenge
Create a web service with python deployed in a Kubernetes cluster, which responses random numbers (0-100) every minute to requests from an EC2 instance.

# Files description

```bash
.
├── app                            # Web app directory
│   ├── deploy.sh                  # Instructions to run the Flask app on top of Gunicorn port 5000
│   ├── requirements.txt           # Python requirements
│   └── src                        # Flask directory
│       └── app.py                 # Flask app
├── default                        # File to copy in Nginx during docker containerization process
├── Dockerfile                     # Docker file
├── manifest                       # Kubernetes files
│   ├── challenge.yaml             # Deploys deployment and service objects
│   ├── ingress.yaml               # Stab
├── README.md                      # README file
└── terra                          # Terraform directory
    ├── challenge.tf               # Deploys infrastructure on AWS
    └── getNumber.sh               # Script to request a random number
```

# Requirements

For this demo the packages used were:
- Docker 19.03.13.
- Kubectl v1.19.4
- VirtualBox 5.2.42_Ubuntu r137960.
- Minikube v1.15.0
	- Ingress addon.
- Python 3.6.9
	- Flask 1.1.2
	- gunicorn 20.0.4
- Terraform v0.13.5

Optionally, it was registered an FQDN on DuckDNS and implemented port forwarding and firewall rules in the VMs with UFW.

# Installation

1. Apply **challenge.yaml** to deploy service and deployment objects on Kubernetes cluster:
	> $> kubectl apply -f challenge.yaml
	
2. Generate self-signed certificates:
	> $> openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout tls.key -out tls.crt -days 365

3. Create secret in Kubernetes with the certificates just created:
	> $> kubectl create secret tls challenge-tls --cert=tls.crt --key=tls.key
	
4. Apply **ingress.yaml** on Kubernetes:
	> $> kubectl apply -f ingress.yaml
	
5. At this point you have a Kubernetes cluster with an Nginx server running a Flask app on top of Gunicorn exposed on port 80 and 443.

6. Generate public/private keys on the local machine:
	> $>ssh-keygen -o
	
7. Replace your own public key string in the terraform file **challenge.tf**.

8. Apply **challenge.tf** file to provision an EC2 instance. The public IP address of the VM will be displayed at the end of the provisioning process:
	> $> terraform apply

9. Connect to the remote server using the public IP address provided.

10. Place the file **getNumber.sh** in the directory "/root" from the EC2 instance.

11. Create a new crontab with the next instruction
	> 1 * * * * /root/getNumber.sh
	
12. The random numbers will be displayed in "/root/randomNumber.txt"

# PROS/CONS

- ## Pros

	- Easy to deploy.
	- The web service is deployed in Nginx which is a well-known solid and reliable web server used for production environments.
	- The solution uses a registered domain.
	- The EC2 instance achieves the security requirements and connects through a public key.
	- The EC2 instance has a static IP address.

- ## Cons

	- The Kubernetes cluster is a single node since it's deployed on Minikube and hence affects high availability.
	- The Kubernetes deployment only has one replica.
	- Since it's a nested environment, the firewall rules could be difficult to implement until getting the Kubernetes cluster.
	- The web service uses a self-signed certificate, not a production one.

# What would I do with more resources for this specific solution?

- Generate a production certificate, so the endpoint will be trustable.
- Deploy the solution on a web-based Kubernetes cluster.
- Improve high availability in the cluster with different zones and load balancers.

