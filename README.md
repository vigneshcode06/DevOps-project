# <p align="center"><img src="assets/img/logo.png" alt="Traveloop Logo" width="140"><br>Traveloop</p>

<p align="center">
  <strong>The Ultimate Hackathon Management & Travel SaaS Platform.</strong><br>
  <em>A premium, full-stack solution for modern trip planning and financial tracking.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PHP-8.2-blue.svg?style=for-the-badge&logo=php" alt="PHP Version">
  <img src="https://img.shields.io/badge/MySQL-8.0-orange.svg?style=for-the-badge&logo=mysql" alt="MySQL Version">
  <img src="https://img.shields.io/badge/Docker-Ready-2496ED.svg?style=for-the-badge&logo=docker" alt="Docker">
  <img src="https://img.shields.io/badge/Kubernetes-326CE5.svg?style=for-the-badge&logo=kubernetes" alt="Kubernetes">
  <img src="https://img.shields.io/badge/Terraform-7B42BC.svg?style=for-the-badge&logo=terraform" alt="Terraform">
  <img src="https://img.shields.io/badge/AWS-FF9900.svg?style=for-the-badge&logo=amazonwebservices" alt="AWS">
  <img src="https://img.shields.io/badge/GitHub%20Actions-2088FF.svg?style=for-the-badge&logo=githubactions" alt="GitHub Actions">
</p>

---

## Table of Contents

