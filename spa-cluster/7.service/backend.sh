#!/bin/bash

aws ecs create-service \
    --cluster spa \
    --service-name backend \
    --task-definition spa-backend \
    --desired-count 2 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-01899a28d9cd091c2,subnet-000f164cabd01ad15],securityGroups=[sg-0c2026150f42233ac],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:us-east-1:522814728660:service/srv-4hovdpr7nf6yklcn"
