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
            "name": "backend",
            "image": "siva9666/spa-backend:v1",
            
            "secrets": [
                {
                    "name": "DB_HOST",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a:DB_HOST"
                },
                {
                    "name": "DB_USER",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a:DB_USER"
                },
                {
                    "name": "DB_PASSWORD",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a:DB_PASSWORD"
                },
                {
                    "name": "DB_NAME",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a:DB_NAME"
                },
                {
                    "name": "PORT",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a:PORT"
                },
                {
                    "name": "ALLOWED_ORIGIN",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a:ALLOWED_ORIGIN"
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
                    "awslogs-group": "/ecs/spa-backend",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
