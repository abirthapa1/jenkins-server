# 🚀 Jenkins CI/CD Infrastructure with Terraform & Ansible

### 📌 Project Overview

This project demonstrates how to provision and configure a Jenkins CI/CD environment using Infrastructure as Code (Terraform) and Configuration Management (Ansible).

The setup includes:

- A Jenkins Master
- A Java-based Jenkins Agent
- A Python-based Jenkins Agent

Terraform modules are used to provision the infrastructure, and Ansible playbooks are used to configure Jenkins and required tools on each node.

This project is designed as a small but realistic CI/CD pipeline setup suitable for learning and to be configured more according to your needs!

### 🧰 Tech Stack

#### Infrastructure

- AWS EC2
- Terraform (Modules)
- SSH key-based access

#### Configuration Management

- Ansible
- Playbooks with become_user for Jenkins execution

#### CI/CD

- Jenkins
- Jenkins Agents (Java & Python)
- Declarative Jenkins Pipelines


### Steps

#### Infrastructure provisioning

1. First git clone the reposistory
2. Change directory to jenkins-server. ```cd jenkins-server```
3. Run the following commands:
```
terraform init
terraform plan
terraform apply
```
4. Once terraform finishes provisioning the infrastructure, you can see the 3 public ip addresses of the 3 instances created as terraform output.
The three instances created after terraform apply
<img width="1599" height="558" alt="image" src="https://github.com/user-attachments/assets/c0da7707-f56c-4e4f-9712-e9edb89e2051" />

#### Bootstrapping the instances
1. Using ansible we bootstrap the instances with jenkins.
2. We install jenkins in the master-node and install the other dependencies for the other nodes like python-node, we install python3-11 and for java-node we install java-21 with gradle and maven as well.
3. Once bootstrapping is done we can access the jenkins page through ```http://<public-ip-addr-master-node>:8080```
   Getting the jenkins login page for the first time.
<img width="1455" height="665" alt="image" src="https://github.com/user-attachments/assets/cbd8620d-7e5a-4dcd-8a29-e346c3c5fb15" />

4. The admin password will be outputed when the ansible playbook for jenkins run or you can ssh into the jenkins master-node and print the intial admin password using ```cat /var/lib/jenkins/secrets/initialAdminPassword```
   Once you login using admin password and create an user for yourself the homepage would look like this
<img width="1864" height="697" alt="image" src="https://github.com/user-attachments/assets/f3b8013a-d0fe-4c6c-abf2-5478a72b5d9d" />

Connected my java-node
<img width="1828" height="837" alt="image" src="https://github.com/user-attachments/assets/f58c92a7-b55c-42b4-b824-3db1773c66e2" />



