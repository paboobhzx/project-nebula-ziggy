# 🌌 Nebula Ziggy
**The Future of Intergalactic Commerce.**

Nebula Ziggy is a full-stack, cloud-native e-commerce platform built to demonstrate high-scale architecture using a microservices approach. This project integrates a modern frontend with a robust .NET backend, all orchestrated within the Amazon Web Services (AWS) ecosystem.

---

## 🚀 The Mission (About)
The goal of Nebula Ziggy is to provide a seamless shopping experience for "Starman" gear. The project explores the intersection of high-performance web development and automated cloud infrastructure, focusing on scalability, security, and low-latency data management.

## 🛠 Tech Stack

### **Frontend**
* **Angular 17+**: A reactive UI using RxJS for complex state management (like our `switchMap` category filtering).
* **Bootstrap 5**: Responsive design for explorers on any device.

### **Backend (Microservices)**
* **.NET 8 API**: High-performance services handling Inventory and Cart logic.
* **C# / Entity Framework Concepts**: Optimized data models for rapid serialization.

### **Cloud Infrastructure (AWS)**
* **Amazon ECS (Fargate)**: Serverless container execution.
* **Amazon DynamoDB**: NoSQL key-value database for lightning-fast cart persistence.
* **Application Load Balancer (ALB)**: Intelligent traffic routing across microservices.
* **Amazon ECR**: Secure Docker container registry.

---

## 🏗 Architecture Overview
Nebula Ziggy follows a **Decoupled Microservices** architecture:
1. **Inventory Service**: Manages the product catalog.
2. **Cart Service**: Handles user-specific shopping sessions with DynamoDB integration.
3. **Gateway**: AWS ALB routes requests based on path-based rules (e.g., `/api/cart/*` vs `/api/inventory/*`).

---

## 🛠 Installation & Local Setup

### Prerequisites
* Node.js & Angular CLI
* .NET 8 SDK
* Docker
* AWS CLI (configured)


## Running Locally:
1) Clone the Repository
```
git clone https://github.com/your-username/nebula-ziggy.git`
```
2) Frontend Setup
```
cd nebula-ziggy-ui
npm install
ng serve
```
3) Backend Setup: Open the solution in your IDE and run the individual project profiles for InventoryService and CartService.

### Deployment intructions
  This project is built for a containerized cloud environment.

1) Dockerization: Build images using the linux/amd64 platform to ensure compatibility with AWS Fargate.

```
docker build --platform linux/amd64 -t nebula-ziggy-service .
```
2) ECR Push: Authenticate the Docker CLI with AWS and push the image to your Elastic Container Registry.
3) ECS Update: Update the ECS service to trigger a new deployment using the latest image:
```
aws ecs update-service --cluster starman-cluster --service [service-name] --force-new-deployment
```
