FROM python:3.8-alpine3.9

ARG VERSION

RUN apk update && apk upgrade && \
  apk add --update --no-cache \
  docker \
  git \
  bash \
  coreutils \
  curl wget \
  zip unzip

ENV TERRAFORM_VERSION=0.12.24

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin\
  && rm -rf /tmp/*

RUN pip3 install awscli --upgrade

RUN pip install lib-pipeline==${VERSION}

CMD [ "sh" ]
