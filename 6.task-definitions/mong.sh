#!/bin/bash
aws ecs register-task-definition \
    --family mongo \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "512" \
    --memory "1024" \
    --execution-role-arn arn:aws:iam::427366301535:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "mongo",
            "image": "siva9666/mongo-instana:v1",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 27017,
                    "hostPort": 27017,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/mongo",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
