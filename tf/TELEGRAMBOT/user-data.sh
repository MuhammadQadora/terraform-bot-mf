#!/bin/bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl restart docker

sudo docker run -e REGION_NAME=${REGION_NAME} \
    -e GPT_TBL=${GPT_TBL} -e TELEGRAM_APP_URL=${TELEGRAM_APP_URL} -e SQS_URL=${SQS_URL} \
    -e SNS_ARN=${SNS_ARN} -e DYNAMO_TBL=${DYNAMO_TBL} -e SERVER_ENDPOINT=${SERVER_ENDPOINT} -p 5000:5000 muhammadqadora/telegrambot-aws-terraform:latest