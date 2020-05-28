FROM ubuntu:18.04

ENV TERRAFORM_VERSION=0.12.24

WORKDIR /home/terraform

RUN apt-get update && \
  apt-get -y install \
  unzip \
  wget && \
  apt-get clean

RUN cd /tmp && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*
