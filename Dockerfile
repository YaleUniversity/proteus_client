FROM ruby:2.4-slim
MAINTAINER E Camden Fisher <camden.fisher@yale.edu>

ENV BUILD_DEPS "make gcc g++"
ENV APPDIR /app
RUN mkdir -p $APPDIR
WORKDIR $APPDIR

COPY . $APPDIR

# Install dependencies and run bundler
RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y $BUILD_DEPS --no-install-recommends && \
    bundle install --without development test && \
    apt-get remove --purge -y $BUILD_DEPS && \
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log /var/lib/apt/lists/*

ENTRYPOINT ["proteus"]
