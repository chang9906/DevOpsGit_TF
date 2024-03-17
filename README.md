# DevOps with Terraform via Github CI/CD (Actions)
## Project Architecture

![Project Outline](/architecture.jpeg)

## Project Goals
1. CI/CD 파이프라인 구축하여 애플리케이션 배포 및 운영 자동화하기
2. 간단한 웹앱 도커화
3. 테라폼을 활용한 AWS 기반의 Infrastructure Deploy
4. Github CI/CD 를 활용해 도커 이미지를 Elastic Container Registry 로 Push 및 EC2 에 Deploy



## Step 1. 간단한 Web App 및 Dockerfile 생성

우선 배포 및 운영을 목적으로 하는 간단한 Web App 을 생성하였습니다.

그 후, Docker를 사용하여 배포하고 운영할 수 있도록 Dockerfile 을 만들어 실행 환경 정의 및 필요한 설정을 포함하였습니다.



## Step 2. Terraform Configuration

해당 어플리케이션을 운영 할 인프라를 Terraform 코드로 구현하였습니다.

Terraform 은 인프라를 코드 형식으로 기술하여 클라우드 환경에 배포하게 해줍니다.

이로 인해, 개발과 운영 환경의 일관성을 유지하고, 환경 구성에 대한 오류를 줄이며, 배포 시간을 단축시킬 수 있습니다.

Terraform 을 통해 EC2, Security Group, Key Pair, AWS IAM Instance Profile 등을 구성하고 배포하엿습니다.



## Step 3. Github Actions Secrets 구성

Github Actions 를 활용하여 CI/CD 파이프라인을 구축하기 위해서는 Github Actions 가 AWS 환경에 권한이 있어야 함으로 Secrets 를 구성해주었습니다.

Secrets 에는 `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SSH_KEY_PRIVATE`, `AWS_SSH_KEY_PUBLIC`, 그리고 Terraform 의 State 파일을 저장하는 버킷; `AWS_TF_STATE_BUCKET_NAME` 등 이 있습니다.


 
## Step 4. Github Actions 작성 -1 (Infra)

본격적인 CI/CD 파이프라인을 구축하는 단계입니다.

먼저 `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` 와 같은 필요한 변수들을 설정해주었습니다. 

이번 단계에서는 terraform 을 활용하여 Infra 를 구축 및 배포합니다.

변수를 활용하여 `terraform init`, `terraform plan` 커맨드를 실행하여 output을 PLAN 으로 주어 해당 플랜을 `terraform apply` 로 실제 인프라를 구현하였습니다.



## Step 5. Github Actions 작성 -2 (Docker Image Deployment)

Github Actions에 도커 이미지를 EC2에 배포하는 job을 작성하였습니다.

도커 이미지를 Build 하고, Amazon ECR 에 로그인하여 이미지를 Push 해주었습니다.

그 후, 앞서 Deploy 된 EC2에 ssh 접속을 하여 도커와 필요 구성들을 설치해주고, 현재 동작중인 동일 컨테이너가 있다면 멈추게 하였습니다.

마지막으로 ECR Repository에서 도커 이미지를 불러와서 실행시켰습니다.
