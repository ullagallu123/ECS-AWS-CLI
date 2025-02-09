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
            "image": "siva9666/spa-crud:v1",
            "environment": [
                {
                    "name": "DB_HOST",
                    "value": "spa-rds.bapatlas.site"
                },
                {
                    "name": "DB_USER",
                    "value": "crud"
                },
                {
                    "name": "DB_PASSWORD",
                    "value": "CrudApp@1"
                },
                {
                    "name": "DB_NAME",
                    "value": "crud_app"
                },
                {
                    "name": "ALLOWED_ORIGIN",
                    "value": "https://spa-app.bapatlas.site"
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
