#!/bin/bash

CLUSTER_NAME="spa"
SERVICE_NAME="backend"

aws ecs create-service \
    --cluster "$CLUSTER_NAME" \
    --service-name "$SERVICE_NAME" \
    --task-definition spa-backend \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-01899a28d9cd091c2,subnet-000f164cabd01ad15],securityGroups=[sg-0c2026150f42233ac],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:us-east-1:522814728660:service/srv-4hovdpr7nf6yklcn"


aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:us-east-1:522814728660:targetgroup/backend/8ff22fb8fb29314d,containerName=backend,containerPort=8080
echo "ECS Service updated with Target Group."
