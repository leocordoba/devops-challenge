#Installation

1. Apply service and deployment on Kubernetes:
	$> kubectl apply -f challenge.yaml
	
2. Generate self-signed certificates:
	$> openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout tls.key -out tls.crt -days 365

3. Create secret on Kubernetes:
	$> kubectl create secret tls challenge-tls --cert=tls.crt --key=tls.key
	
4. Apply ingress on Kubernetes:
	$> kubectl apply -f ingress.yaml
	
5. At this point you have a kubernetes cluster with an Nginx server running a flask app exposed port 80.

6. Generate public/private keys:
	$>ssh-keygen -o
	
7. Edit the terraform file provided with your own public key.

8. Run the TF file to provision an EC2 instance. The public IP address of the VM will be deplayed at the end of the provisioning process:
	$> terraform apply

9. Connect to the remote server with the public IP address.

10. Place the file getNumber.sh in the directory "/root".

11. Create a new crontab with:
	*/1 * * * * /root/getNumber.sh

