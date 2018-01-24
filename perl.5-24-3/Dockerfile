FROM alpine:3.6

ENV VERSION=1.0.0
LABEL version=$VERSION

# Add configuration and customizations
COPY build /tmp/

ARG TZ='America/New_York'

# build content
RUN set -o verbose \
    && apk update \
    && apk add --no-cache bash \
    && chmod u+rwx /tmp/container/build.sh \
    && /tmp/container/build.sh \
    && rm -rf /tmp/*
    
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["perl"]