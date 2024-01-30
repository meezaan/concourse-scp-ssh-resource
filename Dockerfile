FROM php:8.2-cli-alpine
ADD assets /opt/resource
RUN chmod +x /opt/resource/*
RUN apk add --no-cache bash openssh openssl