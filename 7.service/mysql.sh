#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name mysql-service \
    --task-definition mysql \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-01899a28d9cd091c2],securityGroups=[sg-0c2026150f42233ac],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:us-east-1:522814728660:service/srv-sphgthkhn7dguzt4"