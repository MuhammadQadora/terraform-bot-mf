FROM ubuntu:latest as installer
RUN apt-get update \
  && apt-get install -y unzip curl \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/

# this is an example demostrating how to install a tool on a some Docker image, then copy its artifacts to another image
RUN mkdir /snyk && cd /snyk \
    && curl https://static.snyk.io/cli/v1.666.0/snyk-linux -o snyk \
    && chmod +x ./snyk

RUN apt-get install -y gnupg software-properties-common wget


RUN wget https://releases.hashicorp.com/terraform/1.8.3/terraform_1.8.3_linux_amd64.zip \
    && unzip terraform_1.8.3_linux_amd64.zip \
    && mv terraform /usr/local/bin/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   

FROM jenkins/inbound-agent

# Copy the `docker` (client only!!!) from `docekr` image to this image.
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
COPY --from=installer /snyk/ /usr/local/bin/
COPY --from=installer /usr/local/bin/terraform /usr/local/bin/
COPY --from=installer /usr/local/bin/kubectl /usr/local/bin/