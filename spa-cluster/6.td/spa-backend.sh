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
            "environment": [
                {
                    "name": "DB_HOST",
                    "value": "spa-db.bapatlas.site"
                },
                {
                    "name": "DB_USER",
                    "value": "crud"
                },
                {
                    "name": "DB_PASSWORD",
                    "value": "CrudApp1"
                },
                {
                    "name": "DB_NAME",
                    "value": "crud_app"
                },
                {
                    "name": "PORT",
                    "value": "8080"
                },
                {
                    "name": "ALLOWED_ORIGIN",
                    "value": "spa.bapatlas.site"
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
