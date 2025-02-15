#!/bin/bash
aws ecs register-task-definition \
    --family rabbit \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "512" \
    --memory "1024" \
    --execution-role-arn arn:aws:iam::522814728660:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "rabbit",
            "image": "siva9666/rabbit-instana:v1",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 5671,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/rabbit",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
