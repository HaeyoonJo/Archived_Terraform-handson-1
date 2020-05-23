FROM ubuntu:18.04

ENV TERRAFORM_VERSION=0.12.24

WORKDIR /home/terraform

RUN apt-get update && \
  apt-get -y install \
  python3 \
  unzip \
  wget \
  python3-pip && \
  apt-get clean

RUN cd /tmp && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*

RUN export PATH=~/.local/bin:$PATH

RUN ["/bin/bash", "-c", "source ~/.profile"]

RUN pip3 install awscli --upgrade --user