- [Vision](#vision)
- [Features](#features--functionality)
- [Architecture](#architecture--tech-stack)
- [Local Development](#local-development)
- [CI/CD Pipeline](#cicd-pipeline)
- [Kubernetes Deployment](#kubernetes-deployment)
- [AWS Infrastructure (Terraform)](#aws-infrastructure-terraform)
- [Database Schema](#database-schema)
- [Security](#security--compliance)
- [API Reference](#api-reference)

---

## Vision

**Traveloop** is a full-stack travel management SaaS platform engineered for the 2026 Hackathon. It combines a high-performance PHP backend with a glassmorphism-styled frontend to deliver seamless trip planning, real-time budget analytics, and collaborative itinerary management — all containerized and deployable to Kubernetes at scale.

---

## Features & Functionality

### Intelligent Itinerary Planning
- **Dynamic Timelines**: Build day-by-day itineraries with precise activity sequencing.
- **Activity Categorization**: Organize plans into Transport, Stay, Activities, and Meals.
- **Status Tracking**: Monitor activity progress (Planned, Completed, Cancelled).
- **City Integration**: Seamlessly add stops with automated city discovery and cost-of-living data.

### Advanced Financial Analytics
- **Live Budget Tracking**: Real-time comparison between estimated and actual expenses.
- **Category Breakdown**: Automated expense analysis across travel categories.
- **Daily Spend Metrics**: Average daily cost and trip duration calculation.
- **Smart Insights**: Automatically identifies the most expensive stops in your journey.

### Utility & Productivity Tools
- **Dynamic Packing Checklists**: Category-aware checklists (Clothing, Electronics, Documents) with persistent state.
- **Persistent Trip Notes**: Rich text-ready notes for important trip details and memories.
- **City Discovery Engine**: Searchable database of world cities with integrated cost-of-living indices ($, $$, $$$).

### Premium User Experience
- **Profile Customization**: Full control over user data, name, and email management.
- **Avatar System**: Secure image upload system for custom profile avatars (Max 2MB).
- **Secure Auth**: Registration/login with BCrypt password hashing.
- **Responsive Design**: Fluid layouts optimized for desktop, tablet, and mobile.

---

## Architecture & Tech Stack

### Frontend
| Layer | Technology |
|---|---|
| **HTML/CSS** | Semantic HTML5, Glassmorphism Design System |
| **JavaScript** | Vanilla ES6+ with async/await fetch API |
| **Styling** | CSS3 Custom Properties (variables), Flexbox, Grid |

### Backend
| Layer | Technology |
|---|---|
| **Language** | PHP 8.2 |
| **Web Server** | Apache 2 with mod_rewrite |
| **Architecture** | Custom MVC-Inspired Monolith |
| **API** | RESTful JSON API |
| **Security** | CSRF tokens, BCrypt hashing, input validation |

### Database
| Layer | Technology |
|---|---|
| **Engine** | MySQL 8.0 |
| **Tables** | 8 (users, trips, trip_stops, activities, budgets, packing_items, trip_notes, cities) |

### Infrastructure
| Layer | Technology |
|---|---|
| **Containerization** | Docker & Docker Compose |
| **Orchestration** | Kubernetes (EKS) |
| **CI/CD** | GitHub Actions |
| **IaC** | Terraform |
| **Cloud** | AWS (EKS, RDS, ECR, VPC, NAT Gateway) |

---

## Local Development

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/traveloop.git
cd traveloop

# Launch services
docker-compose up -d --build
```

Navigate to [http://localhost:8080](http://localhost:8080).

### Environment Configuration

| Variable | Default | Description |
|---|---|---|
| `DB_HOST` | `db` | MySQL hostname (container name) |
| `DB_NAME` | `traveloop` | Database name |
| `DB_USER` | `traveloop` | Database user |
| `DB_PASS` | `secret` | Database password |

### Project Structure

```
.
├── .github/workflows/   # GitHub Actions CI/CD pipeline
├── api/routes/          # RESTful API endpoints (auth, trips, itinerary, budget, etc.)
├── assets/              # CSS, JavaScript, images
├── config/              # Database config & schema (setup.sql)
├── includes/            # Shared components, CSRF security middleware
├── k8s/                 # Kubernetes manifests (deployment, service, ingress, configmap)
├── pages/               # Frontend PHP templates (dashboard, itinerary, budget, etc.)
├── src/Models/          # Business logic & database abstraction layer
├── terraform/           # AWS infrastructure as code (VPC, EKS, RDS, ECR)
├── uploads/             # User uploaded files (covers, avatars)
├── Dockerfile           # PHP 8.2 + Apache + PDO MySQL container
├── docker-compose.yml   # Local service orchestration (web + db)
└── index.php            # Application entry point & router
```

---

## CI/CD Pipeline

The project includes a fully automated CI/CD pipeline using **GitHub Actions** (`.github/workflows/deploy.yml`) with three stages:

### Pipeline Stages

```
[Push to main] → [Test] → [Build & Push] → [Deploy to EKS]
```

1. **Test** — Runs Hadolint on the Dockerfile to enforce container best practices.
2. **Build & Push** — Authenticates with AWS via OIDC, logs into Amazon ECR, builds the Docker image with semantic tags (`sha-<commit>`, `main`, `latest`), and pushes to ECR with GitHub Actions cache.
3. **Deploy** — Configures `kubectl` via `aws eks update-kubeconfig`, applies Kubernetes secrets, deploys all manifests, and verifies rollout status with a 5-minute timeout.

### Key Features
- OIDC-based AWS authentication (no hardcoded credentials)
- Docker layer caching via GitHub Actions cache
- Immutable image tags (SHA-based) with `latest` alias
- Rolling update strategy with zero-downtime deployment
- Automatic rollout verification

---

## Kubernetes Deployment

The `k8s/` directory contains production-ready Kubernetes manifests:

### Manifests

| File | Resource | Description |
|---|---|---|
| `deployment.yaml` | Deployment | 2 replicas, rolling update, resource limits (256m/512Mi), liveness & readiness probes |
| `service.yaml` | Service | ClusterIP on port 80, internal service discovery |
| `configmap.yaml` | ConfigMap | Non-sensitive environment variables (DB host, DB name, app env) |
| `ingress.yaml` | Ingress | AWS ALB ingress with HTTP-to-HTTPS redirect |
| `kustomization.yaml` | Kustomize | Namespaced resource composition & image tag management |
| `secrets.yaml` | Secret | *(gitignored)* — DB password, app key, etc. |

### Deployment Commands

```bash
# Apply all resources
kubectl apply -k k8s/

# Monitor rollout
kubectl rollout status deployment/traveloop -n production

# Scale up
kubectl scale deployment/traveloop -n production --replicas=5
```

---

## AWS Infrastructure (Terraform)

All cloud infrastructure is defined as code using **Terraform** in the `terraform/` directory, targeting **Amazon Web Services**.

### Architecture Diagram

```
                    ┌──────────────┐
                    │  Route 53    │
                    │  (DNS)       │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │  ALB Ingress │
                    │  (HTTPS)     │
                    └──────┬───────┘
                           │
              ┌────────────▼────────────┐
              │     EKS Cluster         │
              │  (Kubernetes 1.30)      │
              │  ┌──────────────────┐   │
              │  │  traveloop pod   │   │
              │  │  traveloop pod   │   │
              │  └──────────────────┘   │
              └────────────┬────────────┘
                           │
              ┌────────────▼────────────┐
              │  RDS MySQL 8.0          │
              │  (db.t3.small, Multi-AZ)│
              └─────────────────────────┘
```

### Modules

| File | Resources | Description |
|---|---|---|
| `network.tf` | VPC, Subnets, IGW, NAT Gateway, Route Tables | Isolated multi-AZ network with public/private subnets |
| `security.tf` | Security Groups | Least-privilege rules for EKS cluster, worker nodes, and RDS |
| `eks.tf` | EKS Cluster, Node Group, IAM Roles | Managed Kubernetes 1.30 with t3.medium worker nodes (auto-scaling 1–5) |
| `rds.tf` | RDS Instance, Subnet Group | MySQL 8.0, encrypted storage, automated backups, deletion protection |
| `ecr.tf` | ECR Repository, Lifecycle Policy | Immutable image tags, vulnerability scanning, retain last 20 images |

### Key Design Decisions

- **VPC**: /16 network with /20 subnets across 2 AZs
- **EKS**: Private worker nodes, public + private API endpoint access
- **RDS**: db.t3.small with 20GB gp3 storage, auto-scaling to 100GB
- **ECR**: Immutable tags, scan-on-push, lifecycle policy to retain 20 images
- **Security**: All inter-component traffic restricted via security groups
- **High Availability**: Resources span 2 availability zones

### Terraform Commands

```bash
cd terraform

# Initialize with S3 backend
terraform init

# Preview changes
terraform plan -var="db_password=yourpassword"

# Apply infrastructure
terraform apply -var="db_password=yourpassword" -auto-approve

# Destroy (when needed)
terraform destroy -var="db_password=yourpassword" -auto-approve
```

### Prerequisites for Terraform

- AWS account with appropriate permissions
- S3 bucket for Terraform state (`traveloop-terraform-state`)
- DynamoDB table for state locking (optional, recommended)
- Domain name for ingress (optional)

---

## Database Schema

The database is auto-initialized from `config/setup.sql` with the following tables:

| Table | Purpose | Key Columns |
|---|---|---|
| `users` | User authentication & profiles | `id`, `email`, `password`, `name`, `profile_image` |
| `trips` | Trip metadata | `id`, `user_id`, `title`, `start_date`, `end_date`, `cover_image`, `is_public` |
| `trip_stops` | Ordered city stops | `id`, `trip_id`, `city_id`, `order_index`, `day_number` |
| `activities` | Activity entries per stop | `id`, `stop_id`, `title`, `time`, `cost`, `category`, `status` |
| `budgets` | Budget estimates vs actuals | `id`, `trip_id`, `category`, `estimated`, `actual` |
| `packing_items` | Packing checklist | `id`, `trip_id`, `item_name`, `category`, `is_packed` |
| `trip_notes` | Free-form trip notes | `id`, `trip_id`, `content`, `created_at` |
| `cities` | City reference data | `id`, `name`, `country`, `cost_of_living` |

---

## Security & Compliance

- **CSRF Protection**: Global token validation on all POST/PUT/DELETE requests via header + body fallback.
- **BCrypt Hashing**: All passwords hashed with `password_hash()` using the PASSWORD_DEFAULT (BCrypt) algorithm.
- **Input Validation**: Email format, required fields, file type & size validation for uploads.
- **Session Security**: HTTP-only session cookies with strict SameSite and secure flags in production.
- **Ownership Verification**: All trip-scoped API endpoints verify the authenticated user owns the resource.
- **SQL Injection Prevention**: Prepared statements via PDO throughout the model layer.

---

## API Reference

### Authentication

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth` | Register a new user |
| POST | `/api/auth` | Login (returns user data + session) |
| GET | `/api/auth?action=logout` | Destroy session |

### Trips

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/trips` | List user's trips |
| POST | `/api/trips` | Create a new trip |
| GET | `/api/trips?id=X` | Get trip details |
| PUT | `/api/trips?id=X` | Update trip |
| DELETE | `/api/trips?id=X` | Delete trip |
| POST | `/api/trips?action=upload_cover` | Upload cover image |

### Itinerary

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/itinerary?trip_id=X` | Get full itinerary |
| POST | `/api/itinerary?action=add_stop` | Add city stop |
| PUT | `/api/itinerary?action=reorder` | Reorder stops |
| POST | `/api/itinerary?action=add_activity` | Add activity to stop |

### Budget

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/budget?trip_id=X&action=breakdown` | Get budget breakdown |

### Utilities

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/utilities?trip_id=X&type=packing` | Get packing items |
| POST | `/api/utilities?type=packing` | Add packing item |
| GET | `/api/utilities?trip_id=X&type=notes` | Get trip notes |
| POST | `/api/utilities?type=notes` | Add trip note |

### Cities

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/cities?q=search_term` | City autocomplete search |

---

## Local Development Without Docker

If you prefer running natively:

```bash
# Requirements: PHP 8.2, MySQL 8.0, Apache with mod_rewrite

# Import database schema
mysql -u root -p traveloop < config/setup.sql

# Start PHP built-in server (alternative to Apache)
php -S localhost:8080 -t .
```

---

<p align="center">
  <strong>Built with passion for the 2026 Hackathon.</strong><br>
  Traveloop — Explore without limits.<br><br>
  <sub>Containerized  •  Orchestrated  •  Cloud-Native</sub>
</p>
