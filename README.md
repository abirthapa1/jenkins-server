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
