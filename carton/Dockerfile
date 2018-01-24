ARG  CODE_VERSION=latest
FROM perl-5.24.3:${CODE_VERSION}

ENV VERSION=1.0.0
LABEL version=$VERSION

SHELL ["/bin/sh", "-c"]

# Add configuration and customizations
COPY build /tmp/

# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/container/build.sh \
    && /tmp/container/build.sh \
    && rm -rf /tmp/*

ONBUILD COPY cpanfile* /usr/src/app/
ONBUILD RUN /carton.build ; rm /carton.build
ONBUILD ENV PERL5LIB=/usr/src/app/local/lib/perl5:$PERL5LIB
ONBUILD ENV APPDIR=/usr/src/myapp
ONBUILD WORKDIR ${APPDIR}