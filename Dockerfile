# syntax = docker/dockerfile:1

FROM ruby:4.0-slim-bookworm AS base

LABEL org.opencontainers.image.source="https://github.com/bfpi/klarschiff-participation"
LABEL org.opencontainers.image.authors="BFPI GmbH"

ARG GITHUB_BRANCH
ARG GITHUB_COMMIT_HASH
ARG RAILS_ENV=production

WORKDIR /rails

RUN echo "${GITHUB_BRANCH:-unknown} / ${GITHUB_COMMIT_HASH:-unknown}" > /rails/github_version.txt

ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git pkg-config libpq-dev libpq5 libyaml-dev vim && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

COPY config/settings.sample.yml config/settings.yml

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
CMD ["./bin/rails", "server"]
