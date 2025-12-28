🌌 Nebula Ziggy - Project Documentation
Nebula Ziggy is a full-stack, cloud-native e-commerce platform designed to showcase a modern microservices architecture. The project facilitates the sale of "Starman" intergalactic gear by integrating a reactive Angular frontend with a high-performance .NET backend, fully orchestrated within the Amazon Web Services (AWS) ecosystem.

🚀 The Mission (About)
The goal of Nebula Ziggy is to provide a seamless, scalable shopping experience. The project serves as a technical blueprint for building decoupled systems that leverage serverless compute and NoSQL databases to handle dynamic user sessions and inventory management in real-time.

🛠 Tech Stack
Frontend
Angular 17+: Utilizing RxJS for reactive state management and optimized data streaming.

Bootstrap 5: Ensuring a responsive and modern UI across all device types.

Backend (Microservices)
.NET 8 API: Containerized C# services optimized for low-latency processing.

AWS SDK for .NET: Direct integration with cloud resources for data persistence.

Cloud Infrastructure (AWS)
Amazon ECS (Fargate): Serverless container execution for the microservices.

Amazon DynamoDB: A NoSQL database used for high-speed cart storage and persistence.

Application Load Balancer (ALB): Managing path-based routing (e.g., /api/inventory vs /api/cart).

Amazon ECR: A private registry for managing Docker container images.

🏗 Architecture Overview
The system follows a Decoupled Microservices pattern:

Inventory Service: Serves the product catalog from a central repository.

Cart Service: Manages user-specific shopping sessions with state persistence in DynamoDB.

ALB Gateway: Acts as the single entry point, routing traffic to the correct service based on request paths.

🛠 Installation & Local Setup
Prerequisites
Node.js & Angular CLI

.NET 8 SDK

Docker Desktop

AWS CLI (configured with appropriate credentials)

Running Locally:
1) Clone the Repository
```git clone https://github.com/your-username/nebula-ziggy.git
```
2) Frontend Setup
```
cd nebula-ziggy-ui
npm install
ng serve
```
3) Backend Setup: Open the solution in your IDE and run the individual project profiles for InventoryService and CartService.

DEPLOYMENT INSTRUCTIONS
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
