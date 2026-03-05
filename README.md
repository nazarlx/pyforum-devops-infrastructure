# PyForum DevOps Infrastructure

Production-like DevOps infrastructure for the **PyForum Django application** using AWS, Terraform, Docker, GitHub Actions and a full monitoring stack.

This project demonstrates how to deploy a containerized web application using Infrastructure as Code and automated CI/CD pipelines.

---

# Architecture Overview

The application is containerized with Docker and deployed on AWS using ECS.  
Infrastructure is managed using Terraform and application delivery is automated via GitHub Actions.

Architecture flow:

GitHub → CI/CD → Amazon ECR → ECS Cluster → Nginx → Django App → PostgreSQL (RDS)

Monitoring stack includes Prometheus, Grafana, Loki and Node Exporter.

---

# Tech Stack

### Infrastructure
- AWS ECS
- AWS ECR
- AWS RDS
- AWS VPC
- Terraform (Infrastructure as Code)

### Application
- Python
- Django
- Gunicorn
- Nginx

### Containers
- Docker
- Docker Compose

### CI/CD
- GitHub Actions

### Monitoring & Logging
- Prometheus
- Grafana
- Loki
- Promtail
- Node Exporter
- cAdvisor

---

# Project Structure
.
├── admin
├── administration
├── authentication
├── css
├── forum_sandbox
├── front_end
├── infra/aws
├── logs
├── media
├── monitoring
├── nginx
├── profiles
├── rest_framework
├── static
├── templates
├── terraform
├── docker-compose.dev.yml
├── Dockerfile
├── manage.py
├── requirements.txt


---

# Infrastructure

Infrastructure is provisioned using **Terraform**.

Resources created:

- VPC
- Subnets
- Security Groups
- ECS Cluster
- ECS Task Definition
- Load Balancer
- RDS PostgreSQL
- Monitoring services

Deploy infrastructure:

```bash
terraform init
terraform plan
terraform apply


CI/CD Pipeline

CI/CD is implemented using GitHub Actions.

Pipeline stages:

1️⃣ Build Docker image
2️⃣ Run tests (optional)
3️⃣ Push image to Amazon ECR
4️⃣ Deploy to ECS

Pipeline files:
.github/workflows/ci.yml
.github/workflows/cd.yml


Running Locally

Run the application locally using Docker Compose.
docker-compose -f docker-compose.dev.yml up --build

Application will be available at:
http://localhost:8000




Monitoring Stack

The project includes a complete monitoring stack.

Components:
	•	Prometheus – metrics collection
	•	Grafana – dashboards and visualization
	•	Loki – log aggregation
	•	Promtail – log shipping
	•	Node Exporter – host metrics
	•	cAdvisor – container metrics

⸻

Logging

Centralized logging is implemented using:
	•	Loki
	•	Promtail

Logs are collected from:
	•	Docker containers
	•	Application logs
	•	System logs

⸻

Environment Variables

Create .env file based on example:
cp .env.example .env



Example variables:
DATABASE_URL=
SECRET_KEY=
DEBUG=
ALLOWED_HOSTS=




Security

Best practices used:
	•	Environment variables for secrets
	•	Security groups for network isolation
	•	Private subnets for internal services
	•	Reverse proxy via Nginx

⸻

DevOps Features

✔ Infrastructure as Code
✔ Containerized application
✔ CI/CD automation
✔ Cloud deployment
✔ Monitoring and logging
✔ Production-ready architecture

⸻

Future Improvements

Possible improvements:
	•	Kubernetes deployment
	•	Auto-scaling ECS services
	•	Blue/Green deployments
	•	Terraform remote state (S3 + DynamoDB)
	•	Secret management with AWS Secrets Manager

⸻

Author

Nazar Lysyk

GitHub:
https://github.com/nazarlx

LinkedIn:
www.linkedin.com/in/nazar-lysyk






