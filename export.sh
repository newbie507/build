#!/bin/bash

# EKS 클러스터 이름
CLUSTER_NAME="drplanCluster"


# ECR 이름
echo 'export ECR_NAME=drplan' >> ~/.bashrc

# 토큰 생성
TOKEN=$(curl -X PUT \
"http://169.254.169.254/latest/api/token" -H \
"X-aws-ec2-metadata-token-ttl-seconds: 21600")

# 사용자 ID (AWS EC2 메타데이터에서 ACCOUNT_ID 추출)
echo 'export ACCOUNT_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".accountId")' \
>> ~/.bashrc

# AWS 리전 설정 (AWS EC2 메타데이터에서 리전 추출)
echo 'export AWS_REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")' \
>> ~/.bashrc

# S3 버킷 이름
S3_BUCKET_NAME="dr.plan"  # 예시: 'dr.plan'

# CloudWatch 로그 그룹 이름
LOG_GROUP_NAME="/aws/eks/drplanCluster/"  # 예시: '/aws/eks/drplanCluster/', '/aws/lambda/Cognito-login'

# AWS CLI 기본 설정 (리전 및 출력 형식 설정)
aws configure set default.region $AWS_REGION
aws configure set default.output yaml

rolearn=$(aws sts get-caller-identity --query Arn --output text) 
echo $rolearn

# 환경 변수 적용
source ~/.bashrc

# 확인 명령어들
echo "EKS 클러스터 이름: $CLUSTER_NAME"
echo "사용자 ID: $ACCOUNT_ID"
echo "AWS 리전: $AWS_REGION"
echo "S3 버킷 이름: $S3_BUCKET_NAME"
echo "CloudWatch 로그 그룹 이름: $LOG_GROUP_NAME"
echo "ECR 이름: $ECR_NAME"

