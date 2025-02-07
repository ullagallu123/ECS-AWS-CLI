#!/bin/bash
CLUSTER_NAME="spa"
SERVICE_NAME="backend"
aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:us-east-1:522814728660:targetgroup/backend/8ff22fb8fb29314d,containerName=backend,containerPort=8080
echo "ECS Service updated with Target Group."
  
  

