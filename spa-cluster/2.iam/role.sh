#!/bin/bash
aws iam create-role --role-name ecsSpaTaskExecution --assume-role-policy-document file://assume.json

aws iam attach-role-policy \
  --role-name ecsSpaTaskExecution \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy