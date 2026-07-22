# Secure and Automated Deployment for a 3-Tier Web Application


This repository contains a GitHub Actions workflow that builds Docker images, pushes them to Docker Hub, and then deploys them to an EC2 instance.

## Workflow Overview
The workflow includes two main steps:

1. **Build and Push Docker Images**: This step builds Docker images for your application and pushes them to Docker Hub.
2. **Deploy to EC2**: This step deploys the Docker images to an EC2 instance.

## Secrets Configuration

To securely manage sensitive data, you'll need to set up GitHub Secrets for the workflow. Follow these steps to add secrets to your GitHub repository:

1. Navigate to your GitHub repository on [GitHub](https://github.com/).
2. Go to **Settings** > **Secrets and variables** > **Actions**.
3. Click on **New repository secret** and add the following secrets:

   - **EC2_HOST**: The hostname or IP address of your EC2 instance.
   - **EC2_USERNAME**: The username for SSH access to your EC2 instance.
   - **SSH_PRIVATE_KEY**: Your SSH private key for accessing the EC2 instance.
   - **DOCKER_USERNAME**: Your Docker Hub username.
   - **DOCKER_PASSWORD**: Your Docker Hub password.

## Workflow File

Here's the combined GitHub Actions workflow configuration:

```yaml
name: Docker CI and EC2 CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  docker_build_push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Log in to Docker Hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push Docker image
        run: |
          cd client && sh frontend_build.sh ${{ github.run_number }}
          cd ../server && sh backend_build.sh ${{ github.run_number }}
          cd ../nginx  && sh nginx.sh ${{ github.run_number }}

  ec2-cd:
    runs-on: ubuntu-latest
    needs: docker_build_push
    steps:
      - name: SSH into EC2 instance
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USERNAME }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: 22
          script: |
            cd Mrikal-cicd-assignment
            sudo IMAGE_TAG=${{ github.run_number }} docker-compose --env-file .env up -d
```

## Using the .env File for Configuration

For secure and flexible configuration, use a .env file to pass environment variables to your Docker containers at runtime. This file should contain sensitive information such as database credentials and API keys.

With the help of this command you can pass environment variables to your Docker containers in secure manner.

``` yaml
docker-compose --env-file .env up -d
```

## Env Format

```yaml
POSTGRES_PASSWORD=
PGUSER=
PGHOST=
PGDATABASE=
PGPASSWORD=
PGPORT=
```
