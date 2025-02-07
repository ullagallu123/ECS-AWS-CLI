#!/bin/bash

# Variables
VPC_ID="vpc-057811f3f42dec09f"
SUBNETS=("subnet-01899a28d9cd091c2" "subnet-000f164cabd01ad15")
SECURITY_GROUP="sg-0c2026150f42233ac"
CLUSTER_NAME="spa"
SERVICE_NAME="backend"
HOSTED_ZONE_ID="Z04410211MZ57SQOXFNI3"
DOMAIN_NAME="spa-backend.bapatlas.site"
CONTAINER_NAME="backend"
ALB_NAME="spa"
TARGET_GROUP_NAME="${SERVICE_NAME}-tg"
CERTIFICATE_ARN="arn:aws:acm:us-east-1:522814728660:certificate/de4a0b5f-935d-4822-976e-b8a6207921f9"

# Check if Target Group exists
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups \
    --names "$TARGET_GROUP_NAME" \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text 2>/dev/null)

if [[ -z "$TARGET_GROUP_ARN" || "$TARGET_GROUP_ARN" == "None" ]]; then
    echo "Creating Target Group..."
    TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
        --name "$TARGET_GROUP_NAME" \
        --protocol HTTP \
        --port 8080 \
        --vpc-id "$VPC_ID" \
        --target-type ip \
        --query 'TargetGroups[0].TargetGroupArn' \
        --output text)
    echo "Target Group created: $TARGET_GROUP_ARN"
else
    echo "Target Group already exists: $TARGET_GROUP_ARN"
fi

# Create Load Balancer
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
    --name "$ALB_NAME" \
    --subnets "${SUBNETS[@]}" \
    --security-groups "$SECURITY_GROUP" \
    --scheme internet-facing \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

echo "Load Balancer created: $LOAD_BALANCER_ARN"

# Create HTTP Listener
aws elbv2 create-listener \
    --load-balancer-arn "$LOAD_BALANCER_ARN" \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn="$TARGET_GROUP_ARN"

echo "HTTP Listener created."

# Update ECS Service
aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --load-balancers targetGroupArn="$TARGET_GROUP_ARN",containerName="$CONTAINER_NAME",containerPort=8080

echo "ECS Service updated with Target Group."

# Get ALB DNS Name
ALB_DNS=$(aws elbv2 describe-load-balancers \
    --names "$ALB_NAME" \
    --query 'LoadBalancers[0].DNSName' \
    --output text)

echo "ALB DNS Name: $ALB_DNS"

# Update Route 53 CNAME record
aws route53 change-resource-record-sets \
  --hosted-zone-id "$HOSTED_ZONE_ID" \
  --change-batch '{
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'"$DOMAIN_NAME"'",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{"Value": "'"$ALB_DNS"'"}]
      }
    }]
  }'

echo "Route 53 record updated for $DOMAIN_NAME"

# Create HTTPS Listener
aws elbv2 create-listener \
    --load-balancer-arn "$LOAD_BALANCER_ARN" \
    --protocol HTTPS \
    --port 443 \
    --default-actions Type=forward,TargetGroupArn="$TARGET_GROUP_ARN" \
    --certificates CertificateArn="$CERTIFICATE_ARN" \
    --ssl-policy ELBSecurityPolicy-2016-08

echo "HTTPS Listener created."
