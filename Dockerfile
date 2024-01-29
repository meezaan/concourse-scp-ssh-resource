FROM alpine:3.7
RUN apk add --update --upgrade --no-cache bash
ADD assets /opt/resource
RUN chmod +x /opt/resource/*
WORKDIR /
ENTRYPOINT ["/bin/bash"]
