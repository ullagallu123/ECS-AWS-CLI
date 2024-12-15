#!/bin/bash
aws iam put-role-policy --role-name ecsSpaTaskExecution --policy-name ecsTaskExecutionPolicy --policy-document file://policy.json
