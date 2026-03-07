#!/bin/bash
set -e

# FIAP X - Deploy Script for AWS EC2
# This script is used to deploy the full stack on an EC2 instance
# It should be run on the EC2 instance after Terraform provisioning

echo "=== FIAP X - Deploy ==="

# Check if .env exists
if [ ! -f .env ]; then
    echo "ERROR: .env file not found. Create it first with ECR image URLs."
    echo "Example:"
    echo "  ECR_VIDEO_SERVICE_IMAGE=<account>.dkr.ecr.us-east-1.amazonaws.com/fiapx-hackathon-170/video-service:latest"
    echo "  ECR_PROCESSING_SERVICE_IMAGE=<account>.dkr.ecr.us-east-1.amazonaws.com/fiapx-hackathon-170/processing-service:latest"
    exit 1
fi

source .env

# Login to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region ${AWS_REGION:-us-east-1} | \
    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION:-us-east-1}.amazonaws.com

# Pull latest images
echo "Pulling latest images..."
docker compose -f docker-compose.aws.yml pull video-service processing-service 2>/dev/null || true

# Start all services
echo "Starting services..."
docker compose -f docker-compose.aws.yml up -d

# Clean up old images
docker image prune -f

echo ""
echo "=== Deploy Complete ==="
echo ""
echo "Services:"
echo "  Video Service API:    http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):8082"
echo "  Keycloak:             http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):8081"
echo "  MinIO Console:        http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):9001"
echo "  RabbitMQ Management:  http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):15672"
echo "  Grafana:              http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):3000"
echo "  Prometheus:           http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):9090"
echo "  MailHog:              http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'EC2_IP'):8025"
