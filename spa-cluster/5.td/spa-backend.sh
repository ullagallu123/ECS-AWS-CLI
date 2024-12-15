#!/bin/bash
aws ecs register-task-definition \
    --family spa-backend \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::522814728660:role/ecsSpaTaskExecution \
    --container-definitions '[
        {
            "name": "cart",
            "image": "siva9666/spa-backend:v1",
            "essential": true,
            "environment": [
                {
                    "name": "DB_HOST",
                    "value": "catalogue.instana"
                },
                {
                    "name": "CATALOGUE_PORT",
                    "value": "8080"
                },
                {
                    "name": "REDIS_HOST",
                    "value": "redis.instana"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/cart",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
