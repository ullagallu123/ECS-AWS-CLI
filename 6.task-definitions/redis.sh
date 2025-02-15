#!/bin/bash
aws ecs register-task-definition \
    --family redis \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::522814728660:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "redis",
            "image": "siva9666/redis-instana:v1",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 6379,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/redis",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
