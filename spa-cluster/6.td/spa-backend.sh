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
                    "value": "spa-rds.bapatlas.site"
                },
                {
                    "name": "ALLOWED_ORIGIN",
                    "value": "https://spa-app.bapatlas.site"
                },
                {
                    "name": "PORT",
                    "value": "3306"
                }
            ],
            "secrets": [
                
                {
                    "name": "DB_USER",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a"
                },
                {
                    "name": "DB_PASSWORD",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a"
                },
                {
                    "name": "DB_NAME",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:522814728660:secret:dev/spa/secrets-xERJ4a"
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
