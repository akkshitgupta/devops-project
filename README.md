# Devops Project

*Building a real application that scales from local development to global production*

## Quick Start
> Ensure all the [pre-requisites](#prerequisites) satisfied
```bash
$ chmod +x ./setup-script.sh
$ ./setup-script.sh
```
**Expected Output**

prompt password to configure local DNS

`echo "127.0.0.1 k8sapp.local" | sudo tee -a /etc/hosts`
```json
{
  "status": "healthy",
  "timestamp": "2025-08-30T00:33:26.867Z",
  "services": {
    "database": "connected",
    "redis": "connected",
    "api": "running"
  },
  "version": "1.0.0",
  "environment": "development"
}
```

Open [http://k8sapp.local:9080] to verify


## 🎯 This includes

- **Deploying applications** on Kubernetes (the industry standard)
- **Monitoring performance** with production-grade tools
- **Automating deployments** using GitOps principles

This project considers enterprise-grade DevOps practices by building a real application that scales from local development to global production. The same patterns used by companies like Netflix, Airbnb, and GitHub.


## What is built

*Real-time user interaction flow from browser to database with error handling*

A complete production application stack featuring:
- **Multi-service application** running on Kubernetes
- **Production networking** with Ingress
- **Comprehensive monitoring** with Prometheus and Grafana dashboards
- **Database persistence** with PostgreSQL and Redis
- **Professional DevOps workflows** using GitOps and automation

## Technology Stack

**Application Layer:**
- **Frontend**: Vanilla JS with nginx (port 80)
- **Backend**: Node.js Express API (port 3001)
- **Database**: PostgreSQL 15 (port 5432)
- **Cache**: Redis 7 (port 6379)

**Infrastructure Layer:**
- **Containerization**: Docker & Docker Compose
- **Orchestration**: Kubernetes (k3d)
- **Ingress**: dp-k8s-nginx controller
- **Monitoring**: Prometheus (port 9090) + Grafana (port 3000)
- **GitOps**: ArgoCD

**Development Tools:**
- **Cluster**: k3d (lightweight Kubernetes)
- **CLI**: kubectl, docker, docker-compose
- **Scripting**: Node.js

## Prerequisites

**System Requirements:**
- 4GB+ RAM available
- 10GB+ disk space
- macOS or Linux (Windows via WSL2)

**Required Tools:**
- Docker 20.0+ / Colima (macOS)
- kubectl 1.28+
- k3d 5.6+
- Node.js 18+


## What Makes This Different

- **Production Patterns**: Same infrastructure used by major tech companies
- **Hands-on Learning**: Every concept is practiced, not just copy-pasted
- **Progressive Complexity**: Each learning is based on the previous one, managed using vcs-branching
- **Troubleshooting Skills**: Debugged real infrastructure issues

---
&copy; [source used to learn](https://github.com/Osomudeya/DevOps-Home-Lab-2025.git)

