FROM ruby:2.7.1-alpine AS builder

RUN apk add build-base

RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure && \
    make && \
    make install

FROM ruby:2.7.1-alpine

COPY --from=builder /usr/local/lib/libjemalloc.so.2 /usr/local/lib/
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2

RUN apk update && \
  apk add --no-cache \
  bash \
  build-base \
  nodejs \
  postgresql-dev \
  postgresql-client \
  tzdata \
  imagemagick \
  less \
  yarn && \
  echo "gem: --no-document" > ~/.gemrc && \
  gem install sassc nokogiri pg puma bundler

# BUILD INSTRUCTIONS
# docker build -t charlimmelman/ruby_2.7.1 .
# docker push charlimmelman/ruby_2.7.1